//
//  ZYDeviceInfoUitil.m
//  GanJiZhiYou
//
//  Created by YanPengfei on 15/8/14.
//  Copyright (c) 2015年 YanPengfei. All rights reserved.
//

#import "ZYDeviceInfoUitil.h"
#import <UIKit/UIKit.h>
#import <Security/Security.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AdSupport/ASIdentifierManager.h>
#import "ZYKeychanUitil.h"

NSString * const ZYDeviceInfoErrorDomain = @"com.ZYDeviceInfo.error";

static const char kZYKeychainUDIDItemIdentifier[] = "UDID";

static const char kZYKeychainUDIDAccount[] = "com.ZYDeviceInfo";

@implementation ZYDeviceInfoUitil

+ (NSString*)getUDIDWithKeyChainUDIDAccessGroup:(NSString *)accessGroup failedError:(__autoreleasing NSError **)error
{
    if(!accessGroup){
        if (error){
            *error = [NSError errorWithDomain:ZYDeviceInfoErrorDomain code:ZYDeviceInfoKeyChainError userInfo:nil];
        }
        
        return nil;
    }
    
    NSString *udid = nil;
    
    NSString *sysVersion = [UIDevice currentDevice].systemVersion;
    CGFloat version = [sysVersion floatValue];
    
    if( version < 7.0 && version >=2.0){
        
        udid = [ZYDeviceInfoUitil getMacAddressFailedError:error];
        
    }else if(version >=7.0){
        
        udid = [ZYDeviceInfoUitil getUDIDFromKeyChainWithAccessGroup:accessGroup failedError:error];
        
        NSError * error_ = * error;
        
        if( error_ &&error_.code != errSecItemNotFound){
            
            return nil;
        }
        
        if (!udid) {
            
            udid = [ZYDeviceInfoUitil IDFV];
            
            [ZYDeviceInfoUitil settUDIDToKeyChain:udid accessGroup:accessGroup failedError:error];
        }
        
        
    }
    
    
    
    return udid;
}

/*
 * iOS 2.0+
 * 获得的这个CFUUID值系统并没有存储。
 * 每次调用CFUUIDCreate，系统都会返回一个新的唯一标示符。
 * 如果你希望存储这个标示符，那么需要自己将其存储到NSUserDefaults, Keychain, Pasteboard或其它地方。
 */

+ (NSString *)CFUUID
{
    NSString *cfuuidString = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_2_0
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 2.0){
        
        CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
        
        cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
        CFRelease(cfuuid);
    }
#endif
    return cfuuidString;
    
}

/*
 * iOS 6.0+
 * 获得的这个NSUUID值系统并没有存储。
 * 每次调用UUIDString，系统都会返回一个新的唯一标示符。
 * 如果你希望存储这个标示符，那么需要自己将其存储到NSUserDefaults, Keychain, Pasteboard或其它地方。
 * 与CFUUID差不多，objective－C调用。
 */

+ (NSString *)NSUUID
{
    NSString *uuid = nil;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0){
        
        uuid = [[NSUUID UUID] UUIDString];
        
    }
#endif
    return uuid;
    
}

/*
 * iOS 6.0+
 * 广告标示符是由系统存储着的。
 * 如果用户完全重置系统,这个广告标示符会重新生成。
 * 如果用户明确的还原广告，广告标示符也会重新生成。
 */

+ (NSString *)IDFA
{
    NSString *adId = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0){
        
        adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
#endif
    
    return adId;
}

/*
 * iOS 6.0+
 * 相同的一个程序里面-相同的供应商-相同的设备，获取到的这个属性值就不会变。
 * 相同的程序-相同的设备-不同的供应商，或者是相同的程序-不同的设备-无论是否相同的供应商，那么这个值是不会相同的。
 * 如果用户卸载了同一个供应商对应的所有程序，然后在重新安装同一个供应商提供的程序，此时identifierForVendor会被重置。
 */
+ (NSString *)IDFV
{
    NSString *idfv = nil;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0){
        
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
#endif
    
    
    return idfv;
    
}

#pragma mark -
#pragma mark Helper Method for Get Mac Address

