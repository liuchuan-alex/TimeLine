//
//  TimeLineLikeCommentView.h
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/23.
//  Copyright © 2018年 Alex. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TimeLineLayout.h"

@interface TimeLineLikeCommentView : UIView


@property (nonatomic, strong) UITableView *commentTableView;
//  点击评论或者回复回调
@property (nonatomic, copy) void(^timelineCommentViewdidClick)(TimeLineCommentData * model, UITableViewCell *cell);

/**
 设置点赞以及评论和layout动态更新视图(在cell上显示的评论视图)

 @param likeArr  点赞数据
 @param commentArr 评论数据
 @param layout layout
 */
- (void)setLikeArr:(NSMutableArray *) likeArr
        commentArr:(NSMutableArray *) commentArr
            layout:(TimeLineLayout *) layout;


@end
