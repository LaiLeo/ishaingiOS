//
//  VolunteersServers.m
//  volunteers
//
//  Created by NJUser on 2021/9/27.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import "VolunteersServers.h"
#import "ServerConfig.h"
#import "AFNetworking.h"
#import<CommonCrypto/CommonDigest.h>
#import "AFAppDotNetAPIClient.h"
#import "GTMBase64.h"
#import "CommonCrypto/CommonHMAC.h"

#define SecretKey @"7b710ff6d11fda1c386111a60e5e0702"

@implementation VolunteersServers
+ (void)postWithURL:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
 
    NSString *Newstring = [NSString stringWithFormat:@"%@%@",ServerConfig.base_url,urlString];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *devToken = [userDefaults stringForKey:@"token"];
    
   
    //初始化Manager
    AFHTTPSessionManager *manager = [AFAppDotNetAPIClient shareClient];
    // 是否允许无效证书, 默认为NO
        manager.securityPolicy.allowInvalidCertificates = YES;
        // 是否校验域名, 默认为YES
        manager.securityPolicy.validatesDomainName = NO;
    //内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/javascript", nil];
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
 // ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    NSString *Version = @"v1";
    NSString *AccessKeyId = @"testid";
    NSString *SignatureMethod = @"HMAC-SHA1";
    NSString *Timestamp = [self gs_getCurrentTimeStringToMilliSecond];
    NSString *SignatureVersion = @"1.0";
    NSString *SignatureNonce = [self getUUIDInKeychain];//
    NSArray *array = @[Version,AccessKeyId,SignatureMethod,Timestamp,SignatureVersion,SignatureNonce];
    NSString *signatureText = [array componentsJoinedByString:@"\n"];
    NSString *accessKeySecret = SecretKey;
//    NSString *signature = [self sha1_base64:signatureStr];
        NSString *signature = [self Base_HmacSha1:accessKeySecret data:signatureText];

//    signatureText
    //新增请求头参数
//    [manager requestSerializer setValue:@"text/html; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:devToken forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:SignatureNonce forHTTPHeaderField:@"X-Request-ID"];

    [manager.requestSerializer setValue:Version forHTTPHeaderField:@"Version"];
    [manager.requestSerializer setValue:AccessKeyId forHTTPHeaderField:@"AccessKeyId"];
    [manager.requestSerializer setValue:SignatureMethod forHTTPHeaderField:@"SignatureMethod"];
    [manager.requestSerializer setValue:Timestamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:SignatureVersion forHTTPHeaderField:@"SignatureVersion"];
    [manager.requestSerializer setValue:SignatureNonce forHTTPHeaderField:@"SignatureNonce"];
    [manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];

    NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonrequestStr  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"---add header---%@",manager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"---set url---%@",Newstring);
    NSLog(@"---set requestBody---%@",params);

//    [manager.requestSerializer requestWithMethod:@"POST" URLString:Newstring parameters:params error:nil];
//    
    [manager POST:Newstring parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response == %@",responseObject);

        //请求成功，解析数据
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //请求失败
        if(failure != nil) {
            NSLog(@"error == %@",error);
            failure(error);
        }
    }];
    
}

+ (void)postQiPaWithURL:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    NSString *Newstring = [NSString stringWithFormat:@"%@%@",ServerConfig.base_url,urlString];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *devToken = [userDefaults stringForKey:@"token"];
    
    NSMutableArray *tempArray =[NSMutableArray array];//创建一个数组
    [tempArray addObject:params];
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"key"]=tempArray;
   
    //初始化Manager
    AFHTTPSessionManager *manager = [AFAppDotNetAPIClient shareClient];
    //内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/javascript", nil];
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
 // ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    NSString *Version = @"v1";
    NSString *AccessKeyId = @"testid";
    NSString *SignatureMethod = @"HMAC-SHA1";
    NSString *Timestamp = [self gs_getCurrentTimeStringToMilliSecond];
    NSString *SignatureVersion = @"1.0";
    NSString *SignatureNonce = [self getUUIDInKeychain];//
    NSArray *array = @[Version,AccessKeyId,SignatureMethod,Timestamp,SignatureVersion,SignatureNonce];
    NSString *signatureText = [array componentsJoinedByString:@"\n"];
    NSString *accessKeySecret = SecretKey;
//    NSString *signature = [self sha1_base64:signatureStr];
        NSString *signature = [self Base_HmacSha1:accessKeySecret data:signatureText];

