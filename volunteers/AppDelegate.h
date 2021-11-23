//
//  AppDelegate.h
//  volunteers
//
//  Created by jauyou on 2015/1/15.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define APP_VERSION_LESS_THAN(sys_v,v)                 ([sys_v compare:v options:NSNumericSearch] == NSOrderedAscending)


+ (UIImage *)resizeImageToSize:(int)targetSize sourceImage:(UIImage *)source;
+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

@property (strong, nonatomic) UIWindow *window;
@property MainTabBarViewController *mainTabBarViewController;
@property NSArray *npo;
@property NSArray *donation_npo;
@property NSArray *event;
@property NSArray *subscribe_npo;
@property NSDictionary *user;
@property NSArray *focused_event;
@property NSArray *registered_event;

@end

