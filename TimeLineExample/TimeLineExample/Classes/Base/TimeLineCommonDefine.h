//
//  TimeLineCommonDefine.h
//  TimeLineExample
//
//  Created by 刘川 on 2018/5/22.
//  Copyright © 2018年 Alex. All rights reserved.
//

#ifndef TimeLineCommonDefine_h
#define TimeLineCommonDefine_h

/** 常量定义 */
static const CGFloat kTimeLineNormalPadding = 15.f;                         //  填空间距
static const CGFloat kTimeLinePortraitWidthAndHeight = 45.f;                //  头像宽高
static const CGFloat kTimeLinePortraitNamePadding = 10.f;                   //  头像昵称间距
static const CGFloat kTimeLineNameDetailPadding = 8.f;                      //  昵称和详情间距
static const CGFloat kTimeLineNameHeight = 17.f;                            //  昵称高度
static const CGFloat kTimeLineMoreLessButtonHeight = 25.f;                  //  全文按钮高度
static const CGFloat kTimeLineSpreadButtonHeight = 20.f;                    //  推广按钮高度
static const CGFloat kTimeLineGrayBgHeight = 51.f;                          //  灰色背景高度
static const CGFloat kTimeLineGrayPicHeight = 41.f;                         //  灰色视图图片高度
static const CGFloat kTimeLineGrayPicPadding = 5.f;                         //  灰色视图图片间距
static const CGFloat kTimeLineLikeTopPadding = 10.f;                        //  点赞上间距
static const CGFloat kTimeLineLineSpacing = 5.f;                            //  详情行间距
static const CGFloat kTimeLineShareLineSpacing = 3.f;                       //  分享文字行间距
static const NSInteger kTimeLineMaxLine = 6;                                //  折叠行数


static const NSString * kImgHeader = @"http://static.soperson.com";         //  图片地址前缀
static const BOOL kDisplaysAsynchronously = YES;                            //  YYLable异步渲染

/** 宏定义 */

#define kSCREENWIDTH  ([[UIScreen mainScreen]bounds].size.width)
#define kSCREENHEIGHT  ([[UIScreen mainScreen]bounds].size.height)
#define kRGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

#define kTimeLineNameColor  kRGBA_COLOR(74, 90, 133, 1)                     //  昵称颜色
#define kTimeLineTimeColor  [UIColor lightGrayColor]                        //  时间颜色
#define kTimeLineUrlColor   kRGBA_COLOR(69, 88, 133, 1)                     //  网址颜色
#define kTimeLinePhoneNumColor   kRGBA_COLOR(69, 88, 133, 1)                //  电话号码颜色
#define kTimeLineGrayBgColor    kRGBA_COLOR(240, 240, 242, 1)               //  灰色背景
#define kTimeLineDividerLineColor  kRGBA_COLOR(210, 210, 210, 1);            //  点赞评论分割线颜色

#define KTimeLineNameFont  [UIFont systemFontOfSize:15.f]                   //  昵称大小
#define KTimeLineDetailFont  [UIFont systemFontOfSize:14.f]                 //  详情大小
#define KTimeLineShareFont  [UIFont systemFontOfSize:13.f]                  //  分享文字大小(删除,时间)

#endif /* TimeLineCommonDefine_h */




