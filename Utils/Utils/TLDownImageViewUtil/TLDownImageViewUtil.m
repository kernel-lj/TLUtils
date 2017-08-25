//
//  TLDownImageViewUtil.m
//  TLUtils
//
//  Created by ltl on 2017/8/24.
//  Copyright © 2017年 dm. All rights reserved.
//  图片下载

#import "TLDownImageViewUtil.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"


#define SDManager      [SDWebImageManager sharedManager]

@implementation TLDownImageViewUtil
+ (void)downImageWithURL:(NSURL *)imgURL imageView:(TLDownImageView *)imageView placeHolder:(UIImage *)placeHolder
{
    UIImage *cachedImage = [[SDManager imageCache] imageFromDiskCacheForKey:[imgURL absoluteString]]; // 将需要缓存的图片加载进来
    
    imageView.imgURL = imgURL;
    if (cachedImage) {
        imageView.image = cachedImage;
    } else {
        // 如果Cache没有命中，则去下载指定网络位置的图片
        // Start an async download
        
        __weak TLDownImageView *weakImageView = imageView;
        
        [SDManager downloadImageWithURL:imgURL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            // do something with image
            if ([weakImageView.imgURL isEqual:imgURL]) {
                if (image) {
                    weakImageView.alpha = 0;
                    
                    [[SDImageCache sharedImageCache] storeImage:image
                     
                                                         forKey:[imgURL absoluteString]
                     
                                                         toDisk:YES];
                    weakImageView.image = image;
                    //NSLog(@"第%ld下载完成!",indexPath.row+1);
                    
                    [UIView animateWithDuration:1.0 animations:^{
                        weakImageView.alpha = 1.0;
                    }];
                }else{
                    weakImageView.image = placeHolder;
                }
            }
        }];
    }
}

// 下载变化图片
+ (void)downDynamicImageWithURL:(NSURL *)imgURL imageView:(TLDownImageView *)imageView placeHolder:(UIImage *)placeHolder
{
    imageView.imgURL = imgURL;
    
    // Start an async download
    __weak TLDownImageView *weakImageView = imageView;
    
    [imageView sd_setImageWithURL:imgURL placeholderImage:placeHolder options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // do something with image
        if ([weakImageView.imgURL isEqual:imgURL]) {
            if (image) {
                weakImageView.alpha = 0;
                weakImageView.image = image;
                [UIView animateWithDuration:1.0 animations:^{
                    weakImageView.alpha = 1.0;
                }];
                
            }else{
                // 显示错误图片
                weakImageView.image = placeHolder;
            }
        }
    }];
    
}

+ (void)downImageWithURL:(NSURL *)imgURL button:(UIButton *)imageView placeHolder:(UIImage *)placeHolder
{
    UIImage *cachedImage = [[SDManager imageCache] imageFromDiskCacheForKey:[imgURL absoluteString]]; // 将需要缓存的图片加载进来
    if (cachedImage) {
        // 如果Cache命中，则直接利用缓存的图片进行有关操作
        [imageView setImage:cachedImage forState:UIControlStateNormal];
    } else {
        
        // 如果Cache没有命中，则去下载指定网络位置的图片
        // Start an async download
        
        __weak UIButton *weakImageView = imageView;
        [SDManager downloadImageWithURL:imgURL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            // do something with image
            if (image) {
                
                weakImageView.alpha = 0;
                [[SDImageCache sharedImageCache] storeImage:image
                 
                                                     forKey:[imgURL absoluteString]
                 
                                                     toDisk:YES];
                [weakImageView setImage:image forState:UIControlStateNormal];
                //NSLog(@"第%ld下载完成!",indexPath.row+1);
                
                [UIView animateWithDuration:1.0 animations:^{
                    weakImageView.alpha = 1.0;
                }];
                
            }else{
                [weakImageView setImage:placeHolder forState:UIControlStateNormal];
            }
        }];
        
    }
    
}

+ (void)removeImageCacheWithUrl:(NSString *)url
{
    [[SDManager imageCache] removeImageForKey:url withCompletion:^{
    }];
    
}

@end
