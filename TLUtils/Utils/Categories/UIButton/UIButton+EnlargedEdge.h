//
//  UIButton+EnlargedEdge.h
//  MiDouLottery
//
//  Created by yesdgq on 16/7/11.
//  Copyright © 2016年 com.midou.enpr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionHandler)();
@interface UIButton (EnlargedEdge)

// 扩张的边界大小
@property (nonatomic, assign) CGFloat enlargedEdge;
// 设置四个边界扩充的大小
- (void)setEnlargedEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

// 将target-action改造为block
- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionHandler)action;

@end
