//
//  AFAppDotNetAPIClient.m
//  volunteers
//
//  Created by NJUser on 2021/9/27.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

static AFHTTPSessionManager *manager;

@implementation AFAppDotNetAPIClient

+(AFHTTPSessionManager *)shareClient{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    return manager;
}
@end
