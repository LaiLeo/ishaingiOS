//
//  ServerConfig.h
//  volunteers
//
//  Created by NJUser on 2021/9/27.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#define isDevelpoment  0   //0 正式环境 1开发环境和测试环境
#define TEST 1 //1测试  0开发
NS_ASSUME_NONNULL_BEGIN

@interface ServerConfig : NSObject
@property (class, nonatomic, readonly) NSString *base_url;
@property (class, nonatomic, readonly) NSString *rc_cloud_appkey;
@property (class, nonatomic, readonly) NSString *ngx_point;
@end

NS_ASSUME_NONNULL_END
