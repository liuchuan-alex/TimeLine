//
//  TimeLineGrayLinkView.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/22.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "TimeLineGrayLinkView.h"
#import "TimeLineCommonDefine.h"
#import "YYText.h"


@interface TimeLineGrayLinkView()

@end

@implementation TimeLineGrayLinkView

- (instancetype)initWithFrame:(CGRect)frame{

    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kSCREENWIDTH - kTimeLineNormalPadding * 2 - kTimeLinePortraitNamePadding - kTimeLinePortraitWidthAndHeight;;
        frame.size.height = kTimeLineGrayBgHeight;
    }

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kTimeLineGrayBgColor;
        [self p_setup];
    }
    return self;
}

- (void)p_setup{
    [self addSubview:self.imgView];
    [self addSubview:self.titleLabel];
    [self p_layout];
}

- (void)p_layout{

    _imgView.left = kTimeLineGrayPicPadding;
    _imgView.top = kTimeLineGrayPicPadding;
    _imgView.width = kTimeLineGrayPicHeight;
    _imgView.height = kTimeLineGrayPicHeight;

    _titleLabel.left = _imgView.right + kTimeLineNameDetailPadding;
    _titleLabel.width = self.right - kTimeLineNameDetailPadding - _titleLabel.left;
    _titleLabel.height = self.height - kTimeLineGrayPicPadding*2;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.userInteractionEnabled = NO;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

- (YYLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [YYLabel new];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}
@end
