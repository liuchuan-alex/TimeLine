//
//  TimeLineLayout.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/18.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "TimeLineLayout.h"
#import "TimeLinePhotoContainerView.h"

@implementation TimeLineLayout


- (instancetype)initWithModel:(TimeLineData *) model{
    if (self = [super init]) {
        _model = model;
        [self resetLayout];
    }
    return self;
}

- (void)resetLayout{
    
    [self.commentLayoutArr removeAllObjects];
    
    //  计算高度
    _height = 0;
    _liekCommentHeight = 0;
    _height += kTimeLineNormalPadding;
    
    _height += kTimeLineNameHeight;
    _height += kTimeLineNameDetailPadding;
    [self p_layoutDetail];
    _height +=  _detailLayout.textBoundingSize.height;
    
    if (_model.shouldShowMoreButton) {
        _height += kTimeLineLineSpacing;
        _height += kTimeLineMoreLessButtonHeight;
    }
    
    if (_model.photocollections.count != 0) {
        [self p_layoutPicture];
        _height += kTimeLineNameDetailPadding;
        _height += _photoContainerSize.height;
    }
    
    if (_model.pagetype == 1) { //1为分享链接  0表示普通
        [self p_layoutGrayLinkText];
        _height += kTimeLinePortraitNamePadding;
        _height += kTimeLineGrayBgHeight;
    }
    
    _height += (kTimeLineNameHeight + kTimeLineNameDetailPadding);
    
    if (_model.likeArr.count!= 0) {
        [self p_layoutLike];
    }
    
    if (_model.commentArr.count!=0) {
        [self p_layoutcomment];
    }
    
    if (_model.likeArr.count!= 0 || _model.commentArr.count!=0) {
        _height += kTimeLineNameDetailPadding;
    }
    _height += _liekCommentHeight;
    
    _height += kTimeLineNormalPadding;
}

#pragma -mark private actions
/** 详情布局 */
- (void)p_layoutDetail{
    
    _detailLayout = nil;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:_model.detail];
    text.yy_font = KTimeLineDetailFont;
    text.yy_lineSpacing = kTimeLineLineSpacing;
    
    //  检索电话以及网址,以及添加点击事件
    NSDataDetector *detector = [[NSDataDetector alloc]initWithTypes:NSTextCheckingTypePhoneNumber| NSTextCheckingTypeLink error:nil];
    [detector enumerateMatchesInString:_model.detail
                               options:kNilOptions
                                 range:text.yy_rangeOfAll
                            usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                                
                                if (result.URL) {
                                    
                                    [text yy_setColor:kTimeLinePhoneNumColor range:result.range];
                                    YYTextHighlight * highLight = [YYTextHighlight new];
                                    YYTextBorder *border = [YYTextBorder new];
                                    border.fillColor = [UIColor colorWithWhite:0.90 alpha:1];
                                    border.cornerRadius = 0;
                                    [highLight setBackgroundBorder:border];
                                    [text yy_setTextHighlight:highLight range:result.range];
                                    highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                        if (self.clickPhoneOrUrlBlock) {
                                            self.clickPhoneOrUrlBlock(nil,[text.string substringWithRange:range]);
                                        }
                                    };
                                }
                    
                                if (result.phoneNumber) {
                                
                                    [text yy_setColor:kTimeLinePhoneNumColor range:result.range];
                                    YYTextHighlight * highLight = [YYTextHighlight new];
                                    YYTextBorder *border = [YYTextBorder new];
                                    border.fillColor = [UIColor colorWithWhite:0.90 alpha:1];
                                    border.cornerRadius = 0;
                                    [highLight setBackgroundBorder:border];
                                    [text yy_setTextHighlight:highLight range:result.range];
                                    highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                        if (self.clickPhoneOrUrlBlock) {
                                            self.clickPhoneOrUrlBlock([text.string substringWithRange:range],nil);
                                        }
                                    };
                                }
                            }];
    
    CGFloat width = kSCREENWIDTH - kTimeLineNormalPadding*2 - kTimeLinePortraitWidthAndHeight - kTimeLinePortraitNamePadding;
    CGFloat height = _model.isOpening ? CGFLOAT_MAX : (KTimeLineDetailFont.lineHeight * kTimeLineMaxLine + kTimeLineLineSpacing * (kTimeLineMaxLine - 1));

    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(width, height)];
    container.truncationType = YYTextTruncationTypeEnd;
    
    _detailLayout = [YYTextLayout layoutWithContainer:container text:text];
}

