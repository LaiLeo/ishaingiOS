//
//  VolunteersServers.h
//  volunteers
//
//  Created by NJUser on 2021/9/27.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VolunteersServers : NSObject
//不带复杂数据的POST请求
+ (void)postWithURL:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
//不带复杂数据的GET请求
+ (void)getWithURL:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
+ (void)postQiPaWithURL:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)getWithPath:(NSString *)urlString
             token:(NSString *)token
             params:(NSDictionary *)params
            success:(void (^)(id result))success
            failure:(void (^)(NSError *error))failure;
+ (void)getWithUrlPath:(NSString *)urlString
             params:(NSDictionary *)params
            success:(void (^)(id result))success
               failure:(void (^)(NSError *error))failure;
+ (void)patchWithUrlPath:(NSString *)urlString
             params:(NSDictionary *)params
            success:(void (^)(id result))success
               failure:(void (^)(NSError *error))failure;
//DELETE
+ (void)DeleteWithPath:(NSString *)urlString
             params:(NSDictionary *)params
            success:(void (^)(id result))success
               failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
