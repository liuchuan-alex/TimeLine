//
//  TimeLineHaderView.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/30.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "TimeLineHaderView.h"
#import "TimeLineCommonDefine.h"
#import "UIImageView+WebCache.h"
#import "UIView+Add.h"

@interface TimeLineHaderView ()

@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UIImageView *backGroundView;

@end

@implementation TimeLineHaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.height == 0) {
        frame = CGRectMake(0, 0, kSCREENWIDTH, kSCREENWIDTH*2/3);
    }
    if (self = [super initWithFrame:frame]) {
        [self p_setup];
    }
    return self;
}

- (void)setnick:(NSString *)nick{
    _nick = nick;
    _nickLabel.text = nick;
}

- (void)setPortraitUrl:(NSString *)portraitUrl{
    _portraitUrl = portraitUrl;
    [_portraitView sd_setImageWithURL:[NSURL URLWithString:portraitUrl]];
}

- (void)setBackgroundUrl:(NSString *)backgroundUrl{
    _backgroundUrl = backgroundUrl;
    [_backGroundView sd_setImageWithURL:[NSURL URLWithString:backgroundUrl]];
}


#pragma -mark private actions
- (void)p_setup{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backGroundView];
    [self addSubview:self.portraitView];
    [self addSubview:self.nickLabel];
}


#pragma -mark getter

- (UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]init];
        _nickLabel.text = @"十年";
        _nickLabel.textColor = [UIColor whiteColor];
        _nickLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _nickLabel.textAlignment = NSTextAlignmentRight;
        _nickLabel.frame = CGRectMake(20, self.backGroundView.bottom - 30.f, kSCREENWIDTH - 120, 20);
    }
    return _nickLabel;
}

- (UIImageView *)portraitView{
    if (!_portraitView) {
        _portraitView = [[UIImageView alloc]init];
        _portraitView.image = [UIImage imageNamed:@"test"];
        _portraitView.backgroundColor = [UIColor lightGrayColor];
        _portraitView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _portraitView.layer.borderWidth = 2.f;
        _portraitView.frame = CGRectMake(kSCREENWIDTH - 80, self.backGroundView.bottom - 50.f, 70, 70);
    }
    return _portraitView;
}

- (UIImageView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIImageView alloc]init];
        _backGroundView.image = [UIImage imageNamed:@"backgroundImage"];
        _backGroundView.backgroundColor = [UIColor lightGrayColor];
        _backGroundView.frame = CGRectMake(0, -kSCREENWIDTH/3.f - 35, kSCREENWIDTH, kSCREENWIDTH);
    }
    return _backGroundView;
}


@end
