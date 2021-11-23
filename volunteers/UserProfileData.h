//
//  UserProfileData.h
//  volunteers
//
//  Created by NJUser on 2021/10/19.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserProfileData : NSObject
+ (void)saveProfile:(NSDictionary *)user;
+ (NSDictionary *)myProfile;
@end

NS_ASSUME_NONNULL_END