//    signatureText
    //新增请求头参数
//    [manager requestSerializer setValue:@"text/html; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:devToken forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:SignatureNonce forHTTPHeaderField:@"X-Request-ID"];

    [manager.requestSerializer setValue:Version forHTTPHeaderField:@"Version"];
    [manager.requestSerializer setValue:AccessKeyId forHTTPHeaderField:@"AccessKeyId"];
    [manager.requestSerializer setValue:SignatureMethod forHTTPHeaderField:@"SignatureMethod"];
    [manager.requestSerializer setValue:Timestamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:SignatureVersion forHTTPHeaderField:@"SignatureVersion"];
    [manager.requestSerializer setValue:SignatureNonce forHTTPHeaderField:@"SignatureNonce"];
    [manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];

    NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonrequestStr  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"---add header---%@",manager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"---set url---%@",Newstring);
    NSLog(@"---set requestBody---%@",tempArray);
    [manager POST:Newstring parameters:tempArray success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，解析数据
        NSLog(@"response == %@",responseObject);

        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //请求失败
        if(failure != nil) {
            failure(error);
        }
    }];
}


+ (void)getWithURL:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    NSString *Newstring = [NSString stringWithFormat:@"%@%@",ServerConfig.base_url,urlString];
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithDictionary:params];
    //发送请求
    AFHTTPSessionManager *manager = [AFAppDotNetAPIClient shareClient];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/javascript", nil];
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
//    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    
    //新增请求头参数
    NSData   *data=  [NSJSONSerialization dataWithJSONObject:param options:[AFJSONRequestSerializer serializer].writingOptions error:nil];
    NSString *jsonrequestStr  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString  *jsonWithUserCode = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userCode"],jsonrequestStr];
    NSString *md5Str=  [self md5:jsonWithUserCode];
    [manager.requestSerializer setValue:md5Str forHTTPHeaderField:@"sign"]; //MD5 加密  sign：(userCode+request(json格式))的MD5
    
    [manager POST:Newstring parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，解析数据
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //请求失败
        if(failure != nil) {
            failure(error);
        }
    }];
}
+ (void)getWithPath:(NSString *)urlString
             token:(NSString *)token
             params:(NSDictionary *)params
            success:(void (^)(id result))success
            failure:(void (^)(NSError *error))failure {
    //获取完整的url路径
    NSString *Newstring = [NSString stringWithFormat:@"%@%@",ServerConfig.base_url,urlString];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *devToken = [userDefaults stringForKey:@"deviceToken"];
    
    //初始化Manager
    AFHTTPSessionManager *manager = [AFAppDotNetAPIClient shareClient];
    //内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/javascript", nil];
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
 // ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    NSString *Version = @"v1";
    NSString *AccessKeyId = @"testid";
    NSString *SignatureMethod = @"HMAC-SHA1";
    NSString *Timestamp = [self gs_getCurrentTimeStringToMilliSecond];
    NSString *SignatureVersion = @"1.0";
    NSString *SignatureNonce = [self getUUIDInKeychain];//
    NSArray *array = @[Version,AccessKeyId,SignatureMethod,Timestamp,SignatureVersion,SignatureNonce];
    NSString *signatureText = [array componentsJoinedByString:@"\n"];
    NSString *accessKeySecret = SecretKey;
//    NSString *signature = [self sha1_base64:signatureStr];
        NSString *signature = [self Base_HmacSha1:accessKeySecret data:signatureText];

//    signatureText
    //新增请求头参数
//    [manager requestSerializer setValue:@"text/html; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:SignatureNonce forHTTPHeaderField:@"X-Request-ID"];

    [manager.requestSerializer setValue:Version forHTTPHeaderField:@"Version"];
    [manager.requestSerializer setValue:AccessKeyId forHTTPHeaderField:@"AccessKeyId"];
    [manager.requestSerializer setValue:SignatureMethod forHTTPHeaderField:@"SignatureMethod"];
    [manager.requestSerializer setValue:Timestamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:SignatureVersion forHTTPHeaderField:@"SignatureVersion"];
    [manager.requestSerializer setValue:SignatureNonce forHTTPHeaderField:@"SignatureNonce"];
    [manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];

   
    NSLog(@"---请求头%@",manager.requestSerializer.HTTPRequestHeaders);
//    [manager.requestSerializer requestWithMethod:@"POST" URLString:Newstring parameters:params error:nil];

    
    [manager GET:Newstring parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，解析数据
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
       if(failure != nil) {
           failure(error);
       }
    }];

}
//DELETE
+ (void)DeleteWithPath:(NSString *)urlString
             params:(NSDictionary *)params
            success:(void (^)(id result))success
            failure:(void (^)(NSError *error))failure {
    //获取完整的url路径
    NSString *Newstring = [NSString stringWithFormat:@"%@%@",ServerConfig.base_url,urlString];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *devToken = [userDefaults stringForKey:@"token"];
    
    //初始化Manager
    AFHTTPSessionManager *manager = [AFAppDotNetAPIClient shareClient];
    //内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/javascript", nil];
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
 // ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    NSString *Version = @"v1";
    NSString *AccessKeyId = @"testid";
    NSString *SignatureMethod = @"HMAC-SHA1";
    NSString *Timestamp = [self gs_getCurrentTimeStringToMilliSecond];
    NSString *SignatureVersion = @"1.0";
    NSString *SignatureNonce = [self getUUIDInKeychain];//
    NSArray *array = @[Version,AccessKeyId,SignatureMethod,Timestamp,SignatureVersion,SignatureNonce];
    NSString *signatureText = [array componentsJoinedByString:@"\n"];
    NSString *accessKeySecret = SecretKey;
//    NSString *signature = [self sha1_base64:signatureStr];
        NSString *signature = [self Base_HmacSha1:accessKeySecret data:signatureText];

//    signatureText
    //新增请求头参数
//    [manager requestSerializer setValue:@"text/html; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:devToken forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:SignatureNonce forHTTPHeaderField:@"X-Request-ID"];

    [manager.requestSerializer setValue:Version forHTTPHeaderField:@"Version"];
    [manager.requestSerializer setValue:AccessKeyId forHTTPHeaderField:@"AccessKeyId"];
    [manager.requestSerializer setValue:SignatureMethod forHTTPHeaderField:@"SignatureMethod"];
    [manager.requestSerializer setValue:Timestamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:SignatureVersion forHTTPHeaderField:@"SignatureVersion"];
    [manager.requestSerializer setValue:SignatureNonce forHTTPHeaderField:@"SignatureNonce"];
    [manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];

   
    NSLog(@"---add header---%@",manager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"---set url---%@",Newstring);

    [manager DELETE:Newstring parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，解析数据
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
       if(failure != nil) {
           failure(error);
       }
    }];

}
+ (void)getWithUrlPath:(NSString *)urlString
             params:(NSDictionary *)params
            success:(void (^)(id result))success
            failure:(void (^)(NSError *error))failure {
    //获取完整的url路径
    NSString *Newstring = [NSString stringWithFormat:@"%@%@",ServerConfig.base_url,urlString];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *devToken = [userDefaults stringForKey:@"deviceToken"];
    
    //初始化Manager
    AFHTTPSessionManager *manager = [AFAppDotNetAPIClient shareClient];
    //内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/javascript", nil];
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
 // ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    NSString *Version = @"v1";
    NSString *AccessKeyId = @"testid";
    NSString *SignatureMethod = @"HMAC-SHA1";
    NSString *Timestamp = [self gs_getCurrentTimeStringToMilliSecond];
    NSString *SignatureVersion = @"1.0";
    NSString *SignatureNonce = [self getUUIDInKeychain];//
    NSArray *array = @[Version,AccessKeyId,SignatureMethod,Timestamp,SignatureVersion,SignatureNonce];
    NSString *signatureText = [array componentsJoinedByString:@"\n"];
    NSString *accessKeySecret = SecretKey;
//    NSString *signature = [self sha1_base64:signatureStr];
        NSString *signature = [self Base_HmacSha1:accessKeySecret data:signatureText];

//    signatureText
    //新增请求头参数
//    [manager requestSerializer setValue:@"text/html; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:devToken forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:SignatureNonce forHTTPHeaderField:@"X-Request-ID"];

    [manager.requestSerializer setValue:Version forHTTPHeaderField:@"Version"];
    [manager.requestSerializer setValue:AccessKeyId forHTTPHeaderField:@"AccessKeyId"];
    [manager.requestSerializer setValue:SignatureMethod forHTTPHeaderField:@"SignatureMethod"];
    [manager.requestSerializer setValue:Timestamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:SignatureVersion forHTTPHeaderField:@"SignatureVersion"];
    [manager.requestSerializer setValue:SignatureNonce forHTTPHeaderField:@"SignatureNonce"];
    [manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];

   
    NSLog(@"---请求头%@",manager.requestSerializer.HTTPRequestHeaders);
//    [manager.requestSerializer requestWithMethod:@"POST" URLString:Newstring parameters:params error:nil];

    
    [manager GET:Newstring parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，解析数据
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
       if(failure != nil) {
           failure(error);
       }
    }];

}
+ (void)patchWithUrlPath:(NSString *)urlString
             params:(NSDictionary *)params
            success:(void (^)(id result))success
            failure:(void (^)(NSError *error))failure {
    //获取完整的url路径
    NSString *Newstring = [NSString stringWithFormat:@"%@%@",ServerConfig.base_url,urlString];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *devToken = [userDefaults stringForKey:@"deviceToken"];
    
    //初始化Manager
    AFHTTPSessionManager *manager = [AFAppDotNetAPIClient shareClient];
    //内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/javascript", nil];
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
 // ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    NSString *Version = @"v1";
    NSString *AccessKeyId = @"testid";
    NSString *SignatureMethod = @"HMAC-SHA1";
    NSString *Timestamp = [self gs_getCurrentTimeStringToMilliSecond];
    NSString *SignatureVersion = @"1.0";
    NSString *SignatureNonce = [self getUUIDInKeychain];//
    NSArray *array = @[Version,AccessKeyId,SignatureMethod,Timestamp,SignatureVersion,SignatureNonce];
    NSString *signatureText = [array componentsJoinedByString:@"\n"];
    NSString *accessKeySecret = SecretKey;
//    NSString *signature = [self sha1_base64:signatureStr];
        NSString *signature = [self Base_HmacSha1:accessKeySecret data:signatureText];

//    signatureText
    //新增请求头参数
//    [manager requestSerializer setValue:@"text/html; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:devToken forHTTPHeaderField:@"X-Access-Token"];
    [manager.requestSerializer setValue:SignatureNonce forHTTPHeaderField:@"X-Request-ID"];

    [manager.requestSerializer setValue:Version forHTTPHeaderField:@"Version"];
    [manager.requestSerializer setValue:AccessKeyId forHTTPHeaderField:@"AccessKeyId"];
    [manager.requestSerializer setValue:SignatureMethod forHTTPHeaderField:@"SignatureMethod"];
    [manager.requestSerializer setValue:Timestamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:SignatureVersion forHTTPHeaderField:@"SignatureVersion"];
    [manager.requestSerializer setValue:SignatureNonce forHTTPHeaderField:@"SignatureNonce"];
    [manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];

   
    NSLog(@"---请求头%@",manager.requestSerializer.HTTPRequestHeaders);
//    [manager.requestSerializer requestWithMethod:@"POST" URLString:Newstring parameters:params error:nil];

    
//    [manager GET:Newstring parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //请求成功，解析数据
//        if(success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //请求失败
//       if(failure != nil) {
//           failure(error);
//       }
//    }];
    [manager PATCH:Newstring parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，解析数据
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
       if(failure != nil) {
           failure(error);
       }
    }];

}
//MD5加密
+(NSString *) md5:(NSString *) input {
    
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}
+ (NSString *) md5_base64:(NSString *) input {

    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    base64 = [GTMBase64 encodeData:base64];
    
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}
+ (NSString*) sha1:(NSString *) input {
    
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];

    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
+ (NSString *) sha1_base64:(NSString *) input {

    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    base64 = [GTMBase64 encodeData:base64];
    
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;

}
+ (NSString *)gs_getCurrentTimeStringToMilliSecond {

    double currentTime =  [[NSDate date] timeIntervalSince1970]*1000;

    NSString *strTime = [NSString stringWithFormat:@"%.0f",currentTime];

    return strTime;

}
+(NSString *)Base_HmacSha1:(NSString *)key data:(NSString *)data{
     const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
     const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
      //Sha256:
      // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
      //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
 
      //sha1
     unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
     CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

     NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                           length:sizeof(cHMAC)];

     //将加密结果进行一次BASE64编码。
     NSString *hash = [HMAC base64EncodedStringWithOptions:0];
     return hash;
 }
+ (NSString *)getUUIDInKeychain {

        // 生成UUID
        CFUUIDRef puuid = CFUUIDCreate(nil);
        CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
        NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
    
    return result;
}

@end
