//
//  WilloAPIV2.m
//  volunteers
//
//  Created by jauyou on 2015/1/27.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <JSONKit.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WilloAPIV2.h"

@implementation WilloAPIV2


+ (void)cancelRegistById:(NSString *)eventId viewController:(UIViewController *)viewController
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    if (token == nil) {
        return;
    }
    
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/event/unregister/%@/", [self getHostName], eventId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    
    [manager GET:request_path parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        failure(operation, error);
        
        if (operation.response.statusCode == 401){
            // token 已過期
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"token"];
            [userDefaults synchronize];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
            [viewController presentViewController:vc animated:YES completion:nil];
        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"沒有網路"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];

}

+ (void)checkTokenValidate:(void(^)(void))func
{
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/login/mobile", [self getHostName]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    if (token == nil) {
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    
    [manager GET:request_path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            if (func) {
                [self getDump:func];
            } else {
                [self getDump:nil];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);
        if (operation.response.statusCode == 401){
            // token 已過期
            [userDefaults removeObjectForKey:@"token"];
            [userDefaults synchronize];
            if (func) {
                [self getDump:func];
            } else {
                [self getDump:nil];
            }
        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            NSString *login = NSLocalizedString(@"login", @"Login");
            NSString *networkUnavailable = NSLocalizedString(@"networkUnavailable", @"Network is not available.");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:login
                                                            message:networkUnavailable
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            alert.tag = 1;
            [alert show];
        }
    }];
}

+ (void)editProfileWithParameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController
  constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))formData
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/user/profile/", [self getHostName]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    if (token != nil) {
        NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
        [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    }
    
    [manager POST:request_path parameters:parameters constructingBodyWithBlock:formData
          success:success
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              
              failure(operation, error);
              
              if (operation.response.statusCode == 401){
                  // token 已過期
                  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                  [userDefaults removeObjectForKey:@"token"];
                  [userDefaults synchronize];
                  
                  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                  UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
                  [viewController presentViewController:vc animated:YES completion:nil];
              }
              
              if (operation.error.code == -1009 || operation.error.code == -1004){
                  // 沒有網路
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                                  message:@"沒有網路"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                  [alert show];
              }
          }];

}
+ (void)deleteUserLicenseWithParameters:(NSDictionary *)parameters
                         viewController:(UIViewController *)viewController
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/user/license/", [self getHostName]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    if (token != nil) {
        NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
        [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    }
    
    [manager POST:request_path parameters:parameters
          success:success
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              
              failure(operation, error);
              
              if (operation.response.statusCode == 401){
                  // token 已過期
                  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                  [userDefaults removeObjectForKey:@"token"];
                  [userDefaults synchronize];
                  
                  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                  UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
                  [viewController presentViewController:vc animated:YES completion:nil];
              }
              
              if (operation.error.code == -1009 || operation.error.code == -1004){
                  // 沒有網路
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                                  message:@"沒有網路"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                  [alert show];
              }
          }];
    
}


+ (void)updateUserLicenseWithParameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController
        constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))formData
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/user/license/", [self getHostName]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    if (token != nil) {
        NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
        [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    }
    
    [manager POST:request_path parameters:parameters constructingBodyWithBlock:formData
          success:success
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              
              failure(operation, error);
              
              if (operation.response.statusCode == 401){
                  // token 已過期
                  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                  [userDefaults removeObjectForKey:@"token"];
                  [userDefaults synchronize];
                  
                  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                  UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
                  [viewController presentViewController:vc animated:YES completion:nil];
              }
              
              if (operation.error.code == -1009 || operation.error.code == -1004){
                  // 沒有網路
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                                  message:@"沒有網路"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                  [alert show];
              }
          }];
    
}

