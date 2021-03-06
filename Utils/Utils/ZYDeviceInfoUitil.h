//
//  ZYDeviceInfoUitil.h
//  GanJiZhiYou
//
//  Created by YanPengfei on 15/8/14.
//  Copyright (c) 2015年 YanPengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DeviceSystemVersionBigThan(x)       [ZYDeviceInfoUitil deviceSystemVersionBigThan:x]
#define DeviceSystemVersionLessThan(x)      [ZYDeviceInfoUitil deviceSystemVersionLessThan:x]
#define DeviceSystemVersionEqualTo(x)       [ZYDeviceInfoUitil deviceSystemVersionEqualTo:x]
#define DeviceSystemVersionBetween(x,y)     [ZYDeviceInfoUitil deviceSystemVersionBigThan:x lessThan:y]

// ios version >= 6.0
#define IOS6                                (DeviceSystemVersionBigThan(6.0)||DeviceSystemVersionEqualTo(6.0))
// ios version >= 7.0
#define IOS7                                (DeviceSystemVersionBigThan(7.0)||DeviceSystemVersionEqualTo(7.0))
// ios version >= 8.0
#define IOS8                                (DeviceSystemVersionBigThan(8.0)||DeviceSystemVersionEqualTo(8.0))

extern NSString * const ZYDeviceInfoErrorDomain;

typedef enum : NSUInteger {
    ZYDeviceInfoMacAddressError,
    ZYDeviceInfoKeyChainError,
    
} ZYDeviceInfoErrorType;

@interface ZYDeviceInfoUitil : NSObject

/*
 * iOS 6.0以下
 * 使用wifi的mac address
 * iOS 7.0
 * 从iOS 7开始, 如果你向ios设备请求获取mac地址，系统将返回一个固定值“02:00:00:00:00:00”
 * 如果你需要识别设备的唯一性
 * 请使用UIDevice的identifierForVendor属性 + keyChain
 * 确保在删除和重新安装app时，UDID一致。
 */
+ (NSString*)getUDIDWithKeyChainUDIDAccessGroup:(NSString *)accessGroup failedError:(__autoreleasing NSError **)error;
/*
 * 网卡物理地址
 * 从iOS 7开始, 如果你向ios设备请求获取mac地址，系统将返回一个固定值“02:00:00:00:00:00”
 * 苹果对于sysctl和ioctl进行了技术处理
 */
+ (NSString *)getMacAddressFailedError:(__autoreleasing NSError **)error;

/*
 * iOS 2.0+
 * 获得的这个CFUUID值系统并没有存储。
 * 每次调用CFUUIDCreate，系统都会返回一个新的唯一标示符。
 * 如果你希望存储这个标示符，那么需要自己将其存储到NSUserDefaults, Keychain, Pasteboard或其它地方。
 */
+ (NSString *)CFUUID;

/*
 * iOS 6.0+
 * 获得的这个NSUUID值系统并没有存储。
 * 每次调用UUIDString，系统都会返回一个新的唯一标示符。
 * 如果你希望存储这个标示符，那么需要自己将其存储到NSUserDefaults, Keychain, Pasteboard或其它地方。
 * 与CFUUID差不多，objective－C调用。
 */
+ (NSString *)NSUUID;

/*
 * iOS 6.0+
 * 广告标示符是由系统存储着的。
 * 如果用户完全重置系统,这个广告标示符会重新生成。
 * 如果用户明确的还原广告，广告标示符也会重新生成。
 */
+ (NSString *)IDFA;

/*
 * iOS 6.0+
 * 相同的一个程序里面-相同的供应商-相同的设备，获取到的这个属性值就不会变。
 * 相同的程序-相同的设备-不同的供应商，或者是相同的程序-不同的设备-无论是否相同的供应商，那么这个值是不会相同的。
 * 如果用户卸载了同一个供应商对应的所有程序，然后在重新安装同一个供应商提供的程序，此时identifierForVendor会被重置。
 */
+ (NSString *)IDFV;

// > and not contain equal(=)
+ (BOOL) deviceSystemVersionBigThan:(CGFloat)minVersion;

// < and not contain equal(=)
+ (BOOL) deviceSystemVersionLessThan:(CGFloat)maxVersion;

// only equal(=)
+ (BOOL) deviceSystemVersionEqualTo:(CGFloat)equalVersion;

// > && <
+ (BOOL) deviceSystemVersionBigThan:(CGFloat)minVersion lessThan:(CGFloat)maxVersion;

@end
