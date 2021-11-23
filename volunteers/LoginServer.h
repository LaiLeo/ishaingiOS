//
//  LoginServer.h
//  volunteers
//
//  Created by NJUser on 2021/9/27.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^failureBlock)(NSError * error);

@interface LoginServer : NSObject
+ (instancetype)shareInstance;

-(void)PostLoginWithUserName:(NSString *)UserName  PassCode:(NSString *)PassCode success:(void (^)(NSDictionary * dic))successBlock failure:(failureBlock)failureBlock;
//富邦注册
-(void)PostRegisteWithUserName:(NSString *)username PassCode:(NSString *)password FirstName:(NSString *)firstName LastName:(NSString *)lastName AccessCode:(NSString *)accessCode Email:(NSString *)email
                    isSuperuser:(NSString *)isSuperuser isStaff:(NSString *)isStaff twmAccount:(NSString *)twmAccount success:(void (^)(NSArray * dic))successBlock failure:(failureBlock)failureBlock;
//台湾大哥大会员登录
-(void)PostLoginTaiWanWithCode:(NSString *)code success:(void (^)(NSDictionary * dic))successBlock failure:(failureBlock)failureBlock;
-(void)GetPersonInformationToken:(NSString *)token
                         Success:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock;
//富邦前往绑定
-(void)PostFubonWithUserName:(NSString *)username PassCode:(NSString *)password success:(void (^)(NSDictionary * dic))successBlock failure:(failureBlock)failureBlock;
//台湾大哥大会员前往绑定
-(void)PostTaiwanMemberBindWithEnterpriseSerialNumber:(NSString *)enterpriseSerialNumber enterpriseSerialEmail:(NSString *)enterpriseSerialEmail  enterpriseSerialDepartment:(NSString *)enterpriseSerialDepartment enterpriseSerialName:(NSString *)enterpriseSerialName enterpriseSerialId:(NSString *)enterpriseSerialId enterpriseSerialPhone:(NSString *)enterpriseSerialPhone enterpriseSerialType:(NSString *)enterpriseSerialType enterpriseSerialGroup:(NSString *)enterpriseSerialGroup success:(void (^)(NSDictionary * dic))successBlock failure:(failureBlock)failureBlock;
//快速签到
-(void)PostJoinEventWithUuid:(NSString *)uuid userId:(NSString *)userId success:(void (^)(NSDictionary * dic))successBlock failure:(failureBlock)failureBlock;
//签退
-(void)PostLeaveEventWithUuid:(NSString *)uuid userId:(NSString *)userId success:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock;
//解除Fubon绑定
-(void)DeleteFubonNumberSuccess:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock;
//解除taiwan绑定
-(void)DeleteTwmNumberSuccess:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock;
//传本地版本
-(void)uploadVersionSuccess:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock;
//版本更新
-(void)getVersionWithSuccess:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock;
//忘记密码
-(void)forgetPassword:(NSString *)email accessPage:(NSString *)accessPage success:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
