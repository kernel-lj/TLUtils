//
//  ZYKeychanUitil.m
//  GanJiZhiYou
//
//  Created by YanPengfei on 15/8/14.
//  Copyright (c) 2015年 YanPengfei. All rights reserved.
//

#import "ZYKeychanUitil.h"
#import <AdSupport/ASIdentifierManager.h>

NSString * const ZYKeychainErrorDomain = @"com.ZYKeychainInfo.error";

@implementation ZYKeychanUitil

+ (NSMutableDictionary *)getBaseKeychainQueryWithAccount:(NSString *)account service:(NSString *)service accessGroup:(NSString *)accessGroup {
    NSMutableDictionary *dictForQuery = [NSMutableDictionary dictionary];
    
    [dictForQuery setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [dictForQuery setObject:account forKey:(__bridge id)kSecAttrAccount];
    [dictForQuery setObject:service forKey:(__bridge id)kSecAttrService];
    
    // accessGroup决定谁可以共享此item的信息
    // 其中包括多个应用程序的代码签名权利包含相同的钥匙链访问组
    
    if (accessGroup != nil)
    {
#if TARGET_IPHONE_SIMULATOR
        // 如果在模拟器上运行，则忽略accessGroup
        //
        // 模拟器运行app没有签名, 所以这里没有accessGroup
        // 在模拟器上运行时，所有的应用程序可以看到所有钥匙串项目
        //
        // 如果SecItem包含accessGroup,当SecItemAdd and SecItemUpdate时，将返回-25243 (errSecNoAccessForItem)
#else
        [dictForQuery setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
#endif
    }
    
    return dictForQuery;
}

+(NSData *)getDataWithAccount:(NSString *)account service:(NSString *)service accessGroup:(NSString *)accessGroup error:(__autoreleasing NSError **)error
{
    
    NSMutableDictionary *dictForQuery = [ZYKeychanUitil getBaseKeychainQueryWithAccount:account service:service accessGroup:accessGroup];
    
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecMatchCaseInsensitive];
    [dictForQuery setValue:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [dictForQuery setValue:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    OSStatus queryErr   = noErr;
    NSData *udidValue = nil;
    CFTypeRef inTypeRef = nil;
    
    queryErr = SecItemCopyMatching((__bridge CFDictionaryRef)dictForQuery, (CFTypeRef*)&inTypeRef);
    
    udidValue = (__bridge NSData*)inTypeRef;
    
    if (queryErr != errSecSuccess) {
        NSLog(@"KeyChain Item query Error!!! Error code:%ld", (long)queryErr);
        if (error) {
            *error = [NSError errorWithDomain:ZYKeychainErrorDomain code:queryErr userInfo:nil];
        }
    }
    
    return udidValue;
    
}

+(BOOL)saveData:(NSData *)data account:(NSString *)account service:(NSString *)service accessGroup:(NSString *)accessGroup error:(__autoreleasing NSError **)error;
{
    
    NSMutableDictionary *dictForAdd = [ZYKeychanUitil getBaseKeychainQueryWithAccount:account service:service accessGroup:accessGroup];
    
    
    [dictForAdd setObject:@"" forKey:(__bridge id)kSecAttrLabel];
    
    [dictForAdd setValue:data forKey:(__bridge id)kSecValueData];
    
    OSStatus writeErr = noErr;
    
    // 向keychain中添加数据
    writeErr = SecItemAdd((__bridge CFDictionaryRef)dictForAdd, NULL);
    
    if (writeErr != errSecSuccess) {
        NSLog(@"Add KeyChain Item Error!!! Error Code:%ld", (long)writeErr);
        if (error) {
            *error = [NSError errorWithDomain:ZYKeychainErrorDomain code:writeErr userInfo:nil];
        }
    }
    
    return YES;
}

+(BOOL)deleteDataWithAccount:(NSString *)account service:(NSString *)service accessGroup:(NSString *)accessGroup error:(__autoreleasing NSError **)error
{
    
    NSMutableDictionary *dictForDelete = [ZYKeychanUitil getBaseKeychainQueryWithAccount:account service:service accessGroup:accessGroup];
    
    OSStatus deleteErr = noErr;
    
    deleteErr = SecItemDelete((__bridge CFDictionaryRef)dictForDelete);
    
    if(deleteErr != errSecSuccess){
        if (error) {
            *error = [NSError errorWithDomain:ZYKeychainErrorDomain code:deleteErr userInfo:nil];
        }
    }
    return YES;
}

+(BOOL)updateData:(NSData *)data account:(NSString *)account service:(NSString *)service accessGroup:(NSString *)accessGroup error:(__autoreleasing NSError **)error
{
    
    //    NSMutableDictionary *dictForQuery = [GJCFKeychanUitil getBaseKeychainQueryWithAccount:account service:service accessGroup:accessGroup];
    //
    //
    //    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecMatchCaseInsensitive];
    //    [dictForQuery setValue:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    //    [dictForQuery setValue:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    //    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    //
    //    NSDictionary *queryResult = nil;
    //    OSStatus queryErr = noErr;
    //
    //    CFDictionaryRef queryResultRef = nil;
    //
    //     queryErr = SecItemCopyMatching((__bridge CFDictionaryRef)dictForQuery,  (CFTypeRef*)&queryResultRef);
    //
    //
    //
    //    if (queryResultRef) {
    //
    //        NSMutableDictionary *dictForUpdate = [GJCFKeychanUitil getBaseKeychainQueryWithAccount:account service:service accessGroup:accessGroup];
    //
    //
    //        [dictForUpdate setValue:data forKey:(__bridge id)kSecValueData];
    //
    //        OSStatus updateErr = noErr;
    //
    //        // First we need the attributes from the Keychain.
    //        NSMutableDictionary *updateItem = [NSMutableDictionary dictionaryWithDictionary:queryResult];
    //
    //
    //        updateErr = SecItemUpdate((__bridge CFDictionaryRef)updateItem, (__bridge CFDictionaryRef)dictForUpdate);
    //        if (updateErr != errSecSuccess) {
    //            NSLog(@"Update KeyChain Item Error!!! Error Code:%ld", updateErr);
    //            
    //            *error = [NSError errorWithDomain:GJCFKeychainErrorDomain code:updateErr userInfo:nil];
    // 
    //        }
    //       
    //    }
    return YES;
}

@end
