//
//  TLNetworkSpeed.h
//  TLUtils
//
//  Created by ltl on 2017/8/24.
//  Copyright © 2017年 dm. All rights reserved.
//  实时网速

#import <Foundation/Foundation.h>

@interface TLNetworkSpeed : NSObject
@property (nonatomic, copy, readonly) NSString * receivedNetworkSpeed;

@property (nonatomic, copy, readonly) NSString * sendNetworkSpeed;

+ (instancetype)shareNetworkSpeed;

- (void)startMonitoringNetworkSpeed;

- (void)stopMonitoringNetworkSpeed;
@end
/**
 *  @{@"received":@"100kB/s"}
 */
FOUNDATION_EXTERN NSString *const kNetworkReceivedSpeedNotification;

/**
 *  @{@"send":@"100kB/s"}
 */
FOUNDATION_EXTERN NSString *const kNetworkSendSpeedNotification;
