//
//  UserProfileViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/3.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "EventViewController.h"
#import "NpoViewController.h"
#import "SkillsHabitsViewController.h"
#import "UserProfileViewController.h"
#import "WilloAPIV2.h"
#import "volunteers-Swift.h"
#import "UserProfileData.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController
{
    NSMutableArray *events;
    NSMutableArray *npos;
    NSString *title;
    NSDictionary *profile;
    BOOL isEditable;
}
@synthesize profile;
@synthesize isEditable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.scrollWidth.constant = screenWidth;
    
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(44,CGRectGetMaxY(self.userIcon.frame)+10 , 300, 22)];
    userName.textColor = [UIColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1.0];
    self.userName = userName;
    [self.ScrollView addSubview:userName];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"UserProfileViewController::viewDidAppear");
   NSDictionary *data = [UserProfileData myProfile];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([[profile valueForKey:@"id" ] intValue] == [[appDelegate.user valueForKey:@"id"] intValue])
    {
        profile = appDelegate.user;
    }
//    self.aboutMe.text = [profile valueForKey:@"about_me"];
    self.aboutMe.text = [data valueForKey:@"about_me"];

    CGSize sizeThatShouldFitTheContent = [self.aboutMe sizeThatFits:self.aboutMe.frame.size];
    
    self.descriptionHeight.constant = sizeThatShouldFitTheContent.height;
    
//    self.scrollHeight.constant = 630 - 200 - 80 + self.scrollWidth.constant / 2 + sizeThatShouldFitTheContent.height;
    // WTF, who knows what "670", "200", "80" means!!!
    self.scrollHeight.constant = 670 - 200 - 80 + self.scrollWidth.constant / 2 + sizeThatShouldFitTheContent.height;
    
    NSString *urlLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], [profile valueForKey:@"icon"]];
    NSString *fileName = [profile valueForKey:@"icon"];
    NSString *strUrl = [fileName stringByReplacingOccurrencesOfString:@"/uploads" withString:@"resources"];

    NSString *urlLick2 = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getImageUrlName], strUrl];

    [self.spinner startAnimating];
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:urlLick2]
                     placeholderImage:[UIImage imageNamed:fileName]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                [self.spinner stopAnimating];
                            }];
    
//    self.name.text = [profile valueForKey:@"name"];
//    self.email.text = [profile valueForKey:@"email"];
//    self.name.text = [data valueForKey:@"username"];
    self.userName.text = [data valueForKey:@"username"];
//    int score = [[profile valueForKey:@"score"] intValue];
    int score = [[data valueForKey:@"score"]intValue];

    if (score == 0) {
        [self.userScore setImage:[UIImage imageNamed:@"score0"]];
    } else if (score < 100 / 6) {
        [self.userScore setImage:[UIImage imageNamed:@"score1"]];
    } else if (score < 100 / 6 * 2) {
        [self.userScore setImage:[UIImage imageNamed:@"score2"]];
    } else if (score < 100 / 6 * 3) {
        [self.userScore setImage:[UIImage imageNamed:@"score3"]];
    } else if (score < 100 / 6 * 4) {
        [self.userScore setImage:[UIImage imageNamed:@"score4"]];
    } else if (score < 100 / 6 * 5) {
        [self.userScore setImage:[UIImage imageNamed:@"score5"]];
    } else if (score == 100) {
        [self.userScore setImage:[UIImage imageNamed:@"score6"]];
    }
    
    if (isEditable) {
        self.editButton.hidden = false;
        self.registedEventButton.hidden = false;
        self.joinedEventButton.hidden = false;
        self.followedEventButton.hidden = false;
        self.registedResourceButton.hidden = false;
        self.advanceSearchButton.hidden = false;
    } else {
        self.editButton.hidden = true;
        self.registedEventButton.hidden = true;
        self.joinedEventButton.hidden = true;
        self.followedEventButton.hidden = true;
        self.registedResourceButton.hidden = true;
        self.advanceSearchButton.hidden = true;
    }
    
//    self.totalHour.text = [NSString stringWithFormat:@"參加時數\n %.1f", [[profile valueForKey:@"event_hour"] floatValue]];
    self.totalHour.text = [NSString stringWithFormat:@"參加時數\n %.1f", [[data valueForKey:@"event_hour"] floatValue]];

//    self.totalEvent.text = [NSString stringWithFormat:@"參加活動\n %d", [[profile valueForKey:@"event_num"] intValue]];
    self.totalEvent.text = [NSString stringWithFormat:@"參加活動\n %d", [[data valueForKey:@"eventNum"] intValue]];

