//
//  TimeLineAutoFitSizeTextView.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/6/7.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "TimeLineAutoFitSizeTextView.h"

@interface TimeLineAutoFitSizeTextView ()

/**
 *  文字高度
 */
@property (nonatomic, assign) NSInteger textH;

/**
 *  文字最大高度
 */
@property (nonatomic, assign) NSInteger maxTextH;


@end

@implementation TimeLineAutoFitSizeTextView

- (void)textValueDidChanged:(textHeightChangedBlock)block{
    
    _textChangedBlock = block;
    
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines{
    _maxNumberOfLines = maxNumberOfLines;
    
    /**
     *  根据最大的行数计算textView的最大高度
     *  计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
     */
    _maxTextH = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if ([text isEqualToString:@""]) {
        _textH = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self p_setup];
    }
    return self;
}

- (void)p_setup{
    
    self.textH = self.frame.size.height;
    
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    
    self.layer.cornerRadius = 5.0f;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [[UIColor colorWithWhite:0.85 alpha:1] CGColor];
    self.returnKeyType = UIReturnKeySend;
    self.layoutManager.allowsNonContiguousLayout = NO;
    
    //实时监听textView值得改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)textDidChange
{
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    if (_textH != height) { // 高度不一样，就改变了高度
        CGFloat changeHeight = height - _textH;
        // 当高度大于最大高度时，需要滚动
        self.scrollEnabled = height > _maxTextH && _maxTextH > 0;
        
        _textH = (height > _maxTextH && _maxTextH > 0) ?_maxTextH : height;
        
        //当不可以滚动（即 <= 最大高度）时，传值改变textView高度
        if (_textChangedBlock && self.scrollEnabled == NO) {
            _textChangedBlock(self.text,height,changeHeight);
            [self.superview layoutIfNeeded];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
