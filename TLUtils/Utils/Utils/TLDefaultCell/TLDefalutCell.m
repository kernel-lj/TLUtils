//
//  TL_DefalutCell.m
//  MiDouLottery
//
//  Created by LTL on 16/7/29.
//  Copyright © 2016年 com.midou.enpr. All rights reserved.
//

#import "TLDefalutCell.h"

@implementation TLDefalutCell


+ (instancetype)creatTableViewCell:(UITableView *)tableView {
    
    static NSString *ID = @"defaultIdentifier";
    TLDefalutCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TLDefalutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor redColor];
    
    return cell;

}


@end
