//
//  UIView+Add.h
//  YiQiLe_IOS
//
//  Created by 刘川 on 2018/5/23.
//  Copyright © 2018年 YiQiLe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Add)

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.

/** 从Xib加载视图 */
+ (instancetype)loadViewForXib;

/** 获取当前控制器 */
- (UIViewController *)getViewController;

@end


