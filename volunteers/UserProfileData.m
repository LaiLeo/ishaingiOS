//
//  UserProfileData.m
//  volunteers
//
//  Created by NJUser on 2021/10/19.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import "UserProfileData.h"

@implementation UserProfileData
+ (void)saveProfile:(NSDictionary *)user{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"id"]] forKey:@"id"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"username"]] forKey:@"username"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"uid"]] forKey:@"uid"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"aboutMe"]] forKey:@"aboutMe"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"skillsDescription"]] forKey:@"skillsDescription"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"interest"]] forKey:@"interest"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"isStaff"]] forKey:@"isStaff"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"isNpo"]] forKey:@"isNpo"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"npoid"]] forKey:@"npoid"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"score"]] forKey:@"score"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"ranking"]] forKey:@"ranking"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"eventNum"]] forKey:@"eventNum"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"eventEnterpriseHour"]] forKey:@"eventEnterpriseHour"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"eventGeneralHour"]] forKey:@"eventGeneralHour"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"Icon"]] forKey:@"Icon"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"isFubon"]] forKey:@"isFubon"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",user[@"isTwm"]] forKey:@"isTwm"];

    [userDefaults synchronize];
}
+ (NSDictionary *)myProfile{
    NSMutableDictionary *profile = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [profile setObject:[userDefaults objectForKey: @"id"] forKey:@"id"];
    [profile setObject:[userDefaults objectForKey: @"username"] forKey:@"username"];
    [profile setObject:[userDefaults objectForKey: @"uid"] forKey:@"uid"];
    [profile setObject:[userDefaults objectForKey: @"aboutMe"] forKey:@"aboutMe"];
    [profile setObject:[userDefaults objectForKey: @"skillsDescription"] forKey:@"skillsDescription"];
    [profile setObject:[userDefaults objectForKey: @"interest"] forKey:@"interest"];
    [profile setObject:[userDefaults objectForKey: @"isStaff"] forKey:@"isStaff"];
    [profile setObject:[userDefaults objectForKey: @"isNpo"] forKey:@"isNpo"];
    [profile setObject:[userDefaults objectForKey: @"npoid"] forKey:@"npoid"];
    [profile setObject:[userDefaults objectForKey: @"score"] forKey:@"score"];
    [profile setObject:[userDefaults objectForKey: @"ranking"] forKey:@"ranking"];
    [profile setObject:[userDefaults objectForKey: @"eventNum"] forKey:@"eventNum"];
    [profile setObject:[userDefaults objectForKey: @"eventEnterpriseHour"] forKey:@"eventEnterpriseHour"];
    [profile setObject:[userDefaults objectForKey: @"eventGeneralHour"] forKey:@"eventGeneralHour"];
    [profile setObject:[userDefaults objectForKey: @"Icon"] forKey:@"Icon"];
    [profile setObject:[userDefaults objectForKey: @"isFubon"] forKey:@"isFubon"];
    [profile setObject:[userDefaults objectForKey: @"isTwm"] forKey:@"isTwm"];

    return profile;
}
@end
