//
//  TimeLineMenuView.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/6/4.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "TimeLineMenuView.h"

static NSString * TimeLineMenuDismissNotification  = @"TimeLineMenuDismissNotification";

@interface TimeLineMenuView()

@property (nonatomic, assign) BOOL hasShow;
@property (nonatomic, strong) UIButton *menuBtn;
@property (nonatomic, assign) CGFloat menuWidth;

@end

@implementation TimeLineMenuView

+ (instancetype)createTimeLineMenuViewWithMenuBtn:(UIButton *) menuBtn{
    
    TimeLineMenuView *menuView = [[TimeLineMenuView alloc]init];
    menuView.hasShow = NO;
    
    menuView.layer.cornerRadius = 5;
    menuView.layer.masksToBounds = YES;
    menuView.menuBtn = menuBtn;
    [[NSNotificationCenter defaultCenter] addObserver:menuView selector:@selector(dismissOtherMenu) name:TimeLineMenuDismissNotification object:nil];
    return menuView;
}

- (void)setIsLike:(BOOL)isLike{
    
    _isLike = isLike;
    _menuWidth = 0;
    if (self.subviews != nil && self.subviews.count != 0) {
        for (id object in self.subviews) {
            [object removeFromSuperview];
        }
    }
    for (int i = 0; i < 2; i++) {
        
        UIButton * itemBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        itemBtn.tag = 888 + i;
        NSString *title = (i ==0)?(isLike?@"取消":@"点赞"):@"评论";
        UIImage *image = [UIImage imageNamed:(i ==0?@"menu_1":@"menu_2")];
        [itemBtn setImage:image forState:UIControlStateNormal];
        [itemBtn setTitle: title forState:UIControlStateNormal];
        [itemBtn setTintColor:[UIColor whiteColor]];
        itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10.f);
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        itemBtn.frame = CGRectMake(_menuWidth, 0, 80 , 35);
        _menuWidth += 80;
        [itemBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemBtn];
        
        //设置分割线
        if (i < 1) {
            UIView * dividingLine = [[UIView alloc] initWithFrame:CGRectMake(_menuWidth - 1, 7.5, 1, 20)];
            dividingLine.backgroundColor = [UIColor blackColor];
            [self addSubview:dividingLine];
        }
    }
    
    UIView * backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _menuWidth, 35)];
    backGroundView.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
    [self insertSubview:backGroundView atIndex:0];
}



- (void)click:(UIButton *)sender{
    
    if ((sender.tag - 888) == 0) {
        if ([sender.titleLabel.text isEqualToString:@"点赞"]) {
            [sender setTitle: @"取消" forState:UIControlStateNormal];
        }else{
            [sender setTitle: @"点赞" forState:UIControlStateNormal];
        }
    }
    self.hasShow = NO;
    [UIView animateWithDuration:0.25 animations:^{
         [self setFrame:CGRectMake(self.menuBtn.frame.origin.x, self.menuBtn.frame.origin.y-5, 0, 35)];
    } completion:^(BOOL finished) {
        if (self.clickMenuBtn) {
            self.clickMenuBtn(sender.tag - 888);
        }
    }];
}

- (void)show{
    if (!_hasShow) {
        [TimeLineMenuView dismissAllMenu];
        [self.superview bringSubviewToFront:self];
        _hasShow = YES;
        self.frame = CGRectMake(self.menuBtn.frame.origin.x, self.menuBtn.frame.origin.y-5, 0, 35);
        [UIView animateWithDuration:0.25 animations:^{
            [self setFrame:CGRectMake(self.menuBtn.frame.origin.x - self.menuWidth - 3, self.menuBtn.frame.origin.y-5, self.menuWidth, 35)];
        }];
    }else{
        [self dismiss];
    }
}

- (void)dismiss{
    if (_hasShow) {
        _hasShow = NO;
        [UIView animateWithDuration:0.25 animations:^{
            [self setFrame:CGRectMake(self.menuBtn.frame.origin.x, self.menuBtn.frame.origin.y-5, 0, 35)];
        }];
    }
    
}
- (void)dismissOtherMenu{
    if (_hasShow) {
        [self dismiss];
    }
}

+ (void)dismissAllMenu{
    [[NSNotificationCenter defaultCenter] postNotificationName:TimeLineMenuDismissNotification object:nil];
}

@end
