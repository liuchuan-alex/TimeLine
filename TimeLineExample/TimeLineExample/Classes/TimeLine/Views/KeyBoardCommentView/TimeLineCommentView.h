//
//  TimeLineCommentView.h
//  TimeLineExample
//
//  Created by 刘川 on 2018/6/7.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineAutoFitSizeTextView.h"

typedef void(^PressSendBlock)(NSString * content);

/** 用于在控制器底部的评论文本框 */
@interface TimeLineCommentView : UIView

@property (nonatomic, strong) TimeLineAutoFitSizeTextView* textView;
@property (nonatomic, copy) NSString* placeHolder;
@property (nonatomic, copy) PressSendBlock sendBlock;

- (instancetype)initWithFrame:(CGRect)frame
                    sendBlock:(PressSendBlock)sendBlock;

@end
