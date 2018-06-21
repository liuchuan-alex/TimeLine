//
//  TimeLineCell.h
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/18.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineLayout.h"
#import "TimeLineLikeCommentView.h"

@protocol TimeLineCellDelegate;

@interface TimeLineCell : UITableViewCell

//  indexpath
@property (nonatomic, strong) NSIndexPath *indexPath;
//  布局
@property (nonatomic, strong) TimeLineLayout *layout;
//  代理
@property (nonatomic, weak) id<TimeLineCellDelegate> delegate;
//  点赞评论视图
@property (nonatomic, strong) TimeLineLikeCommentView *likeCommentView;

/** 快速创建 */
+ (instancetype)cellWithTableView:(UITableView *) tableView;

@end


@protocol TimeLineCellDelegate <NSObject>


/**
 点击昵称或头像
 */
- (void)timelineCell_DidClickNineOrPortraitWithCell:(TimeLineCell *) cell;


/**
 查看全文
 */
- (void)timelineCell_DidClickMoreLessWithCell:(TimeLineCell *) cell;


/**
 点击了分享内容
 */
- (void)timelineCell_DidClickGrayLinkViewWithCell:(TimeLineCell *) cell;


/**
 点赞
 */
- (void)timelineCell_DidClickLikeWithCell:(TimeLineCell *) cell;


/**
 点击评论
 */
- (void)timelineCell_DidClickCommentWithCell:(TimeLineCell *) cell;


/**
 回复评论
 */
- (void)timelineCell_DidClickReplyCommentWithCell:(TimeLineCell *) cell
                                  CommentViewCell:(UITableViewCell *) commentCell
                              TimeLineCommentData:(TimeLineCommentData *) model;


/**
 删除
 */
- (void)timelineCell_DidClickDeleteWithCell:(TimeLineCell *) cell;


/**
 点击了Url或者电话
 */
- (void)timelineCell:(TimeLineCell *) cell didClickUrl:(NSString *) url phone:(NSString *) phone;

/**
 点击用户
 */
- (void)timelineCell:(TimeLineCell *) cell didClickUserId:(NSString *) userId userNick:(NSString *) nick;

@end
