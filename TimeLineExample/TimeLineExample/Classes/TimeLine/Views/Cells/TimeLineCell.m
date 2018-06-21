//
//  TimeLineCell.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/18.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "TimeLineCell.h"
#import "UIImageView+WebCache.h"
#import "TimeLineGrayLinkView.h"
#import "TimeLinePhotoContainerView.h"
#import "NSDate+TimeLine.h"
#import "TimeLineCommonDefine.h"
#import "TimeLineLikeCommentView.h"
#import "YYLabel.h"
#import "YYText.h"
#import "TimeLineMenuView.h"

@interface TimeLineCell()

@property (nonatomic, strong) UIImageView *portrait;                         //  头像
@property (nonatomic, strong) YYLabel *nameLabel;                            //  昵称
@property (nonatomic, strong) YYLabel *detailLabel;                          //  详情
@property (nonatomic, strong) TimeLineGrayLinkView *grayLinkView;            //  分享视图
@property (nonatomic, strong) UIButton *moreLessButton;                      //  查看全部
@property (nonatomic, strong) TimeLinePhotoContainerView *photoContainer;    //  图片视图
@property (nonatomic, strong) TimeLineMenuView *menuView;                    //  菜单
@property (nonatomic, strong) YYLabel *timeLabel;                            //  日期
@property (nonatomic, strong) UIButton *deleteButton;                        //  删除
@property (nonatomic, strong) UIButton *menuButton;                          //  点赞评论

@end

@implementation TimeLineCell