+ (void)focusById:(NSString *)eventId viewController:(UIViewController *)viewController
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    if (token == nil) {
        return;
    }
    
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/event/focus/%@/", [self getHostName], eventId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    
    [manager GET:request_path parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        failure(operation, error);
        
        if (operation.response.statusCode == 401){
            // token 已過期
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"token"];
            [userDefaults synchronize];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
            [viewController presentViewController:vc animated:YES completion:nil];
        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"沒有網路"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

+ (NSString*)getUploadDir
{
    return [NSString stringWithFormat:@"%@", [WilloAPIV2 getImageUrlName]];
}

+ (void)getDump:(void(^)(void))func
{
    NSString *target_url = [NSString stringWithFormat:@"%@%@", [self getHostName], @"apiv2/dump/"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    if (token != nil) {
        NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
        [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    }
    
    
    [manager GET:target_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = operation.responseString;
        NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        
        JSONDecoder* decoder = [[JSONDecoder alloc]
                                initWithParseOptions:JKParseOptionLooseUnicode];
        NSMutableArray *json = [decoder mutableObjectWithData:jsonData];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.npo = [json valueForKey:@"npo"];
        appDelegate.donation_npo = [json valueForKey:@"donation_npo"];
        appDelegate.event = [json valueForKey:@"event"];
        appDelegate.subscribe_npo = [json valueForKey:@"subscribe_npo"];
        appDelegate.user = [json valueForKey:@"user"];
        appDelegate.focused_event = [json valueForKey:@"focused_event"];
        appDelegate.registered_event = [json valueForKey:@"registered_event"];
        if (func) {
            func();
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);
        
        if (operation.response.statusCode == 401){
            // token 已過期
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"token"];
            [userDefaults synchronize];
            if (func) {
                [self getDump:func];
            } else {
                [self getDump:nil];
            }
        }
    }];
}

+ (NSString *)getHostName
{
//    return @"http://60.199.131.49:8000/";
//        return @"https://www.isharing.tw/";
//    return @"http://www.isharing.tw:8002/";
//    return @"http://isharing.fihcloud.com/old/";
    return @"https://stage-isharing.fihcloud.com/";
//    return @"http://rock.geothings.tw:8000/";
}
+ (NSString *)getImageUrlName
{
//    return @"https://isharing.fihcloud.com/";


    return @"https://stage-isharing.fihcloud.com/";

}

+ (void)joinEventWithUuid:(NSString *)uuid viewController:(UIViewController *)viewController
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    if (token == nil) {
        return;
    }
    
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/event/join/%@/", [self getHostName], uuid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    
    [manager GET:request_path parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        failure(operation, error);
        
        if (operation.response.statusCode == 401){
            // token 已過期
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"token"];
            [userDefaults synchronize];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
            [viewController presentViewController:vc animated:YES completion:nil];
        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"沒有網路"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

+ (void)judgeEventWithUuid:(NSString *)uuid Score:(NSString *)score viewController:(UIViewController *)viewController
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    if (token == nil) {
        return;
    }
    
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/event/rating/%@/score/%@/", [self getHostName], uuid, score];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    
    [manager GET:request_path parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        failure(operation, error);
        
        if (operation.response.statusCode == 401){
            // token 已過期
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"token"];
            [userDefaults synchronize];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
            [viewController presentViewController:vc animated:YES completion:nil];
        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"沒有網路"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

+ (void)leaveEventWithUuid:(NSString *)uuid viewController:(UIViewController *)viewController
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    if (token == nil) {
        return;
    }
    
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/event/leave/%@/", [self getHostName], uuid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    
    [manager GET:request_path parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        failure(operation, error);
        
        if (operation.response.statusCode == 401){
            // token 已過期
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"token"];
            [userDefaults synchronize];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
            [viewController presentViewController:vc animated:YES completion:nil];        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"沒有網路"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

+ (void)loginParameters:(NSDictionary *)parameters
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/login/mobile", [self getHostName]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer.HTTPShouldHandleCookies = false;
    
    [manager POST:request_path parameters:parameters success:success failure:failure];
}

+ (void)recieveNotification:(NSDictionary *)parameters
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/device/read/", [self getHostName]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    if (token != nil) {
        NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
        [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    }
    
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager POST:request_path parameters:parameters success:success failure:failure];
}

+ (void)registAccountParameters:(NSDictionary *)parameters
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/user/register/", [self getHostName]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager POST:request_path parameters:parameters success:success failure:failure];
}

+ (void)registDevice:(NSString *)deviceId
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/device/register/", [self getHostName]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    NSDictionary *parameters = @{@"uuid": deviceId,
                                 @"device_name": @"ios"};
    
    [manager POST:request_path parameters:parameters success:success failure:failure];
}

+ (void)registEventParameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/event/register/", [self getHostName]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    if (token != nil) {
        NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
        [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    }
    
    [manager POST:request_path parameters:parameters success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        failure(operation, error);
        NSLog(@"My Error: %ld", (long)operation.response.statusCode);

        if (operation.response.statusCode == 401){
            // token 已過期
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"token"];
            [userDefaults synchronize];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
            [viewController presentViewController:vc animated:YES completion:nil];
        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"沒有網路"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];

}

+ (void)replyWithParameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController
  constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))formData
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/reply/", [self getHostName]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    if (token != nil) {
        NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
        [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    }
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager POST:request_path parameters:parameters constructingBodyWithBlock:formData
          success:success
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"%ld", (long)operation.response.statusCode);
              NSLog(@"%@", operation.responseString);
              failure(operation, error);
              
              if (operation.response.statusCode == 401){
                  // token 已過期
                  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                  [userDefaults removeObjectForKey:@"token"];
                  [userDefaults synchronize];
                  
                  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                  UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
                  [viewController presentViewController:vc animated:YES completion:nil];
              }
              
              if (operation.error.code == -1009 || operation.error.code == -1004){
                  // 沒有網路
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                                  message:@"沒有網路"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                  [alert show];
              }
          }];
}

