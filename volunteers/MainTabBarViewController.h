//
//  MainTabBarViewController.h
//  volunteers
//
//  Created by jauyou on 2015/1/27.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarViewController : UITabBarController<UIAlertViewDelegate>
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define APP_VERSION_LESS_THAN(sys_v,v)                 ([sys_v compare:v options:NSNumericSearch] == NSOrderedAscending)
@property(nonatomic,assign)NSInteger typeFu;

- (void)showEventDetail:(int)eid Event:(NSMutableDictionary *)item;
- (void)show5180EventDetail:(int)eid Event:(NSMutableDictionary *)item;
- (void)showGeneralVolunteerList;
- (void)showEnterpriseVolunteerList;
- (void)showItemList;
- (void)show5180List;
@end