//    self.volunteerRanking.text = [NSString stringWithFormat:@"志工排名\n %d", [[profile valueForKey:@"ranking"] intValue]];
    self.volunteerRanking.text = [NSString stringWithFormat:@"志工排名\n %d", [[data valueForKey:@"ranking"] intValue]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

    
- (IBAction)showServiceArea:(id)sender {
    NSLog(@"UserProfileViewController::showServiceArea");
    title = @"可服務區域";
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    events = [[NSMutableArray alloc] init];
//    for(NSMutableDictionary *item in appDelegate.registered_event)
//    {
//        if ([[item valueForKey:@"isJoined"] boolValue] && [[[item valueForKey:@"registered_event"] valueForKey:@"is_volunteer_event"] boolValue]) {
//            [events addObject:[item valueForKey:@"registered_event"]];
//        }
//    }
    [self performSegueWithIdentifier:@"segueUserProfileToSkillHabitSetSkill" sender:self];
}
    
- (IBAction)showServiceItem:(id)sender {
    NSLog(@"UserProfileViewController::showServiceItem");
    title = @"可服務項目";
    [self performSegueWithIdentifier:@"segueUserProfileToSkillHabitSetHabit" sender:self];
    
}
    
- (IBAction)showFastJoin:(id)sender {
    NSLog(@"UserProfileViewController::showFastJoin");
    title = @"快速報到";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    events = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    for(NSMutableDictionary *item in appDelegate.registered_event)
    {
     
        NSMutableDictionary *registered_event = [item valueForKey:@"registered_event"];
        NSDate *closeDate = [dateFormat dateFromString:[registered_event valueForKey:@"close_date"]];
        
        // 未截止且未報到之已報名活動
        Boolean notOverDeadline = [self daysBetweenDate:[NSDate date] andDate:closeDate] >= 0;
        Boolean notJoin = ![[item valueForKey:@"isJoined"] boolValue];
        
        if ([[registered_event valueForKey:@"is_volunteer_event"] boolValue] && notOverDeadline && notJoin) {
            [events addObject:[item valueForKey:@"registered_event"]];
        }
    }
    [self performSegueWithIdentifier:@"segueUserProfileToEvent" sender:self];
}

- (IBAction)showUnregistEvent:(id)sender {
    NSLog(@"UserProfileViewController::showUnregistEvent");
    title = @"我未報到的活動";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    events = [[NSMutableArray alloc] init];
    
    for(NSMutableDictionary *item in appDelegate.registered_event)
    {
        if (![[item valueForKey:@"isJoined"] boolValue] && [[[item valueForKey:@"registered_event"] valueForKey:@"is_volunteer_event"] boolValue]) {
            [events addObject:[item valueForKey:@"registered_event"]];
        }
    }
    [self performSegueWithIdentifier:@"segueUserProfileToEvent" sender:self];
}

- (IBAction)showJoinedEvent:(id)sender {
    NSLog(@"UserProfileViewController::showJoinedEvent");
    title = @"我參加過的活動";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    events = [[NSMutableArray alloc] init];
    
    for(NSMutableDictionary *item in appDelegate.registered_event)
    {
        if ([[item valueForKey:@"isJoined"] boolValue] && [[[item valueForKey:@"registered_event"] valueForKey:@"is_volunteer_event"] boolValue]) {
            [events addObject:[item valueForKey:@"registered_event"]];
        }
    }
    [self performSegueWithIdentifier:@"segueUserProfileToEvent" sender:self];
}

- (IBAction)showFollowedEvent:(id)sender {
    NSLog(@"UserProfileViewController::showFollowedEvent");
    title = @"我所關注的活動";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    events = [[NSMutableArray alloc] init];
    
    for(NSMutableDictionary *item in appDelegate.focused_event)
    {
        if ([[[item valueForKey:@"focused_event"] valueForKey:@"is_volunteer_event"] boolValue]) {
            [events addObject:[item valueForKey:@"focused_event"]];
        }
    }
    [self performSegueWithIdentifier:@"segueUserProfileToEvent" sender:self];
}

- (IBAction)showAllResource:(id)sender {
    NSLog(@"UserProfileViewController::showAllResource");
    title = @"我捐過的物資";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    events = [[NSMutableArray alloc] init];
    
    for(NSMutableDictionary *item in appDelegate.registered_event)
    {
        if (![[[item valueForKey:@"registered_event"] valueForKey:@"is_volunteer_event"] boolValue]) {
            [events addObject:[item valueForKey:@"registered_event"]];
        }
    }
    [self performSegueWithIdentifier:@"segueUserProfileToEvent" sender:self];
}

- (IBAction)showFollowedResource:(id)sender {
    NSLog(@"UserProfileViewController::showFollowedResource");
    title = @"我所關注的物資缺";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    events = [[NSMutableArray alloc] init];
    
    for(NSMutableDictionary *item in appDelegate.focused_event)
    {
        if (![[[item valueForKey:@"focused_event"] valueForKey:@"is_volunteer_event"] boolValue]) {
            [events addObject:[item valueForKey:@"focused_event"]];
        }
    }
    [self performSegueWithIdentifier:@"segueUserProfileToEvent" sender:self];
}

- (IBAction)showFollowedNpo:(id)sender {
    NSLog(@"UserProfileViewController::showFollowedNpo");
    title = @"我所關注的公益品牌";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    npos = [NSMutableArray arrayWithArray:appDelegate.subscribe_npo];
    [self performSegueWithIdentifier:@"segueUserProfileToNpo" sender:self];
}

- (IBAction)showScoreMsg:(id)sender {
    NSLog(@"UserProfileViewController::showScoreMsg");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"訊息"
                                                    message:@"請踴躍參與活動，集點數為彩球上色喔"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


- (IBAction)showAdvanceSearch:(id)sender {
    NSLog(@"UserProfileViewController::showAdvanceSearch");
    NSLog(@"showAdvanceSearch");
    
    [self performSegueWithIdentifier:@"segueUserProfileToAdvanceSearch" sender:self];
    
}
    
- (IBAction)showLicense:(id)sender {
    NSLog(@"UserProfileViewController::showLicense");
    NSLog(@"showLicense");
    
    [self performSegueWithIdentifier:@"segueUserProfileToUserPhoto" sender:self];
}

-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    
    NSTimeInterval interval = [fromDateTime timeIntervalSinceDate:toDateTime];
    return -interval;
//    NSDate *fromDate;
//    NSDate *toDate;
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
//                 interval:NULL forDate:fromDateTime];
//    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
//                 interval:NULL forDate:toDateTime];
//    
//    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
//                                               fromDate:fromDate toDate:toDate options:0];
//    
//    return [difference day];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueUserProfileToSkillHabitSetSkill"]) {
        // 可服務區域
        SkillsHabitsViewController *destViewController = segue.destinationViewController;
        destViewController.isSkill = true;
        destViewController.title = title;
//        destViewController.selectable = true;
//        destViewController.maxSelectableItem = 3;
//        destViewController.allItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countryMapping" ofType:@"plist"] ];
//        destViewController.listener = ^(NSArray* allItems, NSArray* selectedItems){
//            
//        };
        destViewController.skillHabitString = [profile valueForKey:@"interest"];
    } else if ([segue.identifier isEqualToString:@"segueUserProfileToSkillHabitSetHabit"]) {
        SkillsHabitsViewController *destViewController = segue.destinationViewController;
        destViewController.isSkill = false;
        destViewController.title = title;
        destViewController.allItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"serviceItemType" ofType:@"plist"] ];
        destViewController.skillHabitString = [profile valueForKey:@"skills_description"];
    } else if ([segue.identifier isEqualToString:@"segueUserProfileToEvent"]) {
        EventViewController *destViewController = segue.destinationViewController;
        destViewController.viewControllerTitle = title;
        destViewController.events = events;
    } else if ([segue.identifier isEqualToString:@"segueUserProfileToNpo"]) {
        NpoViewController *destViewController = segue.destinationViewController;
        destViewController.viewControllerTitle = title;
        destViewController.npos = npos;
    } else if ([segue.identifier isEqualToString:@"segueUserProfileToAdvanceSearch"]){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UserProfileViewController *destViewController = segue.destinationViewController;
        destViewController.profile = appDelegate.user;
        destViewController.isEditable = true;
    } else if ([segue.identifier isEqualToString:@"segueUserProfileToUserPhoto"]) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UserPhotoViewController *destViewController = segue.destinationViewController;
        destViewController.images = [appDelegate.user valueForKey:@"images"];
        destViewController.title = @"專業證照";
//        destViewController.profile = appDelegate.user;
        NSLog(@"user: %@", appDelegate.user);
//        destViewController.isEditable = true;
        
        
    }
}
@end
