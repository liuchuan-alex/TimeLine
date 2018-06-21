//
//  NSDate+TimeLine.h
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/22.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeLine)

/** 格式化日期 */

+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate;

@end
