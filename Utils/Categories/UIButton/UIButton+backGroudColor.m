//
//  UIButton+backGroudColor.m
//  ReadyGo
//
//  Created by GCZ on 15/6/12.
//  Copyright (c) 2015年 GCZ. All rights reserved.
//  按钮选中与未选中状态下的背景色 (有点问题，抽空调试下)

#import "UIButton+backGroudColor.h"

@implementation UIButton (backGroudColor)
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
    
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
