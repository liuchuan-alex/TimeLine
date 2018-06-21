//
//  TimeLineAutoFitSizeTextView.h
//  TimeLineExample
//
//  Created by 刘川 on 2018/6/7.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^textHeightChangedBlock)(NSString *text,CGFloat textHeight, CGFloat changeHeight);

@interface TimeLineAutoFitSizeTextView : UITextView

@property (nonatomic, assign) NSUInteger maxNumberOfLines;

@property (nonatomic, copy) textHeightChangedBlock textChangedBlock;

@end
