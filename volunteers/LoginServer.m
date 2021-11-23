//
//  LoginServer.m
//  volunteers
//
//  Created by NJUser on 2021/9/27.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import "LoginServer.h"
#import "VolunteersServers.h"
#define Login_FubonLogin_URL @"api/v1/auth/fubon"
#define Login_FubonRegister_URL @"api/v1/users"

@implementation LoginServer
static LoginServer *_instance;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LoginServer alloc] init];
    });
    return _instance;
}

//富邦登录
-(void)PostLoginWithUserName:(NSString *)UserName  PassCode:(NSString *)PassCode success:(void (^)(NSDictionary * dic))successBlock failure:(failureBlock)failureBlock;{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"username"]=UserName;
    dic[@"password"]=PassCode;
   
    [VolunteersServers postWithURL:@"api/v1/auth/fubon" params:dic success:^(id json) {
        successBlock(json);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}
//富邦注册
-(void)PostRegisteWithUserName:(NSString *)username PassCode:(NSString *)password FirstName:(NSString *)firstName LastName:(NSString *)lastName AccessCode:(NSString *)accessCode Email:(NSString *)email
                    isSuperuser:(NSString *)isSuperuser isStaff:(NSString *)isStaff twmAccount:(NSString *)twmAccount success:(void (^)(NSArray* dic))successBlock failure:(failureBlock)failureBlock;{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"username"]=username;
    dic[@"password"]=[NSString stringWithFormat:@"%@",password];
    dic[@"firstName"]=firstName;
    dic[@"lastName"]=lastName;
    dic[@"email"]=email;
    dic[@"isSuperuser"]=isSuperuser;
    dic[@"twmAccount"]=twmAccount;
    dic[@"isStaff"]=isStaff;

    dic[@"accessCode"]=accessCode;

    [VolunteersServers postQiPaWithURL:@"api/v1/users" params:dic success:^(id json) {
        successBlock(json);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}
//富邦绑定
-(void)PostFubonWithUserName:(NSString *)username PassCode:(NSString *)password success:(void (^)(NSDictionary * dic))successBlock failure:(failureBlock)failureBlock;{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"username"]=username;
    dic[@"password"]=[NSString stringWithFormat:@"%@",password];
    
    [VolunteersServers postWithURL:@"api/v1/user/fubon" params:dic success:^(id json) {
        successBlock(json);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}
//台湾大哥大会员绑定
-(void)PostTaiwanMemberBindWithEnterpriseSerialNumber:(NSString *)enterpriseSerialNumber enterpriseSerialEmail:(NSString *)enterpriseSerialEmail  enterpriseSerialDepartment:(NSString *)enterpriseSerialDepartment enterpriseSerialName:(NSString *)enterpriseSerialName enterpriseSerialId:(NSString *)enterpriseSerialId enterpriseSerialPhone:(NSString *)enterpriseSerialPhone enterpriseSerialType:(NSString *)enterpriseSerialType enterpriseSerialGroup:(NSString *)enterpriseSerialGroup success:(void (^)(NSDictionary * dic))successBlock failure:(failureBlock)failureBlock{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"enterpriseSerialNumber"]=enterpriseSerialNumber;
    dic[@"enterpriseSerialEmail"]=enterpriseSerialEmail;
    dic[@"enterpriseSerialDepartment"]=enterpriseSerialDepartment;
    dic[@"enterpriseSerialName"]=enterpriseSerialName;
    dic[@"enterpriseSerialId"]=enterpriseSerialId;
    dic[@"enterpriseSerialPhone"]=enterpriseSerialPhone;
    dic[@"enterpriseSerialType"]=enterpriseSerialType;
    dic[@"enterpriseSerialGroup"]=enterpriseSerialGroup;

    [VolunteersServers postWithURL:@"api/v1/user/twm" params:dic success:^(id json) {
        successBlock(json);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}
//台湾大哥大会员登录
-(void)PostLoginTaiWanWithCode:(NSString *)code success:(void (^)(NSDictionary * dic))successBlock failure:(failureBlock)failureBlock;{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"code"]=code;
   
    [VolunteersServers postWithURL:@"api/v1/auth/twm" params:dic success:^(id json) {
        successBlock(json);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}
//获取个人信息
-(void)GetPersonInformationToken:(NSString *)token
                         Success:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock{
    [VolunteersServers getWithPath:@"api/v1/user/profile" token:token params:nil success:^(id  _Nonnull result) {
                successBlock(result);

    } failure:^(NSError * _Nonnull error) {
                failureBlock(error);

    }];
}
//快速签到
-(void)PostJoinEventWithUuid:(NSString *)uuid userId:(NSString *)userId success:(void (^)(NSDictionary * dic))successBlock failure:(failureBlock)failureBlock;{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"uid"]=uuid;
    dic[@"userId"]=userId;

    [VolunteersServers postQiPaWithURL:@"api/v1/events/join" params:dic success:^(id  _Nonnull json) {
        successBlock(json);

    } failure:^(NSError * _Nonnull error) {
        failureBlock(error);

    }];
}
//签退
-(void)PostLeaveEventWithUuid:(NSString *)uuid userId:(NSString *)userId success:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"uid"]=uuid;
    dic[@"userId"]=userId;

    [VolunteersServers postQiPaWithURL:@"api/v1/events/leave" params:dic success:^(id  _Nonnull json) {
        successBlock(json);

    } failure:^(NSError * _Nonnull error) {
        failureBlock(error);

    }];
}
//解除Fubon绑定
-(void)DeleteFubonNumberSuccess:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock{
    [VolunteersServers DeleteWithPath:@"api/v1/user/fubon" params:nil success:^(id  _Nonnull result) {
        successBlock(result);

    } failure:^(NSError * _Nonnull error) {
        failureBlock(error);

    }];
}
//解除taiwan绑定
-(void)DeleteTwmNumberSuccess:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock{
    [VolunteersServers DeleteWithPath:@"api/v1/user/twm" params:nil success:^(id  _Nonnull result) {
        successBlock(result);

    } failure:^(NSError * _Nonnull error) {
        failureBlock(error);

    }];
}
//传本地版本
-(void)uploadVersionSuccess:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock{
    [VolunteersServers patchWithUrlPath:@"api/v1/appConfigs" params:nil success:^(id  _Nonnull result) {
        successBlock(result);

    } failure:^(NSError * _Nonnull error) {
        failureBlock(error);
    }];
}
//获取版本
-(void)getVersionWithSuccess:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock{
    [VolunteersServers getWithUrlPath:@"api/v1/appConfigs?search=+id+eq+1" params:nil success:^(id  _Nonnull result) {
        successBlock(result);
        

    } failure:^(NSError * _Nonnull error) {
        failureBlock(error);

    }];
}
//忘记密码
-(void)forgetPassword:(NSString *)email accessPage:(NSString *)accessPage success:(void (^)(NSDictionary * _Nonnull))successBlock failure:(failureBlock)failureBlock{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"email"]=email;
    dic[@"accessPage"]=accessPage;

//    [VolunteersServers postQiPaWithURL:@"api/v1/reset/password" params:dic success:^(id  _Nonnull json) {
//        successBlock(json);
//
//    } failure:^(NSError * _Nonnull error) {
//        failureBlock(error);
//
//    }];
    [VolunteersServers postWithURL:@"api/v1/reset/password" params:dic success:^(id json) {
        successBlock(json);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}
@end
