//
//  UIImage+Screenshot.m
//  NZAlertView
//
//  Created by Bruno Furtado on 20/12/13.
//  Copyright (c) 2013 No Zebra Network. All rights reserved.
//

#import "UIImage+Screenshot.h"

@implementation UIImage (Screenshot)

+ (UIImage *)screenshot
{
    
    // 官方截图 但只针对UIKit应用 bug 不能截取jpg格式图片
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
 
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.f);
    } else {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            
            //BACK(^{
                CGContextSaveGState(context);
                
                CGContextTranslateCTM(context, [window center].x, [window center].y);
                
                CGContextConcatCTM(context, [window transform]);
                
                CGContextTranslateCTM(context,
                                      -[window bounds].size.width * [[window layer] anchorPoint].x,
                                      -[window bounds].size.height * [[window layer] anchorPoint].y);
                
                [[window layer] renderInContext:context];
                
                CGContextRestoreGState(context);
            //});
            
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
    // 又清楚又快 但是私有api 不能通过审核
//    CGImageRef cgScreen = UIGetScreenImage();
//    if (cgScreen) {
//        UIImage *result = [UIImage imageWithCGImage:cgScreen];
//        CGImageRelease(cgScreen);
//        return result;
//    }
//    return nil;

}

@end