/** 快速创建cell */
+ (instancetype)cellWithTableView:(UITableView *) tableView{
    
    static NSString *identifier = @"TimeLineCell_Identifier";
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TimeLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

/** 初始化 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self p_setup];
    }
    return self;
}

/** set方法 */
- (void)setLayout:(TimeLineLayout *)layout{
    _layout = layout;
    
    UIView * lastView;
    TimeLineData * model = layout.model;
    
    //  头像
    _portrait.left = kTimeLineNormalPadding;
    _portrait.top = kTimeLineNormalPadding;
    _portrait.size = CGSizeMake(kTimeLinePortraitWidthAndHeight, kTimeLinePortraitWidthAndHeight);
    [_portrait sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImgHeader,model.portrait]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    //  昵称
    _nameLabel.text = model.nick;
    _nameLabel.top = kTimeLineNormalPadding;
    _nameLabel.userInteractionEnabled = YES;
    _nameLabel.left = _portrait.right + kTimeLinePortraitNamePadding;
    _nameLabel.width = [_nameLabel sizeThatFits:CGSizeZero].width;
    _nameLabel.height = kTimeLineNameHeight;
    _nameLabel.fadeOnHighlight = YES;
    
    // 详情
    _detailLabel.left = _nameLabel.left;
    _detailLabel.top = _nameLabel.bottom + kTimeLineNameDetailPadding;
    _detailLabel.width = kSCREENWIDTH - kTimeLineNormalPadding * 2 - kTimeLinePortraitWidthAndHeight - kTimeLinePortraitNamePadding;
    _detailLabel.height = layout.detailLayout.textBoundingSize.height;
    _detailLabel.textLayout = layout.detailLayout;
    lastView = _detailLabel;
    __weak __typeof(self)weakSelf = self;
    layout.clickPhoneOrUrlBlock = ^(NSString *phone, NSString *url) {
        if ([weakSelf.delegate respondsToSelector:@selector(timelineCell:didClickUrl:phone:)]) {
            [weakSelf.delegate timelineCell:weakSelf didClickUrl:url phone:phone];
        }
    };

    //  阅读全文
    _moreLessButton.left = _nameLabel.left;
    _moreLessButton.top = _detailLabel.bottom + kTimeLineLineSpacing;
    _moreLessButton.height = kTimeLineMoreLessButtonHeight;
    [_moreLessButton sizeToFit];
    if (model.shouldShowMoreButton) {
        _moreLessButton.hidden = NO;
        if (model.isOpening) {
            [_moreLessButton setTitle:@"收起" forState:UIControlStateNormal];
        }else{
            [_moreLessButton setTitle:@"全文" forState:UIControlStateNormal];
        }
        lastView = _moreLessButton;
    }else{
        _moreLessButton.hidden = YES;
    }
    
    //  图片视图
    if (model.photocollections.count != 0) {
        _photoContainer.hidden = NO;
        _photoContainer.left = _nameLabel.left;
        _photoContainer.top = lastView.bottom + kTimeLineNameDetailPadding;
        _photoContainer.size = layout.photoContainerSize;
        _photoContainer.photoUrls = model.photocollections;
        lastView = _photoContainer;
    }else{
        _photoContainer.hidden = YES;
    }
    
    //  分享
    if (model.pagetype == 1) {
        _grayLinkView.hidden = NO;
        _grayLinkView.top = lastView.bottom + kTimeLinePortraitNamePadding;
        _grayLinkView.left = _nameLabel.left;
        _grayLinkView.width = _detailLabel.right - _grayLinkView.left;
        _grayLinkView.height = kTimeLineGrayBgHeight;
        
        [_grayLinkView.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImgHeader,model.thumb]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        _grayLinkView.titleLabel.text = model.title;
        _grayLinkView.titleLabel.centerY = _grayLinkView.imgView.centerY;
        _grayLinkView.titleLabel.textLayout = layout.shareLayout;
        _grayLinkView.titleLabel.numberOfLines = 2;
        lastView = _grayLinkView;

    }else{
        _grayLinkView.hidden = YES;
    }
    
    //  时间
    _timeLabel.text = [NSDate formateDate:model.exttime withFormate:@"yyyyMMddHHmmss"];
    _timeLabel.top = lastView.bottom + kTimeLinePortraitNamePadding;
    _timeLabel.left = _nameLabel.left;
    CGSize dateSize = [_timeLabel sizeThatFits:CGSizeMake(100, kTimeLineNameHeight)];
    _timeLabel.width = dateSize.width;
    _timeLabel.height = kTimeLineNameHeight;
    
    //  删除按钮
    _deleteButton.left = _timeLabel.right + kTimeLinePortraitNamePadding;
    _deleteButton.top = _timeLabel.top;
    CGSize deleteSize = [_deleteButton sizeThatFits:CGSizeMake(100, kTimeLineNameHeight)];
    _deleteButton.width = deleteSize.width;
    _deleteButton.height = kTimeLineNameHeight;
    
    //  点赞评论按钮
    _menuButton.left = _detailLabel.right - 25;
    _menuButton.top = _timeLabel.top - 4;
    _menuButton.size = CGSizeMake(25, 25);
    
    //  评论点赞视图
    if (model.likeArr.count != 0 || model.commentArr.count != 0) {
        _likeCommentView.hidden = NO;
        _likeCommentView.left = _nameLabel.left;
        _likeCommentView.top = _timeLabel.bottom + kTimeLinePortraitNamePadding;
        _likeCommentView.width = kSCREENWIDTH - kTimeLineNormalPadding * 2 - kTimeLinePortraitWidthAndHeight - kTimeLinePortraitNamePadding;
        _likeCommentView.height = _layout.liekCommentHeight;
    }else{
        _likeCommentView.hidden = YES;
    }
    //  给点赞和评论视图赋值
    [_likeCommentView setLikeArr:model.likeArr commentArr:model.commentArr layout:_layout];
    
    _layout.clickUserBlock = ^(NSString *userId, NSString *nick) {
        if ([weakSelf.delegate respondsToSelector:@selector(timelineCell:didClickUserId:userNick:)]) {
            [weakSelf.delegate timelineCell:weakSelf didClickUserId:userId userNick:nick];
        }
    };
}

#pragma -mark 私有方法

- (void)p_setup{
    
    [self.contentView addSubview:self.portrait];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.grayLinkView];
    [self.contentView addSubview:self.moreLessButton];
    [self.contentView addSubview:self.photoContainer];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.deleteButton];
    [self.contentView addSubview:self.menuButton];
    [self.contentView addSubview:self.likeCommentView];
}

- (void)p_tapTimeLinePortrait{
    if ([self.delegate respondsToSelector:@selector(timelineCell_DidClickNineOrPortraitWithCell:)]) {
        [self.delegate timelineCell_DidClickNineOrPortraitWithCell:self];
    }
}

- (void)p_moreLessButtonDidClick{
    if ([self.delegate respondsToSelector:@selector(timelineCell_DidClickMoreLessWithCell:)]) {
        [self.delegate timelineCell_DidClickMoreLessWithCell:self];
    }
}

- (void)p_tapGrayLinkView{
    if ([self.delegate respondsToSelector:@selector(timelineCell_DidClickGrayLinkViewWithCell:)]) {
        [self.delegate timelineCell_DidClickGrayLinkViewWithCell:self];
    }
}

