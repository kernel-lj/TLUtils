//
//  ZYKeychanUitil.h
//  GanJiZhiYou
//
//  Created by YanPengfei on 15/8/14.
//  Copyright (c) 2015年 YanPengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ZYKeychainErrorDomain;

@interface ZYKeychanUitil : NSObject

/**
 *  keychan保存数据
 *
 *  @param data         需要保存的data
 *  @param account      用户名
 *  @param service      添加的item所相关的服务
 *  @param accessGroup  共享keychan的组
 *  @param error        错误
 */
+(BOOL)saveData:(NSData *)data account:(NSString *)account service:(NSString *)service accessGroup:(NSString *)accessGroup error:(__autoreleasing NSError **)error;

/**
 *  keychan获取数据
 *
 *  @param data         需要保存的data
 *  @param account      用户名
 *  @param service      添加的item所相关的服务
 *  @param accessGroup  共享keychan的组
 *  @param error        错误
 */
+(NSData *)getDataWithAccount:(NSString *)account service:(NSString *)service accessGroup:(NSString *)accessGroup error:(__autoreleasing NSError **)error;

/**
 *  keychan删除数据
 *
 *  @param data         需要保存的data
 *  @param account      用户名
 *  @param service      添加的item所相关的服务
 *  @param accessGroup  共享keychan的组
 *  @param error        错误
 */
+(BOOL)deleteDataWithAccount:(NSString *)account service:(NSString *)service accessGroup:(NSString *)accessGroup error:(__autoreleasing NSError **)error;

@end
