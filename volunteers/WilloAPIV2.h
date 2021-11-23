//
//  WilloAPIV2.h
//  volunteers
//
//  Created by jauyou on 2015/1/27.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface WilloAPIV2 : NSObject

+ (void)cancelRegistById:(NSString *)eventId viewController:(UIViewController *)viewController
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)checkTokenValidate:(void(^)(void))func;
+ (void)editProfileWithParameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController
        constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))formData
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)deleteUserLicenseWithParameters:(NSDictionary *)parameters
                         viewController:(UIViewController *)viewController
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)updateUserLicenseWithParameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController
        constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))formData
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)focusById:(NSString *)eventId viewController:(UIViewController *)viewController
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (NSString*)getUploadDir;
+ (void)getDump:(void(^)(void))func;
+ (NSString *)getHostName;
+ (NSString *)getImageUrlName;
+ (void)joinEventWithUuid:(NSString *)uuid viewController:(UIViewController *)viewController
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)judgeEventWithUuid:(NSString *)uuid Score:(NSString *)score viewController:(UIViewController *)viewController
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)leaveEventWithUuid:(NSString *)uuid viewController:(UIViewController *)viewController
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)loginParameters:(NSDictionary *)parameters
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)recieveNotification:(NSDictionary *)parameters
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)registAccountParameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)registDevice:(NSString *)deviceId
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)registEventParameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)replyWithParameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController
  constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))formData
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)resetAccountPasswordParameters:(NSDictionary *)parameters
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)subscribeById:(NSString *)eventId viewController:(UIViewController *)viewController
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)unfocusById:(NSString *)eventId viewController:(UIViewController *)viewController
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)unsubscribeById:(NSString *)eventId viewController:(UIViewController *)viewController
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)queryTTVolunteerRegisterStatusById:(NSString *)eventId viewController:(UIViewController *)viewController
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (NSInteger) queryUserGeneralEventHourFrom:(NSInteger)startYear to:(NSInteger) endYear;
+ (NSInteger) queryUserEnterpriseEventHourFrom:(NSInteger)startYear to:(NSInteger) endYear;
+ (NSInteger) queryUserEventHourFrom:(NSInteger)startYear to:(NSInteger) endYear;


+ (Boolean)isYear:(NSInteger) target Between:(NSInteger) start And:(NSInteger) end;


@end
/*
NSInteger const TAG_INTERVAL_PICKER ;
NSInteger const TAG_LOCALCATION_PICKER ;
NSInteger const TAG_FULL_STATUS_PICKER ;

NSInteger const TAG_EVENT_COLLECTION;
NSInteger const TAG_NPO_COLLECTION  ;

NSInteger const TAG_INTERVAL_ALL    ;
NSInteger const TAG_INTERVAL_URGENT ;
NSInteger const TAG_INTERVAL_LONG   ;
NSInteger const TAG_INTERVAL_SHORT  ;
*/
