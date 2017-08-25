//
//  TLIphoneDevInfo.h
//  TLUtils
//
//  Created by ltl on 2017/8/24.
//  Copyright © 2017年 dm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLIphoneDevInfo : NSObject
+ (NSString *)deviceType; /**< 获取iPhone具体型号：iPhone6s等 */
+ (NSString *)deviceIOSVersion; /**< ios版本具体版本：iOS9.2 */

@end