// from http://stackoverflow.com/questions/677530/how-can-i-programmatically-get-the-mac-address-of-an-iphone
+ (NSString *)getMacAddressFailedError:(__autoreleasing NSError **)error
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    
    // 设置管理信息库 (mib)
    mgmtInfoBase[0] = CTL_NET;        // 请求网络子系统
    mgmtInfoBase[1] = AF_ROUTE;       // 路由表信息
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // 请求链路层信息
    mgmtInfoBase[4] = NET_RT_IFLIST;  // 请求所有配置的接口
    
    //获得接口en0(物理网卡接口，可获得网卡ip地址)在所配置接口中的index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0){
        if (error){
            *error = [NSError errorWithDomain:ZYDeviceInfoErrorDomain code:ZYDeviceInfoMacAddressError userInfo:nil];
        }
    }
    else
    {
        /*
         * sysctl(int *, u_int, void *, size_t *, void *, size_t)
         * 第一个参数为一个描述所请求信息的数组，苹果命名其为“管理信息库”（mib）
         * 第二个参数为参数一数组元素个数
         * 第三个参数和第四个参数分别为输出buffer和输出buffer的size
         *
         */
        // 获得输出buffer的size，保存在length中
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0){
            if (error){
                *error = [NSError errorWithDomain:ZYDeviceInfoErrorDomain code:ZYDeviceInfoMacAddressError userInfo:nil];
            }
        }
        else
        {
            // 根据length alloc输出buffer
            if ((msgBuffer = malloc(length)) == NULL){
                if (error){
                    *error = [NSError errorWithDomain:ZYDeviceInfoErrorDomain code:ZYDeviceInfoMacAddressError userInfo:nil];
                }
            }
            else
            {
                // 将获取的信息存储在buffer中
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0){
                    if (error){
                        *error = [NSError errorWithDomain:ZYDeviceInfoErrorDomain code:ZYDeviceInfoMacAddressError userInfo:nil];
                    }
                }
            }
        }
    }
    
    // Befor going any further...
    if (error)
    {
        if (*error)
        {
            if (msgBuffer) {
                free(msgBuffer);
            }
            return nil;
        }
    }
    
    if (msgBuffer)
    {
        // 把msgBuffer映射到报文结构
        interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // 映射到链路层socket结构
        socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // 复制套接字结构链路层地址的数据到一个数组
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // 从字符数组读入一个字符串对象，形成传统的MAC地址的格式
        NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2],
                                      macAddress[3], macAddress[4], macAddress[5]];
        NSLog(@"Mac Address: %@", macAddressString);
        
        // Release the buffer memory
        free(msgBuffer);
        
        return macAddressString;
    }
    return nil;
}

#pragma mark -
#pragma mark Helper Method for make identityForVendor consistency

+ (NSString*)getUDIDFromKeyChainWithAccessGroup:(NSString *)accessGroup failedError:(__autoreleasing NSError **)error
{
    NSString * udid = nil;
    
    NSData * udidValue = (NSData *)[ZYKeychanUitil getDataWithAccount:[NSString stringWithUTF8String:kZYKeychainUDIDAccount] service:[NSString stringWithUTF8String:kZYKeychainUDIDItemIdentifier] accessGroup:accessGroup error:error];
    
    if(udidValue){
        
        udid = [NSString stringWithUTF8String:udidValue.bytes];
    }
    
    return udid;
    
}

+ (BOOL)settUDIDToKeyChain:(NSString*)udid accessGroup:(NSString *)accessGroup failedError:(__autoreleasing NSError **)error
{
    
    const char *udidStr = [udid UTF8String];
    NSData *keyChainItemValue = [NSData dataWithBytes:udidStr length:strlen(udidStr)];
    
    [ZYKeychanUitil saveData:keyChainItemValue account:[NSString stringWithUTF8String:kZYKeychainUDIDAccount] service:[NSString stringWithUTF8String:kZYKeychainUDIDItemIdentifier] accessGroup:accessGroup error:error];
    
    return YES;
}

+ (BOOL)removeUDIDFromKeyChain
{
    NSMutableDictionary *dictToDelete = [[NSMutableDictionary alloc] init];
    
    [dictToDelete setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *keyChainItemID = [NSData dataWithBytes:kZYKeychainUDIDItemIdentifier length:strlen(kZYKeychainUDIDItemIdentifier)];
    [dictToDelete setValue:keyChainItemID forKey:(__bridge id)kSecAttrGeneric];
    
    OSStatus deleteErr = noErr;
    deleteErr = SecItemDelete((__bridge CFDictionaryRef)dictToDelete);
    if (deleteErr != errSecSuccess) {
        NSLog(@"delete UUID from KeyChain Error!!! Error code:%ld", (long)deleteErr);
        return NO;
    }
    else {
        NSLog(@"delete success!!!");
    }
    
    return YES;
}

+ (BOOL) deviceSystemVersionBigThan:(CGFloat)minVersion {
    BOOL value = NO;
    NSAssert(minVersion > 0.0, @"系统版本不能为0");
    CGFloat deviceSystemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    value = deviceSystemVersion > minVersion;
    return value;
}

+ (BOOL) deviceSystemVersionLessThan:(CGFloat)maxVersion {
    BOOL value = NO;
    NSAssert(maxVersion > 0.0, @"系统版本不能为0");
    CGFloat deviceSystemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    value = deviceSystemVersion < maxVersion;
    return value;
}

+ (BOOL) deviceSystemVersionEqualTo:(CGFloat)equalVersion {
    BOOL value = NO;
    NSAssert(equalVersion > 0.0, @"系统版本不能为0");
    CGFloat deviceSystemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    value = (deviceSystemVersion == equalVersion);
    return value;
}

+ (BOOL) deviceSystemVersionBigThan:(CGFloat)minVersion lessThan:(CGFloat)maxVersion {
    BOOL big = [self deviceSystemVersionBigThan:minVersion];
    BOOL less = [self deviceSystemVersionLessThan:maxVersion];
    return big && less;
}

@end
