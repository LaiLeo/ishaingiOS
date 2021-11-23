//
//  AFAppDotNetAPIClient.h
//  volunteers
//
//  Created by NJUser on 2021/9/27.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFAppDotNetAPIClient : AFHTTPSessionManager
+(AFHTTPSessionManager *)shareClient;
@end

NS_ASSUME_NONNULL_END
