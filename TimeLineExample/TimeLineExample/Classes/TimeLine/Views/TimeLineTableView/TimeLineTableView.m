//
//  TimeLineTableView.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/18.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "TimeLineTableView.h"

@implementation TimeLineTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor darkGrayColor];
        [self setLayoutMargins:UIEdgeInsetsZero];
        [self setSeparatorInset:UIEdgeInsetsZero];
        self.tableFooterView = [[UIView alloc]init];
    }
    return self;
}

@end
