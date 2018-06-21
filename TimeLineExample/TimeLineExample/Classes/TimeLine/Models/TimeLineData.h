//
//  TimeLineData.h
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/18.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TimeLineLikeData,TimeLineCommentData;


/** 朋友圈数据 */
@interface TimeLineData : NSObject

@property (nonatomic, copy) NSString *pid;                            // 朋友圈ID
@property (nonatomic, copy) NSString *userid;                         // 用户ID
@property (nonatomic, copy) NSString *portrait;                       // 用户头像
@property (nonatomic, copy) NSString *nick;                           // 昵称
@property (nonatomic, copy) NSString *detail;                         // 朋友圈详情

@property (nonatomic, assign) NSInteger pagetype;                     // 动态类型(0:普通类型,1:分享类型)
@property (nonatomic, copy) NSString *title;                          // 分享链接标题
@property (nonatomic, copy) NSString *url;                            // 分享地址链接
@property (nonatomic, copy) NSString *thumb;                          // 分享内容图片

@property (nonatomic, strong) NSArray *photocollections;              // 图片集合
@property (nonatomic, copy) NSString *exttime;                        // 时间
@property (nonatomic, strong) NSMutableArray <TimeLineLikeData *> *likeArr;            // 点赞数据
@property (nonatomic, strong) NSMutableArray <TimeLineCommentData *> *commentArr;      // 评论数据

@property (nonatomic, assign) BOOL isOpening;                         //已展开文字
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;    //是否显示"全文"按钮
@property (nonatomic, assign) BOOL isLike;                             //是否点在

@end


/** 点赞数据 */
@interface TimeLineLikeData : NSObject

@property (nonatomic, copy) NSString *userid;                         // 用户ID
@property (nonatomic, copy) NSString *portrait;                       // 用户头像
@property (nonatomic, copy) NSString *nick;                           // 昵称

@end


/** 评论数据 */
@interface TimeLineCommentData : NSObject

@property (nonatomic, copy) NSString *userid;                         // 用户ID
@property (nonatomic, copy) NSString *portrait;                       // 用户头像
@property (nonatomic, copy) NSString *nick;                           // 昵称
@property (nonatomic, copy) NSString *toUserid;                       // 回复人ID
@property (nonatomic, copy) NSString *toPortrait;                     // 回复人头像
@property (nonatomic, copy) NSString *toNick;                         // 回复人昵称
@property (nonatomic, copy) NSString *message;                        // 评论内容

@end