/** 分享链接灰色文字布局 */
- (void)p_layoutGrayLinkText{
    
    _shareLayout = nil;
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc]initWithString:_model.title];
    text.yy_font = KTimeLineShareFont;
    text.yy_lineSpacing = kTimeLineShareLineSpacing;
    
    CGFloat width = kSCREENWIDTH - kTimeLineNormalPadding*2 - kTimeLinePortraitWidthAndHeight - kTimeLinePortraitNamePadding - kTimeLineGrayPicHeight - kTimeLinePortraitNamePadding *2;
    CGFloat height = kTimeLineGrayBgHeight;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(width,height)];
    container.truncationType = YYTextTruncationTypeEnd;
    
    _shareLayout = [YYTextLayout layoutWithContainer:container text:text];
}

/** 图片布局 */
- (void)p_layoutPicture{
    
    _photoContainerSize = CGSizeZero;
    _photoContainerSize = [TimeLinePhotoContainerView getContainerSizeWithPicCount:_model.photocollections.count];
}

/** 点赞布局 */
- (void)p_layoutLike{
    
    _likeHeight = 0;
    _liekCommentHeight = 0;
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc]init];
    for(NSInteger i = 0; i< _model.likeArr.count; i++){
        TimeLineLikeData* like = _model.likeArr[i];
        if (i > 0) {
            [text appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@", "]];
        }
        NSMutableAttributedString *nick = [[NSMutableAttributedString alloc]initWithString:like.nick];
        nick.yy_font = KTimeLineShareFont;
        [nick yy_setColor:kTimeLineUrlColor range:nick.yy_rangeOfAll];
        
        YYTextHighlight * highlight = [YYTextHighlight new];
        YYTextBorder *border = [YYTextBorder new];
        border.fillColor = [UIColor colorWithWhite:0.80 alpha:1];
        border.cornerRadius = 0;
        [highlight setBackgroundBorder:border];
        highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (self.clickUserBlock) {
                self.clickUserBlock(self.model.likeArr[i].userid, self.model.likeArr[i].nick);
            }
        };
        [nick yy_setTextHighlight:highlight range:nick.yy_rangeOfAll];
        [text appendAttributedString:nick];
    }
    
    UIImage *iconImage = [UIImage imageNamed:@"Like"];
    NSAttributedString *icon = [NSMutableAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeCenter attachmentSize:iconImage.size alignToFont:[UIFont systemFontOfSize:14]  alignment:YYTextVerticalAlignmentCenter];
    [text yy_insertString:@" " atIndex:0];
    [text insertAttributedString:icon atIndex:0];
    
    CGFloat width = kSCREENWIDTH - kTimeLineNormalPadding*2 - kTimeLinePortraitWidthAndHeight - kTimeLinePortraitNamePadding - kTimeLineNameDetailPadding*2;
    CGFloat height = CGFLOAT_MAX;
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(width, height)];
    
    _likeLayout = [YYTextLayout layoutWithContainer:container text:text];
    
    _likeHeight += _likeLayout.textBoundingSize.height + kTimeLineLikeTopPadding + kTimeLineGrayPicPadding;
    _liekCommentHeight += _likeHeight;
}

