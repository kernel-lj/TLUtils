//
//  TLDownImageViewUtil.h
//  TLUtils
//
//  Created by ltl on 2017/8/24.
//  Copyright © 2017年 dm. All rights reserved.
//  图片下载

#import <Foundation/Foundation.h>
#import "TLDownImageView.h"

@interface TLDownImageViewUtil : NSObject
/**
 *  下载网络图片，并且下载完成后有个动画效果，如果有缓存则从缓存读取 需跟SDWebImage配合使用
 *
 *  @param imgURL    图片的网络地址
 *  @param imageView 下载完成后在imageView显示
 *  @param placeHolder 占位图
 */

+ (void)downImageWithURL:(NSURL *)imgURL imageView:(TLDownImageView *)imageView placeHolder:(UIImage *)placeHolder;

// 下载不断变化的图片
+ (void)downDynamicImageWithURL:(NSURL *)imgURL imageView:(TLDownImageView *)imageView placeHolder:(UIImage *)placeHolder;

// 按钮
+ (void)downImageWithURL:(NSURL *)imgURL button:(UIButton *)imageView placeHolder:(UIImage *)placeHolder;

+ (void)removeImageCacheWithUrl:(NSString *)url;

@end
