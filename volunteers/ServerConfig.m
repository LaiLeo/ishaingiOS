//
//  ServerConfig.m
//  volunteers
//
//  Created by NJUser on 2021/9/27.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import "ServerConfig.h"

@implementation ServerConfig
+ (NSString *)base_url {
    static NSString *url_string = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (isDevelpoment) {
            
                url_string = @"http://10.57.52.8.8100/";
    
        } else {
//                url_string = @"http://isharing.fihcloud.com/";
                url_string = @"https://stage-isharing.fihcloud.com/";

        }
    });
    return url_string;
}
@end
