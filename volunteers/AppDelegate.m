//
//  AppDelegate.m
//  volunteers
//
//  Created by jauyou on 2015/1/15.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import "AppDelegate.h"
#import "WilloAPIV2.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    MainTabBarViewController *mainTabBarViewController;
    NSArray *npo;
    NSArray *donation_npo;
    NSArray *event;
    NSArray *subscribe_npo;
    NSDictionary *user;
    NSArray *focused_event;
    NSArray *registered_event;
}
@synthesize mainTabBarViewController;
@synthesize npo;
@synthesize donation_npo;
@synthesize event;
@synthesize subscribe_npo;
@synthesize user;
@synthesize focused_event;
@synthesize registered_event;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *devToken = (NSString *)[userDefaults objectForKey:@"deviceToken"];
    
    if ([devToken length] == 0) {
        NSString *token = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString: @"<" withString: @""]
                            stringByReplacingOccurrencesOfString: @">" withString: @""]
                           stringByReplacingOccurrencesOfString: @" " withString: @""];
        // [self registDeviceToken:token];
        [userDefaults setObject:token forKey:@"deviceToken"];
        [userDefaults synchronize];
        
        [WilloAPIV2 registDevice:token success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == 201) {

            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"My Error: %@", operation.responseString);
            NSLog(@"Error: %@", error);
            
            if (operation.error.code == -1009 || operation.error.code == -1004) {
                // 沒有網路
            } else if([operation.response statusCode] == 400) {
                // 註冊失敗
            }
        }];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *notificationId = [userInfo objectForKey:@"id"];
    NSDictionary *parameters = @{@"id": notificationId};
    
    [WilloAPIV2 recieveNotification:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            ;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"My Error: %@", operation.responseString);
        NSLog(@"Error: %@", error);
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知更新"
                                                            message:@"沒有網路"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }];
    
    NSLog(@"userInfo: %@", userInfo);
    if( [[userInfo objectForKey:@"page_type"] isEqualToString:@"general_volunteer_list"]){
        [mainTabBarViewController showGeneralVolunteerList];
        return;
    }else if( [[userInfo objectForKey:@"page_type"] isEqualToString:@"enterprise_volunteer_list"]){
        [mainTabBarViewController showEnterpriseVolunteerList];
        return;
    }else if( [[userInfo objectForKey:@"page_type"] isEqualToString:@"item_list"]){
        [mainTabBarViewController showItemList];
        return;
    }else if( [[userInfo objectForKey:@"page_type"] isEqualToString:@"5180_list"]){
        [mainTabBarViewController show5180List];
        return;
    }else if( [[userInfo objectForKey:@"page_type"] isEqualToString:@"5180_detail"]){
        int npoId = [[userInfo objectForKey:@"donation_npo_id"] intValue];
        for (NSMutableDictionary *item in donation_npo) {
            if([[item valueForKey:@"id"] intValue] == npoId)
            {
                
                [mainTabBarViewController show5180EventDetail:npoId Event:item];
                return;
            }
        }
        
    }
    
    
    int eventId = [[userInfo objectForKey:@"event_id"] intValue];
    NSLog(@"got event ID: %d", eventId);
    
    if (eventId != 0) {
        NSMutableDictionary *eventDictionary;
    
        for (NSMutableDictionary *item in event) {
            if([[item valueForKey:@"id"] intValue] == eventId)
            {
                eventDictionary = item;
                break;
            }
        }
        [mainTabBarViewController showEventDetail:eventId Event:eventDictionary];
    }
    
    
}



- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

+ (UIImage *)resizeImageToSize:(int)targetSize sourceImage:(UIImage *)source
{
    float width = source.size.width;
    float height = source.size.height;
    
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth;
    CGFloat scaledHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (width > targetSize || height > targetSize) {
        
        CGFloat widthFactor = targetSize / width;
        CGFloat heightFactor = targetSize / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // make image center aligned
        
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (scaledHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (scaledWidth - scaledWidth) * 0.5;
        }
        CGSize resize;
        resize.width = scaledWidth;
        resize.height = scaledHeight;
        UIGraphicsBeginImageContext(resize);
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width  = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        [source drawInRect:thumbnailRect];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if(newImage == nil)
            NSLog(@"could not scale image");
        
        return newImage ;
        
    } else {
        return source;
    }
}


+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}


@end