/** 评论布局 */
- (void)p_layoutcomment{
    
    _liekCommentHeight = _model.likeArr.count == 0 ?  0 : _liekCommentHeight;
    _commentHeight = _model.likeArr.count == 0 ? 10 : .5;   //是否需要分割线
    
    for (int i = 0; i < _model.commentArr.count; i++) {
        
        TimeLineCommentData * model = _model.commentArr[i];
        
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc] init];
        
        YYTextBorder *border = [YYTextBorder new];
        border.fillColor = [UIColor colorWithWhite:0.80 alpha:1];
        border.cornerRadius = 0;
        
        NSMutableAttributedString * nick = [[NSMutableAttributedString alloc] initWithString:model.nick];
        nick.yy_font = KTimeLineShareFont;
        YYTextHighlight * highLight = [YYTextHighlight new];
        [highLight setBackgroundBorder:border];
        [nick yy_setColor:kTimeLineUrlColor range:nick.yy_rangeOfAll];
        highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (self.clickUserBlock) {
                self.clickUserBlock(self.model.commentArr[i].userid, self.model.commentArr[i].nick);
            }
        };
        [nick yy_setTextHighlight:highLight range:nick.yy_rangeOfAll];
        [text appendAttributedString:nick];
        
        if (model.toNick.length) {
            NSMutableAttributedString * tonick = [[NSMutableAttributedString alloc] initWithString:model.toNick];
            tonick.yy_font = KTimeLineShareFont;
            [tonick yy_setColor:kTimeLineUrlColor range:tonick.yy_rangeOfAll];
            
            YYTextHighlight * tohighLight = [YYTextHighlight new];
            [tohighLight setBackgroundBorder:border];
            tohighLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                if (self.clickUserBlock) {
                    self.clickUserBlock(self.model.commentArr[i].toUserid, self.model.commentArr[i].toNick);
                }
            };
            [tonick yy_setTextHighlight:tohighLight range:tonick.yy_rangeOfAll];
            NSMutableAttributedString * hfText = [[NSMutableAttributedString alloc] initWithString:@" 回复 "];
            hfText.yy_font = [UIFont systemFontOfSize:13];
            [text appendAttributedString:hfText];
            [text appendAttributedString:tonick];
        }
        
        NSMutableAttributedString * fhText = [[NSMutableAttributedString alloc] initWithString:@"："];
        fhText.yy_font = [UIFont systemFontOfSize:13];
        [text appendAttributedString:fhText];
        NSMutableAttributedString * message = [[NSMutableAttributedString alloc] initWithString:model.message];
        message.yy_font = [UIFont systemFontOfSize:13];
        [text appendAttributedString:message];
        
        //添加网址电话识别
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber | NSTextCheckingTypeLink error:nil];
        [detector enumerateMatchesInString:text.string
                                   options:kNilOptions
                                     range:text.yy_rangeOfAll
                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                    
                                    if (result.URL) {
                                        YYTextHighlight * highLight = [YYTextHighlight new];
                                        [text yy_setColor:kTimeLineUrlColor range:result.range];
                                        highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                          
                                        };
                                        [text yy_setTextHighlight:highLight range:result.range];
                                    }
                                    if (result.phoneNumber) {
                                        YYTextHighlight * highLight = [YYTextHighlight new];
                                        [text yy_setColor:kTimeLineUrlColor range:result.range];
                                        highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                           
                                        };
                                        [text yy_setTextHighlight:highLight range:result.range];
                                    }
                                }];
        
        
        CGFloat width = kSCREENWIDTH - kTimeLineNormalPadding*2 - kTimeLinePortraitWidthAndHeight - kTimeLinePortraitNamePadding - kTimeLineNameDetailPadding*2;
        CGFloat height = CGFLOAT_MAX;;
        YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(width,height)];
        
        YYTextLayout * layout = [YYTextLayout layoutWithContainer:container text:text];
        _commentHeight += kTimeLineGrayPicPadding;
        _commentHeight += layout.textBoundingSize.height;
        _commentHeight += kTimeLineGrayPicPadding;
        
        [self.commentLayoutArr addObject:layout];
    }
    
    _liekCommentHeight += _commentHeight;
}

#pragma -mark getter
- (NSMutableArray *)commentLayoutArr{
    if (!_commentLayoutArr) {
        _commentLayoutArr = [NSMutableArray array];
    }
    return _commentLayoutArr;
}

@end



