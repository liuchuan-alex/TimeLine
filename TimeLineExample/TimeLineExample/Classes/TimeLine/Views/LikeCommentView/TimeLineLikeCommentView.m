//
//  TimeLineLikeCommentView.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/23.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "TimeLineLikeCommentView.h"
#import "TimeLineCommonDefine.h"
#import "YYText.h"
#import "UIView+Add.h"

@interface TimeLineLikeCommentView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bgImgView;           //  背景图片
@property (nonatomic, strong) YYLabel *likeLable;               //  点赞文字
@property (nonatomic, strong) UIView *dividerLine;              //  分割线

@property (nonatomic, strong) NSMutableArray *likeArr;          //  点赞数据
@property (nonatomic, strong) NSMutableArray *commentArr;       //  评论数据
@property (nonatomic, strong) NSMutableArray *commentLayoutArr; //  评论数据
@property (nonatomic, strong) TimeLineLayout *layout;           //  layout

@end

@implementation TimeLineLikeCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kSCREENWIDTH - kTimeLineNormalPadding * 2 - kTimeLinePortraitWidthAndHeight - kTimeLinePortraitNamePadding;;
        frame.size.height = 0;
    }
    
    if (self = [super initWithFrame:frame]) {
        [self p_setup];
    }
    return self;
}

#pragma -mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYTextLayout * layout = self.commentLayoutArr[indexPath.row];
    return layout.textBoundingSize.height + kTimeLineGrayPicPadding*2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.timelineCommentViewdidClick) {
        self.timelineCommentViewdidClick(self.commentArr[indexPath.row],cell );
    }
}

#pragma -mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentLayoutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell;//这里不使用重用机制(会出现评论窜位bug)
    YYTextLayout * layout = self.commentLayoutArr[indexPath.row];
    
    YYLabel * label;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"commentCell"];
        cell.backgroundColor = [UIColor clearColor];
        label = [YYLabel new];
        [cell addSubview:label];
    }
    
    label.top = kTimeLineGrayPicPadding;
    label.left = kTimeLineNameDetailPadding;
    label.width = self.frame.size.width - kTimeLineNameDetailPadding*2;
    label.height = layout.textBoundingSize.height;
    label.textLayout = layout;
    
    return cell;
}


#pragma -mark  设置点赞以及评论和layout动态更新视图
- (void)setLikeArr:(NSMutableArray *) likeArr commentArr:(NSMutableArray *) commentArr layout:(TimeLineLayout *) layout{
    
    _likeArr = likeArr;
    _commentArr = commentArr;
    _commentLayoutArr = layout.commentLayoutArr;
    _layout = layout;
    [self p_layoutView];
}


#pragma -mark private actions

- (void)p_setup{
    
    [self addSubview:self.bgImgView];
    [self addSubview:self.likeLable];
    [self addSubview:self.dividerLine];
    [self addSubview:self.commentTableView];
}

- (void)p_layoutView{
    
    _bgImgView.top = 0;
    _bgImgView.left = 0;
    _bgImgView.width = self.frame.size.width;
    _bgImgView.height = _layout.liekCommentHeight;
    
    UIView *lastView = _bgImgView;
    
    if (_likeArr.count > 0) {
        _likeLable.hidden = NO;
        _likeLable.top = 10.f;
        _likeLable.left = kTimeLineNameDetailPadding;
        _likeLable.width = self.width - kTimeLineNameDetailPadding*2;
        _likeLable.height = _layout.likeLayout.textBoundingSize.height;
        _likeLable.textLayout = _layout.likeLayout;
    }else{
         _likeLable.hidden = YES;
    }
    
    if (_likeArr.count > 0 && _commentLayoutArr.count > 0) {
        _dividerLine.hidden = NO;
        _dividerLine.top = _likeLable.bottom;
        _dividerLine.left = 0;
        _dividerLine.height = .5f;
        _dividerLine.width = self.width;
        lastView = _dividerLine;
    }else{
        _dividerLine.hidden = YES;
    }
    
    if (_commentLayoutArr.count > 0) {
        _commentTableView.hidden = NO;
        _commentTableView.top = lastView == _dividerLine? lastView.bottom + 5: lastView.top +10;
        _commentTableView.left = _bgImgView.left;
        _commentTableView.width = self.width;
        _commentTableView.height = _layout.commentHeight;
        [_commentTableView reloadData];
    }else{
        _commentTableView.hidden = YES;
    }
}

#pragma -mark getter

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]init];
        UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _bgImgView.image = bgImage;
        _bgImgView.backgroundColor = [UIColor clearColor];
    }
    return _bgImgView;
}

- (YYLabel *)likeLable{
    if (!_likeLable) {
        _likeLable = [YYLabel new];
        _likeLable.displaysAsynchronously = kDisplaysAsynchronously;
    }
    return _likeLable;
}

- (UIView *)dividerLine{
    if (!_dividerLine) {
        _dividerLine = [UIView new];
        _dividerLine.backgroundColor = kTimeLineDividerLineColor;
    }
    return _dividerLine;
}

- (UITableView *)commentTableView{
    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc]init];
        _commentTableView.delegate =self;
        _commentTableView.dataSource = self;
        _commentTableView.scrollEnabled = NO;
        _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentTableView.backgroundColor = [UIColor clearColor];
    }
    return _commentTableView;
}

@end




