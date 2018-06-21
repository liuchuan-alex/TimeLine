//
//  TimeLineLayout.h
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/18.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TimeLineData.h"
#import "TimeLineCommonDefine.h"
#import "YYText.h"

typedef void(^clickPhoneOrUrlBlock)(NSString* phone, NSString* url);
typedef void(^clickUserBlock)(NSString* userId, NSString* userName);

@interface TimeLineLayout : NSObject

@property (nonatomic, strong) TimeLineData *model;                    //  数据模型
@property (nonatomic, strong) YYTextLayout *detailLayout;             //  内容文字布局
@property (nonatomic, strong) YYTextLayout *shareLayout;              //  分享文字布局
@property (nonatomic, assign) CGSize photoContainerSize;              //  图片视图尺寸
@property (nonatomic, assign) CGFloat likeHeight;                     //  点赞文字高度
@property (nonatomic, strong) YYTextLayout *likeLayout;               //  点赞布局
@property (nonatomic, assign) CGFloat commentHeight;                  //  评论高度
@property (nonatomic, strong) NSMutableArray *commentLayoutArr;       //  评论布局
@property (nonatomic, assign) CGFloat liekCommentHeight;              //  点赞评论视图高度
@property (nonatomic, assign) CGFloat height;                         //  cell高度

@property (nonatomic, copy)  clickPhoneOrUrlBlock  clickPhoneOrUrlBlock;    //  点击了电话或者链接
@property (nonatomic, copy)  clickUserBlock  clickUserBlock;                //  点击了用户

/** 根据TimeLineData模型数据初始化 */
- (instancetype)initWithModel:(TimeLineData *) model;

/** 重设layout */
- (void)resetLayout;

@end
