//
//  NSDate+TimeLine.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/22.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "NSDate+TimeLine.h"

@implementation NSDate (TimeLine)

+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    
    NSDate * nowDate = [NSDate date];
    
    /////  将需要转换的时间转换成 NSDate 对象
    NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
    /////  取当前时间和转换时间两个日期对象的时间间隔
    /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
    NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
    
    //// 再然后，把间隔的秒数折算成天数和小时数：
    
    NSString * dateStr = @"";
    
    if (time<=60)  {  //// 1分钟以内的
        dateStr =  @"刚刚";
    }else if(time<=60*60){  ////  一个小时以内的
        
        int mins = time/60;
        dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
        
    }else if(time<=60*60*24){   //// 在两天内的
        
        [dateFormatter setDateFormat:@"YYYY/MM/dd"];
        NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
        NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
        
        [dateFormatter setDateFormat:@"HH:mm"];
        if ([need_yMd isEqualToString:now_yMd]) {
            //// 在同一天
            dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
        }else{
            ////  昨天
            dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
        }
    }else {
        
        [dateFormatter setDateFormat:@"yyyy"];
        NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
        NSString *nowYear = [dateFormatter stringFromDate:nowDate];
        
        if ([yearStr isEqualToString:nowYear]) {
            ////  在同一年
            [dateFormatter setDateFormat:@"MM月dd日"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }else{
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }
    }

    return dateStr;
}

@end
