//
//  TimeLineCommentView.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/6/7.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "TimeLineCommentView.h"
#import "TimeLineCommonDefine.h"
#import "UIView+Add.h"
#import "UITextView+Placeholder.h"

@interface TimeLineCommentView()<UITextViewDelegate>

@property (nonatomic,assign) CGFloat textViewHeight;
@property (nonatomic,strong) UIButton* emojiButton;

@end

@implementation TimeLineCommentView


- (id)initWithFrame:(CGRect)frame
          sendBlock:(PressSendBlock)sendBlock {
   
    if (self = [super initWithFrame:frame]) {

        self.sendBlock = sendBlock;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.textView];
        [self addSubview:self.emojiButton];
    }
    return self;
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    _textView.placeholder = placeHolder;
}

#pragma mark  - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]){
        if (self.textView.text.length != 0) {
            if (self.sendBlock) {
                NSString* content = [self.textView.text copy];
                self.sendBlock(content);
                self.textView.text = @"";
                [self.textView resignFirstResponder];
            }
        }
        return NO;
    }
    return YES;
}

#pragma -mark getter

- (UITextView *)textView {
    if (_textView) {
        return _textView;
    }
    _textView = [[TimeLineAutoFitSizeTextView alloc] initWithFrame:CGRectMake(10, 8, [UIScreen mainScreen].bounds.size.width -60, 34)];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.maxNumberOfLines = 3;
    _textView.delegate = self;
    __weak __typeof(self)weakSelf = self;
    _textView.textChangedBlock = ^(NSString *text, CGFloat textHeight,CGFloat changeHeight) {
        CGRect frame = weakSelf.textView.frame;
        frame.size.height = textHeight;
        weakSelf.textView.frame = frame;
        weakSelf.top = weakSelf.top - changeHeight;
        weakSelf.height =  weakSelf.height + changeHeight;
    };

    return _textView;
}


- (UIButton *)emojiButton {
    if (_emojiButton) {
        return _emojiButton;
    }
    _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _emojiButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 0, 60, 50);
    [_emojiButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    return _emojiButton;
}

@end



