//
//  TimeLineViewController.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/18.
//  Copyright © 2018年 Alex.  All rights reserved.
//

#import "TimeLineViewController.h"
#import "TimeLineTableView.h"
#import "TimeLineCell.h"
#import "TimeLineLayout.h"
#import "TimeLineHaderView.h"
#import "TestViewController.h"
#import "YYModel.h"
#import "TestWebViewController.h"
#import "TimeLineMenuView.h"
#import "TimeLineCommentView.h"
#import "UIView+Add.h"
#import "YYFPSLabel.h"

@interface TimeLineViewController ()<UITableViewDataSource, UITableViewDelegate,TimeLineCellDelegate>

@property (nonatomic, strong) TimeLineTableView *tableView;                               //  朋友圈TableView
@property (nonatomic, strong) TimeLineHaderView *headerView;                              //  headerView
@property (nonatomic, strong) TimeLineCommentView *commentView;                           //  键盘评论视图
@property (nonatomic, strong) TimeLineCommentData *commentModel;                          //  当前评论的数据
@property (nonatomic, strong) NSIndexPath *commentCellIndexPath;                          //  评论cell的indexpath
@property (nonatomic, assign) CGRect rectSelected;                                        //  评论cell的Rect
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, assign) BOOL iskeyBoardShow;
@property (nonatomic, strong) NSMutableArray<TimeLineLayout *> *layoutsArr;               //  layout布局

@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@end

@implementation TimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setup];
    
    [self p_registerNotifications];
    
    [self p_loadData];
    
    [self p_setFPSLabel];
}




#pragma mark - ScollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
    //  需要优化
    [TimeLineMenuView dismissAllMenu];
}



#pragma -mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _layoutsArr[indexPath.row].height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [TimeLineMenuView dismissAllMenu];
}



#pragma -mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _layoutsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TimeLineCell * cell = [TimeLineCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.layout = _layoutsArr[indexPath.row];
    return cell;
}



#pragma -mark TimeLineCellDelegate

/** 点击头像或者昵称 */
- (void)timelineCell_DidClickNineOrPortraitWithCell:(TimeLineCell *)cell{
    
    TestViewController *test =  [TestViewController new];
    test.title = cell.layout.model.nick;
    [self.navigationController pushViewController:test animated:YES];
}

/** 查看全文 */
- (void)timelineCell_DidClickMoreLessWithCell:(TimeLineCell *) cell{
    
    NSIndexPath * indexPath = cell.indexPath;
    TimeLineLayout * layout = self.layoutsArr[indexPath.row];
    layout.model.isOpening = !layout.model.isOpening;
    [layout resetLayout];
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    if (cellRect.origin.y < self.tableView.contentOffset.y + 64) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

/** 点击了分享内容 */
- (void)timelineCell_DidClickGrayLinkViewWithCell:(TimeLineCell *) cell{
    
    TestWebViewController *webVc = [[TestWebViewController alloc]init];
    webVc.urlStr = cell.layout.model.url;
    webVc.navigationtitle = cell.layout.model.title;
    [self.navigationController pushViewController:webVc animated:YES];
}

/** 点击了电话或者url地址 */
- (void)timelineCell:(TimeLineCell *)cell didClickUrl:(NSString *)url phone:(NSString *)phone{
    
    NSString *message = url?url:phone?phone:nil;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/** 点击评论按钮 */
- (void)timelineCell_DidClickCommentWithCell:(TimeLineCell *)cell {
    
    NSIndexPath * indexPath = cell.indexPath;
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    self.rectSelected = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    self.commentCellIndexPath = indexPath;
    //  创建评论模型
    self.commentModel = [TimeLineCommentData new];
    self.commentModel.userid = @"888";
    self.commentModel.nick = @"十年";
    self.commentView.placeHolder = @"评论";
    
    if (![self.commentView.textView isFirstResponder]) {
        [self.commentView.textView becomeFirstResponder];
    }
}

/** 回复评论 */
- (void)timelineCell_DidClickReplyCommentWithCell:(TimeLineCell *) cell CommentViewCell:(UITableViewCell *) commentCell TimeLineCommentData:(TimeLineCommentData *)model{
    
    if ([model.userid isEqualToString:@"888"])// 删除自己评论
    {
        __weak __typeof(self)weakSelf = self;
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            TimeLineLayout *layout = cell.layout;
            [layout.model.commentArr removeObject:model];
            [layout resetLayout];
            [UIView performWithoutAnimation:^{
                [weakSelf.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:action1];
        [alertVc addAction:action2];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else{
        
        NSIndexPath * indexPath = cell.indexPath;
        self.commentCellIndexPath = indexPath;
        self.rectSelected = [cell.likeCommentView.commentTableView convertRect:commentCell.frame toView:[self.tableView superview]];
        //  创建评论模型
        self.commentModel = [TimeLineCommentData new];
        self.commentModel.userid = @"888";
        self.commentModel.nick = @"十年";
        self.commentModel.toUserid = model.userid;
        self.commentModel.toNick = model.nick;
        
        self.commentView.placeHolder = [NSString stringWithFormat:@"回复%@:",model.nick];
        if (![self.commentView.textView isFirstResponder]) {
            [self.commentView.textView becomeFirstResponder];
        }
    }
}

/** 删除 */
- (void)timelineCell_DidClickDeleteWithCell:(TimeLineCell *) cell{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确认删除吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    __weak __typeof(self)weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSIndexPath * indexPath = [weakSelf.tableView indexPathForCell:cell];
        TimeLineLayout * layout = weakSelf.layoutsArr[indexPath.row];
        [weakSelf.layoutsArr removeObject:layout];
        [UIView performWithoutAnimation:^{
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView endUpdates];
        }];
      
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVc addAction:action1];
    [alertVc addAction:action2];
    [self presentViewController:alertVc animated:YES completion:nil];
}

/** 点赞和取消点赞 */
- (void)timelineCell_DidClickLikeWithCell:(TimeLineCell *)cell {
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    TimeLineLayout * layout = self.layoutsArr[indexPath.row];
    
    if (cell.layout.model.isLike)
    { //点赞
        TimeLineLikeData *likeData = [[TimeLineLikeData alloc]init];
        likeData.nick = @"十年";
        [layout.model.likeArr addObject:likeData];
    }
    else
    {// 取消点赞
        [layout.model.likeArr enumerateObjectsUsingBlock:^(TimeLineLikeData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.nick isEqualToString:@"十年"]) {
                [layout.model.likeArr removeObject:obj];
                *stop = YES;
            }
        }];
    }
    [layout resetLayout];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

/** 点击用户 */
- (void)timelineCell:(TimeLineCell *) cell didClickUserId:(NSString *) userId userNick:(NSString *) nick{
    
    TestViewController *test =  [TestViewController new];
    test.title = nick;
    [self.navigationController pushViewController:test animated:YES];
}




#pragma -mark private methods

- (void)p_setup{
    
    self.title = @"朋友圈";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commentView];
}

- (void)p_registerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppearNotifications:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)p_loadData{
    
    //  从本地加载数据
    NSArray * dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"timeline_Data01" ofType:@"plist"]];
    NSArray * dataArray1 = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"timeline_Data02" ofType:@"plist"]];
    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:dataArray];
    [tempArr addObjectsFromArray:dataArray1];
    //  使用YYModel先转模型,再转布局模型
    for (NSDictionary *dict in tempArr) {
        TimeLineData * dataModel = [TimeLineData yy_modelWithDictionary:dict];
        TimeLineLayout * layout = [[TimeLineLayout alloc] initWithModel:dataModel];
        [self.layoutsArr addObject:layout];
    }
    [self.tableView reloadData];
}

