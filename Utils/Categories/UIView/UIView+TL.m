//
//  UIView+TL.m
//  ReadyGo
//
//  Created by GCZ on 15/6/3.
//  Copyright (c) 2015年 GCZ. All rights reserved.
//

#import "UIView+TL.h"

@implementation UIView (TL)

- (void)setTl_x:(CGFloat)tl_x{
    CGRect frame = self.frame;
    frame.origin.x = tl_x;
    self.frame = frame;
}

- (CGFloat)tl_x
{
    return self.frame.origin.x;
}

- (void)setTl_y:(CGFloat)tl_y
{
    CGRect frame = self.frame;
    frame.origin.y = tl_y;
    self.frame = frame;
}

- (CGFloat)tl_y
{
    return self.frame.origin.y;
}

- (void)setTl_width:(CGFloat)tl_width
{
    CGRect frame = self.frame;
    frame.size.width = tl_width;
    self.frame = frame;
}

- (CGFloat)tl_width
{
    return self.frame.size.width;
}

- (void)setTl_height:(CGFloat)tl_height
{
    CGRect frame = self.frame;
    frame.size.height = tl_height;
    self.frame = frame;
}

- (CGFloat)tl_height
{
    return self.frame.size.height;
}

- (void)setTl_centerX:(CGFloat)tl_centerX
{
    CGPoint center = self.center;
    center.x = tl_centerX;
    self.center = center;
}

- (CGFloat)tl_centerX
{
    return self.center.x;
}

- (void)setTl_centerY:(CGFloat)tl_centerY
{
    CGPoint center = self.center;
    center.y = tl_centerY;
    self.center = center;
}

- (CGFloat)tl_centerY
{
    return self.center.y;
}


@end
