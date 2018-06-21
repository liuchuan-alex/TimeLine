//
//  TimeLineData.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/18.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "TimeLineData.h"
#import "TimeLineLayout.h"
#import "TimeLineCommonDefine.h"
#import "YYModel.h"

@interface TimeLineData()

@property (nonatomic, assign, readwrite) BOOL shouldShowMoreButton;

@end

@implementation TimeLineData

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{
             @"detail":@"dsp",
             @"likeArr":@"optthumb",
             @"commentArr":@"optcomment"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"likeArr" : [TimeLineLikeData class],
             @"commentArr" : [TimeLineCommentData class]
            };
}

- (NSString *)detail{
    
    if (_detail == nil) {
        _detail = @"";
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:_detail];
    text.yy_font = KTimeLineDetailFont;
    
    CGFloat widht = kSCREENWIDTH - kTimeLineNormalPadding*2 - kTimeLinePortraitWidthAndHeight - kTimeLinePortraitNamePadding;
    CGFloat height = CGFLOAT_MAX;
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(widht, height)];
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
    
    if (layout.rowCount <= kTimeLineMaxLine) {
        _shouldShowMoreButton = NO;
    }else{
        _shouldShowMoreButton = YES;
    }
    return _detail;
}

@end


@implementation TimeLineLikeData

@end



@implementation TimeLineCommentData

@end