- (void)p_menuButtonDidClick{
    
    if (!self.menuView) {
        self.menuView = [TimeLineMenuView createTimeLineMenuViewWithMenuBtn:self.menuButton];
    }
    self.menuView.isLike = self.layout.model.isLike;
    [self.contentView addSubview:self.menuView];
    [self.menuView show];
    
    __weak __typeof(self)weakSelf = self;
    _menuView.clickMenuBtn = ^(NSInteger index) {
        if (index == 0) {// 点赞
            weakSelf.layout.model.isLike =  !weakSelf.layout.model.isLike;
            if ([weakSelf.delegate respondsToSelector:@selector(timelineCell_DidClickLikeWithCell:)]) {
                [weakSelf.delegate timelineCell_DidClickLikeWithCell:weakSelf];
            }
        }else{  // 评论
            if ([weakSelf.delegate respondsToSelector:@selector(timelineCell_DidClickCommentWithCell:)]) {
                [weakSelf.delegate timelineCell_DidClickCommentWithCell:weakSelf];
            }
        }
    };
}

- (void)p_deleteButtonDidClick{
    if ([self.delegate respondsToSelector:@selector(timelineCell_DidClickDeleteWithCell:)]) {
        [self.delegate timelineCell_DidClickDeleteWithCell:self];
    }
}

#pragma -mark getter

- (UIImageView *)portrait{
    if(!_portrait){
        _portrait = [UIImageView new];
        _portrait.contentMode = UIViewContentModeScaleAspectFill;
        _portrait.clipsToBounds = YES;
        _portrait.userInteractionEnabled = YES;
        _portrait.backgroundColor = [UIColor grayColor];
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(p_tapTimeLinePortrait)];
        [_portrait addGestureRecognizer:tapGR];
    }
    return _portrait;
}

- (YYLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [YYLabel new];
        _nameLabel.displaysAsynchronously = kDisplaysAsynchronously;
        _nameLabel.font = KTimeLineNameFont;
        _nameLabel.textColor = kTimeLineNameColor;
        _nameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(p_tapTimeLinePortrait)];
        [_nameLabel addGestureRecognizer:tapGR];
    }
    return _nameLabel;
}

- (YYLabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [YYLabel new];
        _detailLabel.displaysAsynchronously = kDisplaysAsynchronously;
    }
    return _detailLabel;
}

- (TimeLineGrayLinkView *)grayLinkView{
    if (!_grayLinkView) {
        _grayLinkView = [[TimeLineGrayLinkView alloc]init];
        _grayLinkView.titleLabel.displaysAsynchronously = kDisplaysAsynchronously;
        _grayLinkView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(p_tapGrayLinkView)];
        [_grayLinkView addGestureRecognizer:tapGR];
    }
    return _grayLinkView;
}

- (UIButton *)moreLessButton{
    if (!_moreLessButton) {
        _moreLessButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreLessButton.titleLabel.font = KTimeLineDetailFont;
        [_moreLessButton setTitleColor:kTimeLineNameColor forState:UIControlStateNormal];
        _moreLessButton.hidden = YES;
        [_moreLessButton addTarget:self action:@selector(p_moreLessButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreLessButton;
}

- (TimeLinePhotoContainerView *)photoContainer{
    if (!_photoContainer) {
        _photoContainer = [[TimeLinePhotoContainerView alloc]init];
    }
    return _photoContainer;
}

- (YYLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [YYLabel new];
        _timeLabel.displaysAsynchronously = kDisplaysAsynchronously;
        _timeLabel.font = KTimeLineShareFont;
        _timeLabel.textColor = kTimeLineTimeColor;
    }
    return _timeLabel;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _deleteButton.titleLabel.font = KTimeLineShareFont;
        [_deleteButton setTitleColor:kTimeLineNameColor forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(p_deleteButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIButton *)menuButton{
    if (!_menuButton) {
         _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.contentMode = UIViewContentModeScaleAspectFit;
        [_menuButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        [_menuButton addTarget:self action:@selector(p_menuButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuButton;
}

- (TimeLineLikeCommentView *)likeCommentView{
    if (!_likeCommentView) {
        _likeCommentView = [[TimeLineLikeCommentView alloc]init];
        __weak __typeof(self)weakSelf = self;
        _likeCommentView.timelineCommentViewdidClick = ^(TimeLineCommentData * model, UITableViewCell *cell) {
            if ([weakSelf.delegate respondsToSelector:@selector(timelineCell_DidClickReplyCommentWithCell: CommentViewCell: TimeLineCommentData:)]) {
                [weakSelf.delegate timelineCell_DidClickReplyCommentWithCell:weakSelf CommentViewCell:cell TimeLineCommentData:model];
            }
        };
    }
    return _likeCommentView;
}

@end





















