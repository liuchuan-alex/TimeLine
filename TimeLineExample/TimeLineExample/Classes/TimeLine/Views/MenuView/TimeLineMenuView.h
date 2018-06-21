//
//  TimeLineMenuView.h
//  TimeLineExample
//
//  Created by 刘川 on 2018/6/4.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineMenuView : UIView

@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, copy) void (^clickMenuBtn)(NSInteger index);

+ (instancetype)createTimeLineMenuViewWithMenuBtn:(UIButton *) menuBtn;
- (void)show;
- (void)dismiss;
+ (void)dismissAllMenu;

@end
