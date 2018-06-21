//
//  TimeLinePhotoContainerView.h
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/21.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLinePhotoContainerView : UIView

@property (nonatomic, strong) NSArray *photoUrls;        //  照片数据
@property (nonatomic, assign) CGFloat customImgWidth;    //  当前图片宽度

/** 根据图片个数获取图片容器尺寸 */
+ (CGSize)getContainerSizeWithPicCount:(NSInteger) picCount;



@end
