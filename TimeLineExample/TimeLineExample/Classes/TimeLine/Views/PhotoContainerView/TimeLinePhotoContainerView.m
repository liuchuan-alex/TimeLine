//
//  TimeLinePhotoContainerView.m
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/21.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "TimeLinePhotoContainerView.h"
#import "UIImageView+WebCache.h"
#import "TimeLineCommonDefine.h"
#import "YYPhotoBrowseView.h"

@interface TimeLinePhotoContainerView ()

@property (nonatomic, strong) NSMutableArray *imageViewArr;

@end

@implementation TimeLinePhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self p_setup];
    }
    return self;
}

- (void)setPhotoUrls:(NSArray *)photoUrls{
    
    _photoUrls = photoUrls;
    
    for (long i = photoUrls.count; i < self.imageViewArr.count; i++) {
        UIImageView *imageView = [self.imageViewArr objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (photoUrls.count == 0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
        return;
    }
    
    CGFloat itemW = [self p_itemWidthForPhotoUrls:_photoUrls];
    CGFloat itemH = itemW;

    NSInteger perRowItemCount = [self p_perRowItemCountForPhotoUrls:_photoUrls];
    CGFloat margin = 5;
    
    __weak __typeof(self)weakSelf = self;
    [_photoUrls enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [weakSelf.imageViewArr objectAtIndex:idx];
        imageView.hidden = NO;
        
        NSURL * url = [NSURL URLWithString:weakSelf.photoUrls[idx]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeHolderImg"] options:SDWebImageRetryFailed];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(photoUrls.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h);
}

+ (CGSize)getContainerSizeWithPicCount:(NSInteger) picCount{
    
    CGFloat itemW = picCount == 1 ? 120 : 80;
    CGFloat itemH = 0;
    if (picCount == 1) {
        itemH = itemW;
    } else {
        itemH = itemW;
    }
    long perRowItemCount;
    if (picCount < 4) {
        perRowItemCount = picCount;
    } else if (picCount == 4) {
        perRowItemCount = 2;
    } else {
        perRowItemCount = 3;
    }
    CGFloat margin = 5;
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(picCount * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    
    return CGSizeMake(w, h);
}


#pragma -mark private actions

- (void)p_setup{
    
    for(NSInteger i = 0; i < 9; i++){
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor lightGrayColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [self.imageViewArr addObject:imageView];
    }
}

- (void)p_tapImageView:(UITapGestureRecognizer *) tap{
    
    UIView *fromView = nil;
    NSMutableArray * items = [NSMutableArray array];
    for (int i = 0; i < _photoUrls.count; i++) {
        UIView * imgView = _imageViewArr[i];
        YYPhotoGroupItem * item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = [NSURL URLWithString:_photoUrls[i]];
        [items addObject:item];
        if (i == tap.view.tag) {
            fromView = imgView;
        }
    }
    
    YYPhotoBrowseView *v = [[YYPhotoBrowseView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.window animated:YES completion:nil];
}

- (CGFloat)p_itemWidthForPhotoUrls:(NSArray *) photos{
    
    if (photos.count == 1) {
        return 120;
    } else {
        if (_customImgWidth != 0) {
            return _customImgWidth;
        }else{
            CGFloat w = ([[UIScreen mainScreen]bounds].size.width > 320) ? 80 : 70;
            return w;
        }
    }
}

- (NSInteger)p_perRowItemCountForPhotoUrls:(NSArray *)photos{
    
    if (photos.count < 4) {
        return photos.count;
    } else if (photos.count <= 4) {
        return 2;
    } else {
        return 3;
    }
}


#pragma -mark getter

- (NSMutableArray *)imageViewArr{
    if (!_imageViewArr) {
        _imageViewArr = [NSMutableArray array];
    }
    return _imageViewArr;
}

@end
