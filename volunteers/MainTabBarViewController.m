//
//  MainTabBarViewController.m
//  volunteers
//
//  Created by jauyou on 2015/1/27.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <JSONKit.h>
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "EventDetailViewController.h"
#import "DonateNpoDetailViewController.h"
#import "MainTabBarViewController.h"
#import "TabBarUpdateProtocol.h"
#import "WilloAPIV2.h"
#import "LoginServer.h"
#import "UIView+Toast.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController
{
    int eventId;
    NSMutableDictionary *event;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.mainTabBarViewController = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    if (token != nil) {
        [WilloAPIV2 checkTokenValidate:^void(){
            UIViewController *viewController = self.selectedViewController;
            [(UIViewController<TabBarUpdateProtocol> *)viewController reloadData];
//            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//                // Do something...
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                });
//            });
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    } else {
        [WilloAPIV2 getDump:^void(){
            UIViewController *viewController = self.selectedViewController;
            [(UIViewController<TabBarUpdateProtocol> *)viewController reloadData];
//            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//                // Do something...
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                });
//            });
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    }
    
    [self getAppVersion];
}

BOOL showAnimationGuard = false;

- (void)showFullAnimation {
    NSLog(@"start showFullAnimation");
    if(showAnimationGuard){
        NSLog(@"skip start showFullAnimation");
        return;
    }else{
        showAnimationGuard = true;
    }
    [self performSegueWithIdentifier:@"startAnimation" sender:self];
    __block int repeatTime = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"Tick %d", repeatTime);
        if(repeatTime > 10){
            [timer invalidate];
        }
        NSString *filename = [[NSString alloc] initWithFormat:@"start_animation_%02d", repeatTime + 1];
        UIImage * image = [UIImage imageNamed: filename];
//        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        
        UIImageView *iv = [self.presentedViewController.view viewWithTag:100];
        if([iv isKindOfClass:UIImageView.class]) {
            [iv setImage:image];
        }
        
//        [self.presentedViewController.view addSubview:iv];
        repeatTime = repeatTime + 1;
    }];
    // since data fetching takes up to 20 sec,
    // having a 5 sec animation is not so bad
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
            NSLog(@"end showFullAnimation");
        }];
    });
//    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//    AppDelegate *md = (AppDelegate*)[[UIApplication sharedApplication] delegate];
////
////    if (!window)
////        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//    UIView * view = [[UIView alloc] initWithFrame:window.frame];
//
////    [[[window subviews] objectAtIndex:0] addSubview:view];
////    md.tab.v
//    [self.view addSubview:view];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self showFullAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getAppVersion
{
    
    [[LoginServer shareInstance]getVersionWithSuccess:^(NSDictionary * _Nonnull dic) {
        
        
        NSString *appVersion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        NSArray *results = dic[@"results"];
        for (NSDictionary *item in results) {
            NSString *iosVersion = [NSString stringWithFormat:@"%@",item[@"iosVersion"]];
//            NSString *itunesVersion = @"5.1.5";
            NSString *questionnaireUrl = [NSString stringWithFormat:@"%@",item[@"questionnaireUrl"]];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:questionnaireUrl forKey:@"questionnaireUrl"];
            [userDefaults synchronize];
            
                if (item[@"forcedUpgrade"] && APP_VERSION_LESS_THAN(appVersion,iosVersion)) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有更新程式" message:@"微樂志工已釋出最新版本哦，為提供您更好的服務，請點選下方【取得最新版本】，謝謝。" delegate:self cancelButtonTitle:@"取得最新版本" otherButtonTitles:nil];
                    alert.tag = 1;
                    [alert show];
                    }
        }

       

        } failure:^(NSError * _Nonnull error) {
            [self.view makeToast:@"failure" duration:2.0 position:@"CSToastPositionCenter"];

        }];
//    NSString *request_path = @"https://itunes.apple.com/lookup?id=823341128";
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
//    [manager GET:request_path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        if (operation.response.statusCode == 200) {
//
//
//            NSString *response = operation.responseString;
//            NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
//
//            JSONDecoder* decoder = [[JSONDecoder alloc]
//                                        initWithParseOptions:JKParseOptionLooseUnicode];
//            NSMutableArray* json = [decoder mutableObjectWithData:jsonData];
//
//            //NSCalendar* cal = [NSCalendar currentCalendar];
//
//            NSMutableArray *results = [json valueForKey:@"results"];
//            long resultCount = [[json valueForKey:@"resultCount"] longValue];
//            if (resultCount == 0) {
//                return;
//            }
//            NSString *itunesVersion = [results valueForKey:@"version"][0];
//
//
//            NSString *appVersion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
//
//            return;
//
//            if (APP_VERSION_LESS_THAN(appVersion,itunesVersion)) {
//                NSString *versionUpdate = NSLocalizedString(@"versionUpdate", @"Version Update");
//                NSString *versionUpdateText = NSLocalizedString(@"versionUpdateText", "Please update new version from App Store.");
//
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:versionUpdate message:versionUpdateText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                alert.tag = 1;
//                [alert show];
//            }
//
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error Code: %ld\nError: %@", (long)operation.response.statusCode, error);
//
//        if (operation.response.statusCode == 401) {
//            NSString *string = [[NSString alloc] initWithData:operation.responseObject encoding:NSUTF8StringEncoding];
//            NSString *loginFail = NSLocalizedString(@"loginFail", @"login fail");
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:loginFail message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//
//            [alert show];
//            return;
//        }
//    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        NSString *url = @"https://itunes.apple.com/us/app/wei-le-zhi-gong/id823341128?mt=8&uo=4";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}

- (void)showEventDetail:(int)eid Event:(NSMutableDictionary *)item
{
    eventId = eid;
    event = item;
    [self performSegueWithIdentifier:@"segueMainTabBarToEventDetail" sender:self];
}

- (void)show5180EventDetail:(int)eid Event:(NSMutableDictionary *)item {
    eventId = eid;
    event = item;
    [self performSegueWithIdentifier:@"segueMainTabBarTo5180EventDetail" sender:self];
}
- (void)showGeneralVolunteerList {
    [self.tabBarController setSelectedIndex:0];
    [self performSegueWithIdentifier:@"segueMainTabBarToGeneralVolunteerList" sender:self];
}
- (void)showEnterpriseVolunteerList {
    [self.tabBarController setSelectedIndex:1];
    [self performSegueWithIdentifier:@"segueMainTabBarToEnterpriseVolunteerList" sender:self];
    
}
- (void)showItemList {
    [self.tabBarController setSelectedIndex:2];
    [self performSegueWithIdentifier:@"segueMainTabBarToItemList" sender:self];
    
}
- (void)show5180List {
    [self.tabBarController setSelectedIndex:3];
    [self performSegueWithIdentifier:@"segueMainTabBarTo5180List" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueMainTabBarToEventDetail"]) {
        EventDetailViewController *destViewController = segue.destinationViewController;
        destViewController.eventId = eventId;
        destViewController.event = event;
    }else if ([segue.identifier isEqualToString:@"segueMainTabBarTo5180EventDetail"]) {
        DonateNpoDetailViewController *destViewController = segue.destinationViewController;
        destViewController.donateNpo = event;
    }
}

@end