+ (void)resetAccountPasswordParameters:(NSDictionary *)parameters
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *request_path = [NSString stringWithFormat:@"%@api/user/forgot_password/%@/", [self getHostName], [parameters valueForKey:@"username"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager GET:request_path parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        failure(operation, error);
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"沒有網路"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

+ (void)subscribeById:(NSString *)eventId viewController:(UIViewController *)viewController
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    if (token == nil) {
        return;
    }
    
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/npo/subscribe/%@/", [self getHostName], eventId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    
    [manager GET:request_path parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        failure(operation, error);
        
        if (operation.response.statusCode == 401){
            // token 已過期
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"token"];
            [userDefaults synchronize];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
            [viewController presentViewController:vc animated:YES completion:nil];
        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"沒有網路"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

+ (void)unfocusById:(NSString *)eventId viewController:(UIViewController *)viewController
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    if (token == nil) {
        return;
    }
    
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/event/unfocus/%@/", [self getHostName], eventId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    
    [manager GET:request_path parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        failure(operation, error);
        
        if (operation.response.statusCode == 401){
            // token 已過期
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"token"];
            [userDefaults synchronize];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
            [viewController presentViewController:vc animated:YES completion:nil];
        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"沒有網路"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];

}

+ (void)unsubscribeById:(NSString *)eventId viewController:(UIViewController *)viewController
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    if (token == nil) {
        return;
    }
    
    NSString *request_path = [NSString stringWithFormat:@"%@apiv2/npo/unsubscribe/%@/", [self getHostName], eventId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    
    [manager GET:request_path parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        failure(operation, error);
        
        if (operation.response.statusCode == 401){
            // token 已過期
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"token"];
            [userDefaults synchronize];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
            [viewController presentViewController:vc animated:YES completion:nil];
        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"沒有網路"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    

}

+ (void)queryTTVolunteerRegisterStatusById:(NSString *)eventId viewController:(UIViewController *)viewController
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    if (token == nil) {
        return;
    }
    
    NSString *request_path = [NSString stringWithFormat:@"%@ttvolunteer/register/%@/", [self getHostName], eventId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *tokenString = [NSString stringWithFormat:@"Token %@", token];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:request_path parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(operation, error);
        
        if (operation.response.statusCode == 401){
            // token 已過期
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"token"];
            [userDefaults synchronize];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
            [viewController presentViewController:vc animated:YES completion:nil];
        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"沒有網路"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    
    
}




+ (NSInteger) queryUserGeneralEventHourFrom:(NSInteger)startYear to:(NSInteger) endYear{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSInteger total = 0;
    for(NSMutableDictionary *item in appDelegate.registered_event){
        NSMutableDictionary *registered_event = [item valueForKey:@"registered_event"];
        NSInteger thisYear = [[[registered_event valueForKey:@"close_date"] substringWithRange:NSMakeRange(0, 4)] integerValue];
        Boolean notJoin = ![[item valueForKey:@"isJoined"] boolValue];
        
        Boolean isEnterprise = [[[registered_event valueForKey:@"owner_NPO"] valueForKey:@"is_enterprise"] boolValue];
        if(notJoin){
            continue;
        }
        if(isEnterprise){
            continue;
        }
        if(![self isYear:thisYear Between:startYear And:endYear]){
            continue;
        }
        total += [[registered_event valueForKey:@"event_hour"] integerValue];
        
    }
    
    return total;
}
+ (NSInteger) queryUserEnterpriseEventHourFrom:(NSInteger)startYear to:(NSInteger) endYear{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSInteger total = 0;
    for(NSMutableDictionary *item in appDelegate.registered_event){
        NSMutableDictionary *registered_event = [item valueForKey:@"registered_event"];
        NSInteger thisYear = [[[registered_event valueForKey:@"close_date"] substringWithRange:NSMakeRange(0, 4)] integerValue];
        Boolean notJoin = ![[item valueForKey:@"isJoined"] boolValue];
        Boolean isEnterprise = [[[registered_event valueForKey:@"owner_NPO"] valueForKey:@"is_enterprise"] boolValue];
        if(notJoin){
            continue;
        }
        if(!isEnterprise){
            continue;
        }
        if(![self isYear:thisYear Between:startYear And:endYear]){
            continue;
        }
        total += [[registered_event valueForKey:@"event_hour"] integerValue];
        
    }
    
    return total;
    
}
+ (NSInteger) queryUserEventHourFrom:(NSInteger)startYear to:(NSInteger) endYear{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSInteger total = 0;
    for(NSMutableDictionary *item in appDelegate.registered_event){
        NSMutableDictionary *registered_event = [item valueForKey:@"registered_event"];
        NSInteger thisYear = [[[registered_event valueForKey:@"close_date"] substringWithRange:NSMakeRange(0, 4)] integerValue];
        Boolean notJoin = ![[item valueForKey:@"isJoined"] boolValue];
        if(notJoin){
            continue;
        }
        if(![self isYear:thisYear Between:startYear And:endYear]){
            continue;
        }
        total += [[registered_event valueForKey:@"event_hour"] integerValue];
        
    }
    
    return total;
    
}

+ (Boolean)isYear:(NSInteger) target Between:(NSInteger) start And:(NSInteger) end{
    if(start != 0 && target < start) return NO;
    if(end != 0 && target > end) return NO;
    return YES;
}
@end

