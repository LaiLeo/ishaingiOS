//
//  EnterpriseVolunteerEventViewController.m
//  volunteers
//
//  Created by Pichu Chen on 平成28/9/13.
//  Copyright © 平成28年 taiwanmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EnterpriseVolunteerEventViewController.h"


#import <CoreLocation/CoreLocation.h>
#import <MBProgressHUD.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "AutoCompleteTableViewCell.h"
#import "EventDetailViewController.h"
#import "EventViewController.h"
#import "NpoDetailViewController.h"
#import "UserProfileViewController.h"
#import "VolunteerEventCollectionViewCell.h"
#import "VolunteerEventViewController.h"
#import "VolunteerNpoCollectionViewCell.h"
#import "WilloAPIV2.h"
#import "UIView+Toast.h"

@implementation EnterpriseVolunteerEventViewController
{
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.userIcon.userInteractionEnabled = YES;
    self.userIcon.hidden = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *expiresIn = [userDefaults stringForKey:@"expiresIn"];
//    if (expiresIn != nil) {
////        [self.view makeToast:@"正在開發中" duration:2.0 position:@"CSToastPositionCenter"];
//        self.userIcon.userInteractionEnabled = NO;
//        self.userIcon.hidden = YES;
//    }
}
- (void)viewDidLoad{
    super.isEnterprise = YES;
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenDetail) name:@"fubonPreson" object:nil];
}
//-(void)hiddenDetail{
//    self.userIcon.hidden = YES;
//}

- (void) viewDidAppear:(BOOL)animated{
    NSLog(@"EnterpriseVolunteerEventViewController::viewDidAppear");
    [super viewDidAppear:animated];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此專區僅供企業員工報名，\n欲報名一般志工活動請點選\n「志工訊息」" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
    [alert show];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
