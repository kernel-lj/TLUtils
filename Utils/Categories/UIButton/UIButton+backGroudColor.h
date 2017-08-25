//
//  UIButton+backGroudColor.h
//  ReadyGo
//
//  Created by GCZ on 15/6/12.
//  Copyright (c) 2015年 GCZ. All rights reserved.
//  按钮选中与未选中状态下的背景色

#import <UIKit/UIKit.h>

@interface UIButton (backGroudColor)
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
@end