- (void)p_setFPSLabel{
    
    _fpsLabel = [YYFPSLabel new];
    _fpsLabel.frame = CGRectMake(15, self.tableView.bottom - 60, 50, 30);
    [_fpsLabel sizeToFit];
    [self.view addSubview:_fpsLabel];
}

/** 评论处理 */
- (void)p_postCommentWithModel:(TimeLineCommentData *) model{
    
    TimeLineLayout *layout = self.layoutsArr[self.commentCellIndexPath.row];
    [layout.model.commentArr addObject:model];
    [layout resetLayout];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:@[self.commentCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}


#pragma -makr keyBoardSetting

- (void)keyboardWillAppearNotifications:(NSNotification *)notifications{
    
    CGRect keyBoardFrame = [[[notifications userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
         self.commentView.frame = CGRectMake(0.0f, keyBoardFrame.origin.y - 50, kSCREENHEIGHT, 50.0f);
    }];

    CGFloat delta = CGRectGetMaxY(self.rectSelected) - (kSCREENHEIGHT - keyBoardFrame.size.height-50);
    CGPoint offset =self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y <= 0) {
        return;
    }
    if (self.isAnimation) {
        return;
    }
    if (!self.iskeyBoardShow) {
        [UIView animateWithDuration:0.25 animations:^{
            self.isAnimation = YES;
            [self.tableView setContentOffset:offset];
        } completion:^(BOOL finished) {
            self.isAnimation = NO;
            self.iskeyBoardShow = YES;
        }];
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notifications {
    self.commentView.frame = CGRectMake(0, kSCREENHEIGHT, kSCREENWIDTH, 50.0f);
    self.commentView.textView.text = @"";
    self.commentView.textView.height = 34;
    self.iskeyBoardShow = NO;
}




#pragma -mark getter

- (TimeLineTableView *)tableView{
    if (!_tableView) {
        _tableView = [[TimeLineTableView alloc]initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headerView;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

- (NSMutableArray *)layoutsArr{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}

- (TimeLineHaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TimeLineHaderView alloc]init];
    }
    return _headerView;
}

- (TimeLineCommentView *)commentView {
    if (_commentView == nil) {
        __weak typeof(self) wself = self;
        _commentView = [[TimeLineCommentView alloc] initWithFrame:CGRectMake(0, kSCREENHEIGHT, kSCREENWIDTH, 50.0f) sendBlock:^(NSString *content) {
            wself.commentModel.message = content;
            [self p_postCommentWithModel:wself.commentModel];
        }];
    }
    return _commentView;
}

@end
