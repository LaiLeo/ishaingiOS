//
//  ResourceEventViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/3.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MBProgressHUD.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "AutoCompleteTableViewCell.h"
#import "EventDetailViewController.h"
#import "EventViewController.h"
#import "NpoDetailViewController.h"
#import "ResourceEventViewController.h"
#import "UserProfileViewController.h"
#import "VolunteerEventCollectionViewCell.h"
#import "VolunteerNpoCollectionViewCell.h"
#import "WilloAPIV2.h"
#import "UIView+Toast.h"

@interface ResourceEventViewController ()

@end

@implementation ResourceEventViewController
{
    NSMutableArray *volunteerEvents;
    NSMutableArray *volunteerNpos;
    NSMutableArray *focusEvents;
    NSMutableArray *registEvents;
    NSMutableArray *subscribeNpos;
    NSMutableArray *searchResults;
    
    NSMutableArray *autoCompleteArray;
    
    UIRefreshControl *eventRefreshControl;
    UIRefreshControl *npoRefreshControl;
    
    CLLocationManager *locationManager;
    CLLocation *myLocation;
    bool isVolunteerEvent;
    bool isNearest;
    bool isNearFirst;
    bool isAdvancedSearch;
    
    NSArray *intervalPickerData;
    NSArray *locationPickerData;
    NSArray *fullStatusPickerData;

    
    NSString *title;
    NSMutableArray *events;
    
    NSArray *enableType;
    NSArray *allType;
    
    NSInteger rowInterval;
    NSInteger rowCity;
    NSInteger rowFullStatus;
}


NSInteger static const TAG_INTERVAL_PICKER = 1;
NSInteger static const TAG_LOCALCATION_PICKER = 2;
NSInteger static const TAG_FULL_STATUS_PICKER = 3;

NSInteger static const TAG_EVENT_COLLECTION = 1;
NSInteger static const TAG_NPO_COLLECTION = 2;

NSInteger static const TAG_INTERVAL_ALL    = 0;
NSInteger static const TAG_INTERVAL_URGENT = 1;
NSInteger static const TAG_INTERVAL_LONG   = 2;
NSInteger static const TAG_INTERVAL_SHORT  = 3;

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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    volunteerNpos = [NSMutableArray arrayWithArray:appDelegate.npo];
    focusEvents = [NSMutableArray arrayWithArray:appDelegate.focused_event];
    registEvents = [NSMutableArray arrayWithArray:appDelegate.registered_event];
    subscribeNpos = [NSMutableArray arrayWithArray:appDelegate.subscribe_npo];
    
    eventRefreshControl = [[UIRefreshControl alloc] init];
    [eventRefreshControl addTarget:self action:@selector(startRefresh:)
                  forControlEvents:UIControlEventValueChanged];
    [self.volunteerEventCollectionView addSubview:eventRefreshControl];
    self.volunteerEventCollectionView.alwaysBounceVertical = YES;
    
    npoRefreshControl = [[UIRefreshControl alloc] init];
    [npoRefreshControl addTarget:self action:@selector(startRefresh:)
                forControlEvents:UIControlEventValueChanged];
    [self.volunteerNpoCollectionView addSubview:npoRefreshControl];
    self.volunteerNpoCollectionView.alwaysBounceVertical = YES;
    
    isVolunteerEvent = true;
    isNearest = false;
    
    myLocation = nil;
    
    intervalPickerData = @[@"全部期間", @"緊急", @"長期", @"短期"];
    locationPickerData = @[@"全部地區",
                           @"台北市",
                           @"新北市",
                           @"基隆市",
                           @"桃園市",
                           @"新竹市",
                           @"新竹縣",
                           @"苗栗縣",
                           @"台中市",
                           @"彰化縣",
                           @"南投縣",
                           @"雲林縣",
                           @"嘉義市",
                           @"嘉義縣",
                           @"台南市",
                           @"高雄市",
                           @"屏東縣",
                           @"宜蘭縣",
                           @"花蓮縣",
                           @"台東縣",
                           @"澎湖縣",
                           @"金門縣",
                           @"連江縣",];
    fullStatusPickerData = @[@"不限額滿", @"已額滿", @"未額滿"];
    
//    enableType = [NSMutableArray arrayWithObjects:@"其他",@"食物",@"教材",@"日用品",@"電子產品",nil];
//    allType = [NSMutableArray arrayWithObjects:@"其他",@"食物",@"教材",@"日用品",@"電子產品",nil];
    enableType = [NSMutableArray arrayWithObjects:@"食物、保健",@"教材、文具",@"日用、餐廚、傢俱、寢飾",@"日家電、電子產品",@"休閒、運動、服飾",@"其他",nil];
    allType = [NSMutableArray arrayWithObjects:@"食物、保健",@"教材、文具",@"日用、餐廚、傢俱、寢飾",@"日家電、電子產品",@"休閒、運動、服飾",@"其他",nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenDetail) name:@"fubonPreson" object:nil];
}
//-(void)hiddenDetail{
//    self.userIcon.hidden = YES;
//}
- (void)viewDidAppear:(BOOL)animated {  
    [self reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [autoCompleteArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"resourceTableViewCell";
    
    AutoCompleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[AutoCompleteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.autoCompleteText.text = [autoCompleteArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchBar.text = autoCompleteArray[indexPath.row];
    self.autoCompleteTableView.hidden = true;
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case TAG_INTERVAL_PICKER:
            return intervalPickerData.count;
            break;
        case TAG_LOCALCATION_PICKER:
            return locationPickerData.count;
            break;
        case TAG_FULL_STATUS_PICKER:
            return fullStatusPickerData.count;
            break;
        default:
            break;
    }
    NSLog(@"error, unknown pickerView.tag: %ld", (long)pickerView.tag);
    return 0;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (pickerView.tag) {
        case TAG_INTERVAL_PICKER:
            return intervalPickerData[row];
            break;
        case TAG_LOCALCATION_PICKER:
            return locationPickerData[row];
            break;
        case TAG_FULL_STATUS_PICKER:
            return fullStatusPickerData[row];
            break;
        default:
            break;
    }
    return @"error: unknown tag";
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"didSelectRow");
    switch (pickerView.tag) {
        case TAG_INTERVAL_PICKER:
            rowInterval = row;
            break;
        case TAG_LOCALCATION_PICKER:
            rowCity = row;
            break;
        case TAG_FULL_STATUS_PICKER:
            rowFullStatus = row;
            break;
        default:
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat cellHeight = screenWidth * 96 / 320;
    return CGSizeMake(screenWidth, cellHeight);
}

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 1) {
        NSMutableArray *useArray;
        if ([self.searchBar.text length] != 0 || isAdvancedSearch) {
            useArray = searchResults;
        } else {
	//FIH-add for Active display and arrangement logic settings start
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//            NSMutableArray *tmp2 = [NSMutableArray arrayWithArray:volunteerEvents];
//            for (NSDictionary *model in tmp2) {
//                NSDate *closeDate = [dateFormat dateFromString:[model valueForKey:@"close_date"]];//报名截止日期
//                if ([self daysBetweenDate:[NSDate date] andDate:closeDate] < 0) {
//                    [volunteerEvents removeObject:model];
//                }
//            }
            //已额满的活动不显示
            NSMutableArray *tmp = [NSMutableArray arrayWithArray:volunteerEvents];
            for (NSDictionary *model in tmp) {
                NSDate *closeDate = [dateFormat dateFromString:[model valueForKey:@"close_date"]];//报名截止日期

                long voluteerNum = [[model valueForKey:@"required_volunteer_number"] integerValue] - [[model valueForKey:@"current_volunteer_number"] integerValue];
                if (voluteerNum == 0 && [self daysBetweenDate:[NSDate date] andDate:closeDate] < 0) {
                    [volunteerEvents removeObject:model];
                    }                              
            }
	//FIH-add for Active display and arrangement logic settings start
            useArray = volunteerEvents;
            
            
        }
        
        if (isNearest && myLocation == nil) {
            return 0;
        }else {
            return useArray.count;
        }
    } else if (collectionView.tag == 2) {
        NSMutableArray *useArray;
        if ([self.searchBar.text length] != 0) {
            useArray = searchResults;
        } else {
            useArray = volunteerNpos;
        }
        return useArray.count;
    } else {
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1) {
        NSMutableArray *useArray;
        if ([self.searchBar.text length] != 0 || isAdvancedSearch) {
            useArray = searchResults;
        } else {
            useArray = volunteerEvents;
        }
        VolunteerEventCollectionViewCell *myCell = [collectionView
                                                    dequeueReusableCellWithReuseIdentifier:@"ResourceEventCell"
                                                    forIndexPath:indexPath];
        
        long row = [indexPath row];
        
        myCell.viewController = self;
        
        NSMutableDictionary *eventEntity = (NSMutableDictionary *)useArray[row];
        
        myCell.eventId = [[eventEntity valueForKey:@"id"] intValue];
        
        myCell.title.text = [eventEntity valueForKey:@"subject"];
        
        NSString *urlLick = [NSString stringWithFormat:@"%@resources/%@", [WilloAPIV2 getImageUrlName], [eventEntity valueForKey:@"thumb_path"]];
        NSString *fileName = [[urlLick componentsSeparatedByString:@"/"] lastObject];
        
        myCell.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [myCell.spinner setCenter:CGPointMake(myCell.image.center.x, myCell.image.center.y)]; // I do this because I'm in landscape mode
        [myCell.image addSubview:myCell.spinner]; // spinner is not visible until started
        
        [myCell.spinner startAnimating];
        
        // Here we use the new provided setImageWithURL: method to load the web image
        [myCell.image sd_setImageWithURL:[NSURL URLWithString:urlLick]
                        placeholderImage:[UIImage imageNamed:fileName]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   if ([myCell.spinner isAnimating]) {
                                       [myCell.spinner stopAnimating];
                                   }
                               }];
        
        BOOL isUrgent = [[eventEntity valueForKey:@"is_urgent"] boolValue];
        if (isUrgent) {
            myCell.urgentIcon.hidden = false;
        } else {
            myCell.urgentIcon.hidden = true;
        }
        
        if (isNearest) {
            myCell.distance.hidden = false;
            if (myLocation == nil) {
                myCell.distance.text = @"定位中";
            } else {
                CLLocation *loc = [[CLLocation alloc] initWithLatitude:[[eventEntity valueForKey:@"lat"] floatValue] longitude:[[eventEntity valueForKey:@"lng"] floatValue]];
                CLLocationDistance distance = [loc distanceFromLocation:myLocation];
                if (distance / 1000 > 1) {
                    myCell.distance.text = [NSString stringWithFormat:@"距%.f公里", distance / 1000];
                } else {
                    myCell.distance.text = [NSString stringWithFormat:@"距%.f公尺", distance];
                }
                
            }
        } else {
            myCell.distance.hidden = true;
        }
        
        long voluteerNum = [[eventEntity valueForKey:@"required_volunteer_number"] integerValue] - [[eventEntity valueForKey:@"current_volunteer_number"] integerValue];
        myCell.volunteerCount.text = [NSString stringWithFormat:@"尚缺%ld名", voluteerNum];
        
        NSString *happen_date = [self translateTimeToLocaleZone:[eventEntity valueForKey:@"happen_date"]];
        NSString *close_date = [self translateTimeToLocaleZone:[eventEntity valueForKey:@"close_date"]];
        myCell.time.text = [NSString stringWithFormat:@"%@~%@", happen_date, close_date];
        
        NSString *address_city = [eventEntity valueForKey:@"address_city"];
        NSString *address = [eventEntity valueForKey:@"address"];
        myCell.location.text = [NSString stringWithFormat:@"%@%@", address_city, address];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *closeDate = [dateFormat dateFromString:[eventEntity valueForKey:@"close_date"]];
        NSDate *registDate = [dateFormat dateFromString:[eventEntity valueForKey:@"register_deadline_date"]];
        if ([self daysBetweenDate:[NSDate date] andDate:closeDate] < 0) {
            myCell.dateCount.text = @"活動結束";
        } else if ([self daysBetweenDate:[NSDate date] andDate:registDate] < 0) {
            myCell.dateCount.text = @"報名截止";
        } else {
            if([[eventEntity valueForKey:@"is_urgent"] boolValue] || [[eventEntity valueForKey:@"is_short"] boolValue]){
                myCell.dateCount.text = [NSString stringWithFormat:@"剩%ld日", (long)[self daysBetweenDate:[NSDate date] andDate:closeDate]/86400];
            } else {
                myCell.dateCount.text = @"長期招募";
            }
        }
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefault objectForKey:@"token"];
        if (token != nil) {
            myCell.followOrNotButton.hidden = false;
            myCell.followOrNotButton.tag = 0;
            [myCell.followOrNotButton setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
            for (NSMutableDictionary *item in focusEvents) {
                if ([[[item valueForKey:@"focused_event"] valueForKey:@"id"] intValue] == myCell.eventId) {
                    [myCell.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
                    myCell.followOrNotButton.tag = 1;
                    break;
                }
            }
            
            if (myCell.followOrNotButton.tag != 0) {
                for (NSMutableDictionary *item in registEvents) {
                    if ([[[item valueForKey:@"registered_event"] valueForKey:@"id"] intValue] == myCell.eventId) {
                        [myCell.followOrNotButton setImage:[UIImage imageNamed:@"regist"] forState:UIControlStateNormal];
                        break;
                    }
                }
            }
        } else {
            myCell.followOrNotButton.tag = 0;
            myCell.followOrNotButton.hidden = true;
        }
        
        return myCell;
    } else {
        NSMutableArray *useArray;
        if ([self.searchBar.text length] != 0) {
            useArray = searchResults;
        } else {
            useArray = volunteerNpos;
        }
        VolunteerNpoCollectionViewCell *myCell = [collectionView
                                                  dequeueReusableCellWithReuseIdentifier:@"ResourceNpoCell"
                                                  forIndexPath:indexPath];
        
        long row = [indexPath row];
        
        myCell.viewController = self;
        
        NSMutableDictionary *npoEntity = (NSMutableDictionary *)useArray[row];
        
        myCell.npoId = [[npoEntity valueForKey:@"id"] intValue];
        
        myCell.title.text = [npoEntity valueForKey:@"name"];
        
        NSString *urlLink = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], [npoEntity valueForKey:@"npo_icon"]];
        NSString *fileName = [[urlLink componentsSeparatedByString:@"/"] lastObject];
        
        myCell.judgeNum.text = [NSString stringWithFormat:@"%@ 人", [npoEntity valueForKey:@"rating_user_num"]];
        myCell.followNum.text = [NSString stringWithFormat:@"%@ 人", [npoEntity valueForKey:@"subscribed_user_num"]];
        myCell.eventCount.text = [NSString stringWithFormat:@"%@ 場活動", [npoEntity valueForKey:@"event_num"]];
        myCell.joinNum.text = [NSString stringWithFormat:@"%@ 人", [npoEntity valueForKey:@"joined_user_num"]];
        
        int totalRatingScore = [[npoEntity valueForKey:@"total_rating_score" ] intValue];
        if (totalRatingScore == 5) {
            [myCell.score5 setImage:[UIImage imageNamed:@"star_2"]];
            [myCell.score4 setImage:[UIImage imageNamed:@"star_2"]];
            [myCell.score3 setImage:[UIImage imageNamed:@"star_2"]];
            [myCell.score2 setImage:[UIImage imageNamed:@"star_2"]];
            [myCell.score1 setImage:[UIImage imageNamed:@"star_2"]];
        } else if (totalRatingScore == 4) {
            [myCell.score5 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score4 setImage:[UIImage imageNamed:@"star_2"]];
            [myCell.score3 setImage:[UIImage imageNamed:@"star_2"]];
            [myCell.score2 setImage:[UIImage imageNamed:@"star_2"]];
            [myCell.score1 setImage:[UIImage imageNamed:@"star_2"]];
        } else if (totalRatingScore == 3) {
            [myCell.score5 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score4 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score3 setImage:[UIImage imageNamed:@"star_2"]];
            [myCell.score2 setImage:[UIImage imageNamed:@"star_2"]];
            [myCell.score1 setImage:[UIImage imageNamed:@"star_2"]];
        }else if (totalRatingScore == 2) {
            [myCell.score5 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score4 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score3 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score2 setImage:[UIImage imageNamed:@"star_2"]];
            [myCell.score1 setImage:[UIImage imageNamed:@"star_2"]];
        }else if (totalRatingScore == 1) {
            [myCell.score5 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score4 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score3 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score2 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score1 setImage:[UIImage imageNamed:@"star_2"]];
        } else {
            [myCell.score5 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score4 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score3 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score2 setImage:[UIImage imageNamed:@"star_0"]];
            [myCell.score1 setImage:[UIImage imageNamed:@"star_0"]];
        }

        myCell.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [myCell.spinner setCenter:CGPointMake(myCell.image.center.x, myCell.image.center.y)]; // I do this because I'm in landscape mode
        [myCell.image addSubview:myCell.spinner]; // spinner is not visible until started
        
        [myCell.spinner startAnimating];
        
        // Here we use the new provided setImageWithURL: method to load the web image
        [myCell.image sd_setImageWithURL:[NSURL URLWithString:urlLink]
                        placeholderImage:[UIImage imageNamed:fileName]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   if ([myCell.spinner isAnimating]) {
                                       [myCell.spinner stopAnimating];
                                   }
                               }];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefault objectForKey:@"token"];
        if (token != nil) {
            myCell.followOrNotButton.hidden = false;
            myCell.followOrNotButton.tag = 0;
            [myCell.followOrNotButton setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
            for (NSMutableDictionary *item in subscribeNpos) {
                if ([[[item valueForKey:@"subscribed_NPO"] valueForKey:@"id"] intValue] == myCell.npoId) {
                    [myCell.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
                    myCell.followOrNotButton.tag = 1;
                    break;
                }
            }
        } else {
            myCell.followOrNotButton.tag = 0;
            myCell.followOrNotButton.hidden = true;
        }
        
        return myCell;
    }
}

- (void)reloadData {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefault objectForKey:@"token"];
    if (token != nil) {
        NSString *urlLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getImageUrlName], [appDelegate.user valueForKey:@"icon"]];
        NSString *fileName = [appDelegate.user valueForKey:@"icon"];
        
        NSString *strUrl = [fileName stringByReplacingOccurrencesOfString:@"uploads" withString:@"resources"];

        NSString *urlLick2 = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getImageUrlName], strUrl];
        // Here we use the new provided setImageWithURL: method to load the web image
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:urlLick2] forState:UIControlStateNormal
                         placeholderImage:[UIImage imageNamed:fileName]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    [self.userIcon setImage:image forState:UIControlStateSelected];
                                }];
    } else {
        [self.userIcon setImage:[UIImage imageNamed:@"profile"] forState:UIControlStateNormal];
        [self.userIcon setImage:[UIImage imageNamed:@"profile"] forState:UIControlStateSelected];
    }
    
    NSArray *sortedArray;
    volunteerEvents = [[NSMutableArray alloc] init];
    
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    if(isNearest && myLocation != nil) {
        sortedArray = [appDelegate.event sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[a valueForKey:@"lat"] floatValue] longitude:[[a valueForKey:@"lng"] floatValue]];
            CLLocation *locB = [[CLLocation alloc] initWithLatitude:[[b valueForKey:@"lat"] floatValue] longitude:[[b valueForKey:@"lng"] floatValue]];
            CLLocationDistance distanceA = [locA distanceFromLocation:myLocation];
            CLLocationDistance distanceB = [locB distanceFromLocation:myLocation];
            
            return distanceA - distanceB;
        }];
        
        // 一般活動
        for(NSMutableDictionary *item in sortedArray)
        {
            NSDate *registDate = [dateFormat dateFromString:[item valueForKey:@"register_deadline_date"]];
            
            // 過期
            if ([registDate compare:today] == NSOrderedAscending) {
                continue;
            }
            
            BOOL is_volunteer_event = [[item valueForKey:@"is_volunteer_event"] boolValue];
            
            if (!is_volunteer_event) {
                [volunteerEvents addObject:item];
            }
        }
        
    } else {
        sortedArray = [appDelegate.event sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [a valueForKey:@"close_date"];
            NSDate *second = [b valueForKey:@"close_date"];
            return [first compare:second];
        }];
        
        
        NSMutableArray *volunteerEventFullList = [[NSMutableArray alloc] init];
        
        // 緊急招募
        for(NSMutableDictionary *item in sortedArray)
        {
            NSDate *registDate = [dateFormat dateFromString:[item valueForKey:@"register_deadline_date"]];
            
            // 過期
            if ([registDate compare:today] == NSOrderedAscending) {
                continue;
            }
            
            
            BOOL is_volunteer_event = [[item valueForKey:@"is_volunteer_event"] boolValue];
            
            BOOL isUrgent = [[item valueForKey:@"is_urgent"] boolValue];
            
            if (!is_volunteer_event & isUrgent) {
                if([self isFullEvent:item]){
                    [volunteerEventFullList addObject:item];
                }else{
                    [volunteerEvents addObject:item];
                }
            }
        }
        
        // 短期活動
        for(NSMutableDictionary *item in sortedArray)
        {
            NSDate *registDate = [dateFormat dateFromString:[item valueForKey:@"register_deadline_date"]];
            
            // 過期
            if ([registDate compare:today] == NSOrderedAscending) {
                continue;
            }
            
            BOOL is_volunteer_event = [[item valueForKey:@"is_volunteer_event"] boolValue];
            
            BOOL isUrgent = [[item valueForKey:@"is_urgent"] boolValue];
            BOOL isShort = [[item valueForKey:@"is_short"] boolValue];
            if (!is_volunteer_event & !isUrgent & isShort) {
                
                if([self isFullEvent:item]){
                    [volunteerEventFullList addObject:item];
                }else{
                    [volunteerEvents addObject:item];
                }
            }
        }
        
        // 一般活動
        for(NSMutableDictionary *item in sortedArray)
        {
            NSDate *registDate = [dateFormat dateFromString:[item valueForKey:@"register_deadline_date"]];
            
            // 過期
            if ([registDate compare:today] == NSOrderedAscending) {
                continue;
            }
            
            BOOL is_volunteer_event = [[item valueForKey:@"is_volunteer_event"] boolValue];
            
            BOOL isUrgent = [[item valueForKey:@"is_urgent"] boolValue];
            BOOL isShort = [[item valueForKey:@"is_short"] boolValue];
            
            if (!is_volunteer_event & !isUrgent & !isShort) {
                
                if([self isFullEvent:item]){
                    [volunteerEventFullList addObject:item];
                }else{
                    [volunteerEvents addObject:item];
                }
            }
        }
        
        [volunteerEvents addObjectsFromArray:volunteerEventFullList];
        //FIH-add for Active display and arrangement logic settings start
        //依上架时间进行数组源的重新排序
        //设置新的数据字典，并储存新的数据，
           NSMutableDictionary *dicSceneDatas = [NSMutableDictionary dictionary];
           //遍历整个数据源，获取数据源里面的元素，并将key对应的NSDictionary设置为对应的key对应的value
           for (NSInteger i=0; i<volunteerEvents.count; i++) {
               NSDictionary * model = volunteerEvents[i];
               NSString *pub_date = model[@"pub_date"];//上架时间
               NSString *stringInt = [NSString stringWithFormat:@"%@%ld",pub_date,(long)i];
                   [dicSceneDatas setObject:model forKey:stringInt];//对上架时间进行排序
           }
        //获取dicSceneDatas所有的key
            NSArray *keyArray = [dicSceneDatas allKeys];
        //下面这个方法就是这方法的核心，obj1和obj2是遍历keyArray的下标，也就是排序要使用的字段，最后这个方法会根据keyArray的中的key进行排，并返回最后的排序的结果，sortedArray就是排序完的key
            NSArray *orderedDateArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(NSDate *date1, NSDate * date2) {

                return [date2 compare:date1];

            }];
        //这里移除_dataSource所有数据并重新放置
            [volunteerEvents removeAllObjects];
            //遍历dicSceneDatas，里面存的是所有的数据字典
            for (int i = 0; i < dicSceneDatas.count; i++) {
                //获取sortedArray所有的key并根据i获取到对应的key
                NSString *key = [orderedDateArray objectAtIndex:i];
                //根据排序号的key，通过key获取到对应的数据放置到最新的数据源里即可，最后_dataSource里面就是最新排好序的数据源
                [volunteerEvents addObject:[dicSceneDatas objectForKey:key]];
            }
        //已截止的活动不显示
//        [volunteerEvents enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
//            NSDate *closeDate = [dateFormat dateFromString:[obj valueForKey:@"close_date"]];//报名截止日期
//            if ([self daysBetweenDate:[NSDate date] andDate:closeDate] < 0) {
//                [volunteerEvents removeObject:obj];
//            }
//            }];
//        NSMutableArray *tmp2 = [NSMutableArray arrayWithArray:volunteerEvents];
//        for (NSDictionary *model in tmp2) {
//            NSDate *closeDate = [dateFormat dateFromString:[model valueForKey:@"close_date"]];//报名截止日期
//            if ([self daysBetweenDate:[NSDate date] andDate:closeDate] < 0) {
//                [volunteerEvents removeObject:model];
//            }
//        }
        //已额满的并且已截止活动不显示
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:volunteerEvents];
        for (NSDictionary *model in tmp) {
            NSDate *closeDate = [dateFormat dateFromString:[model valueForKey:@"close_date"]];//报名截止日期
            long voluteerNum = [[model valueForKey:@"required_volunteer_number"] integerValue] - [[model valueForKey:@"current_volunteer_number"] integerValue];
            if (voluteerNum == 0 && [self daysBetweenDate:[NSDate date] andDate:closeDate] < 0) {
                [volunteerEvents removeObject:model];
                }                      
        }       
//        [volunteerEvents enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
//            long voluteerNum = [[obj valueForKey:@"required_volunteer_number"] integerValue] - [[obj valueForKey:@"current_volunteer_number"] integerValue];
//            if (voluteerNum == 0) {
//                [volunteerEvents removeObject:obj];
//                }
//
//            }];
        //FIH-add for Active display and arrangement logic settings end
    }
    
    
    
    [eventRefreshControl endRefreshing];
    
    volunteerNpos = [NSMutableArray arrayWithArray:[appDelegate npo]];
    focusEvents = [NSMutableArray arrayWithArray:appDelegate.focused_event];
    registEvents = [NSMutableArray arrayWithArray:appDelegate.registered_event];
    subscribeNpos = [NSMutableArray arrayWithArray:appDelegate.subscribe_npo];
    
    [self.volunteerEventCollectionView reloadData];
    [self.volunteerNpoCollectionView reloadData];
}

- (bool)isFullEvent:(NSMutableDictionary*)event{
    
    NSInteger currentVolunteerNum = [[event valueForKey:@"current_volunteer_number"] integerValue];
    NSInteger requiredVolunteerNum = [[event valueForKey:@"required_volunteer_number"] integerValue];
    if(requiredVolunteerNum == 0){
        return NO;
    }
    if(currentVolunteerNum >= requiredVolunteerNum){
        return YES;
    }
    return NO;
    
}

- (void)reloadFocus
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    focusEvents = [NSMutableArray arrayWithArray:appDelegate.focused_event];
    subscribeNpos = [NSMutableArray arrayWithArray:appDelegate.subscribe_npo];
}

-(NSString *)translateTimeToLocaleZone:(NSString *)originTime
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDateFormatter *dateOutFormat = [[NSDateFormatter alloc] init];
    [dateOutFormat setDateFormat:@"yyyy/MM/dd"];
    
    NSDate *date = [dateFormat dateFromString:originTime];
    /*
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:date];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:date];
    
    NSString *theDate = [dateOutFormat stringFromDate:destinationDate];
     */
    NSString *theDate = [dateOutFormat stringFromDate:date];
    return theDate;
    
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

- (void)setTypeViewController:(EditSkillStringViewController *)controller didFinishEnteringItem:(NSArray *)enableList
{
    enableType = enableList;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performFilteringBySearchText:searchBar.text];
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0) {
        searchResults = nil;
        if (isVolunteerEvent) {
            [self.volunteerEventCollectionView reloadData];
        } else {
            [self.volunteerNpoCollectionView reloadData];
        }
        
        self.autoCompleteTableView.hidden = true;
        
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    } else {
        autoCompleteArray = [[NSMutableArray alloc] init];
        if (isVolunteerEvent) {
            int count = 0;
            for (NSMutableDictionary *item in volunteerEvents) {
                if([[item valueForKey:@"subject"] hasPrefix:searchText])
                {
                    count++;
                    [autoCompleteArray addObject:[item valueForKey:@"subject"]];
                }
                else if([[NSString stringWithFormat:@"%@%@", [item valueForKey:@"address_city"], [item valueForKey:@"address"]] hasPrefix:searchText])
                {
                    [autoCompleteArray addObject:[NSString stringWithFormat:@"%@%@", [item valueForKey:@"address_city"], [item valueForKey:@"address"]]];
                    count++;
                    /*if (count == 3) {
                        break;
                    }*/
                }
            }
            if (count != 0) {
                self.autoCompleteTableView.hidden = false;
            } else {
                self.autoCompleteTableView.hidden = true;
            }
            [self.autoCompleteTableView reloadData];
        } else {
            int count = 0;
            for (NSMutableDictionary *item in volunteerNpos) {
                if([[item valueForKey:@"name"] hasPrefix:searchText])
                {
                    [autoCompleteArray addObject:[item valueForKey:@"name"]];
                    count++;
                    /*if (count == 3) {
                        break;
                    }*/
                }
            }
            if (count != 0) {
                self.autoCompleteTableView.hidden = false;
            } else {
                self.autoCompleteTableView.hidden = true;
            }
            [self.autoCompleteTableView reloadData];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1 && buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)performFilteringBySearchText:(NSString *)searchText
{
    searchResults = [[NSMutableArray alloc] init];
    
    if (isVolunteerEvent) {
        for (NSMutableDictionary *item in volunteerEvents) {
            if([[item valueForKey:@"subject"] rangeOfString:searchText].location != NSNotFound)
            {
                [searchResults addObject:item];
            }
            else if([[NSString stringWithFormat:@"%@%@", [item valueForKey:@"address_city"], [item valueForKey:@"address"]] rangeOfString:searchText].location != NSNotFound)
            {
                [searchResults addObject:item];
            }
        }
        [self.volunteerEventCollectionView reloadData];
    } else {
        for (NSMutableDictionary *item in volunteerNpos) {
            if([[item valueForKey:@"name"] rangeOfString:searchText].location != NSNotFound)
            {
                [searchResults addObject:item];
            }
        }
        [self.volunteerNpoCollectionView reloadData];
    }
}

- (void)startRefresh:(id)sender
{
    [WilloAPIV2 getDump:^void(){
        [self reloadData];
    }];
}

- (IBAction)gotoPersonInfo:(id)sender {
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    if (token != nil) {
        // goto PersonDetail
        [self performSegueWithIdentifier:@"segueResourceEventToUserProfile" sender:self];
    } else {
        // goto Login
        [self performSegueWithIdentifier:@"segueResourceEventToLogin" sender:self];
    }
}

- (IBAction)showAllEvent:(id)sender {
    isAdvancedSearch = false;
    isVolunteerEvent = true;
    isNearest = false;
    self.volunteerEventCollectionView.hidden = false;
    self.volunteerNpoCollectionView.hidden = true;
    self.advanceSearch.hidden = true;
    [self.showAllEventButton setTitleColor:[UIColor colorWithRed:236.0/255.0 green:108/255.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
    [self.advancedSearchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.showNearEventButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.showAllNpoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self reloadData];
}

- (IBAction)advancedSearch:(id)sender {
    isAdvancedSearch = true;
    isVolunteerEvent = true;
    isNearest = false;
    self.volunteerEventCollectionView.hidden = false;
    self.volunteerNpoCollectionView.hidden = true;
    self.advanceSearch.hidden = false;
    [self.showAllEventButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.advancedSearchButton setTitleColor:[UIColor colorWithRed:236.0/255.0 green:108/255.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
    [self.showNearEventButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.showAllNpoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)showNearEvent:(id)sender {
    [self startStandardUpdates];
    
    isAdvancedSearch = false;
    isVolunteerEvent = true;
    isNearest = true;
    isNearFirst = true;
    self.volunteerEventCollectionView.hidden = false;
    self.volunteerNpoCollectionView.hidden = true;
    self.advanceSearch.hidden = true;
    [self.showAllEventButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.advancedSearchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.showNearEventButton setTitleColor:[UIColor colorWithRed:236.0/255.0 green:108/255.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
    [self.showAllNpoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self reloadData];
}

- (IBAction)showAllNpo:(id)sender {
    isAdvancedSearch = false;
    isVolunteerEvent = false;
    isNearest = false;
    self.volunteerEventCollectionView.hidden = true;
    self.volunteerNpoCollectionView.hidden = false;
    self.advanceSearch.hidden = true;
    [self.showAllEventButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.advancedSearchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.showNearEventButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.showAllNpoButton setTitleColor:[UIColor colorWithRed:236.0/255.0 green:108/255.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
}

- (IBAction)showRegistedEvent:(id)sender {
    title = @"我未報到的活動";
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    events = [[NSMutableArray alloc] init];
    
    for(NSMutableDictionary *item in appDelegate.registered_event)
    {
        if (![[item valueForKey:@"isJoined"] boolValue] && [[[item valueForKey:@"registered_event"] valueForKey:@"is_volunteer_event"] boolValue]) {
            [events addObject:[item valueForKey:@"registered_event"]];
        }
    }
    [self performSegueWithIdentifier:@"segueResourceEventToEvent" sender:self];
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (locationManager  == nil)
        locationManager = [[CLLocationManager alloc] init];
    
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    } else {
        [locationManager startUpdatingLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        myLocation = [locations lastObject];
        [self reloadData];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
    
    if (isNearFirst) {
        isNearFirst = false;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"無法找到您的位置"
                                                        message:@"是否前往設定 [位置] 打開權限"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"好", nil];
        alert.tag = 1;
        [alert show];
    }
}


- (void)showPicker:(NSString *)alertTitle withValue:(NSInteger) value withTag:(NSInteger)tag completion:(void (^)(void))completion{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIPickerView *yearPicker = [[UIPickerView alloc] init];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion();
    }];
    
    yearPicker.delegate = self;
    yearPicker.dataSource = self;
    yearPicker.tag = tag;
    [yearPicker selectRow:value inComponent:0 animated:NO];
    
    [alert.view addSubview:yearPicker];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
}


- (IBAction)showIntervalAlert:(UIButton *)sender {
    [self showPicker:@"選擇區間" withValue:rowInterval  withTag:TAG_INTERVAL_PICKER completion:^{
        [_intervalButton setTitle:intervalPickerData[rowInterval] forState:UIControlStateNormal];
        //        _intervalButton.titleLabel.text = intervalPickerData[rowInterval];
        //        code
    }];
}


- (IBAction)showCityAlert:(UIButton *)sender {
    [self showPicker:@"選擇地區" withValue:rowCity  withTag:TAG_LOCALCATION_PICKER completion:^{
        [_cityButton setTitle:locationPickerData[rowCity] forState:UIControlStateNormal];
        //        code
    }];
}


- (IBAction)showFullStatusAlert:(UIButton *)sender {
    [self showPicker:@"選擇額滿狀態" withValue:rowFullStatus  withTag:TAG_FULL_STATUS_PICKER completion:^{
        [_fullStatusButton setTitle:fullStatusPickerData[rowFullStatus] forState:UIControlStateNormal];
        //        code
    }];
}



- (Boolean)isIntervalMatch:(NSMutableDictionary*) item{
    if( rowInterval == TAG_INTERVAL_URGENT && ![[item valueForKey:@"is_urgent"] boolValue]){
        // 緊急
        return NO;
    }else if (rowInterval == TAG_INTERVAL_LONG && ![[item valueForKey:@"is_short"] boolValue]){
        // 長期
        return NO;
    }else if (rowInterval == TAG_INTERVAL_SHORT && [[item valueForKey:@"is_short"] boolValue]){
        // 短期
        return NO;
    }
    return YES;
}

- (Boolean)isVolunteerTypeMatch:(NSMutableDictionary*) item{
    if([[item valueForKey:@"volunteer_type"] isEqualToString:@"不限"]){
        return YES;
    }
    for (NSString *type in enableType)
    {
//        NSLog(@"test %@, want %@", type ,[item valueForKey:@"volunteer_type"]);
        if ([[item valueForKey:@"volunteer_type"] isEqualToString:type]) {
            return YES;
        }
    }
    return NO;
}

- (Boolean)isAddressCityMatch:(NSMutableDictionary*) item{
    if(rowCity != 0 && ![[item valueForKey:@"address_city"] isEqualToString:locationPickerData[rowCity]]){
        return NO;
    }
    return YES;
}

- (Boolean)isFullStatusMatch:(NSMutableDictionary*) item{
    
    NSInteger currentVolunteerNum = [[item valueForKey:@"current_volunteer_number"] integerValue];
    NSInteger requiredVolunteerNum = [[item valueForKey:@"required_volunteer_number"] integerValue];
    if([fullStatusPickerData[rowFullStatus] isEqualToString:@"未額滿"]){
        if(requiredVolunteerNum == 0){
            return YES;
        }
        if(currentVolunteerNum < requiredVolunteerNum){
            return YES;
        }
        return NO;
    }else if([fullStatusPickerData[rowFullStatus] isEqualToString:@"已額滿"]){
        if(requiredVolunteerNum == 0){
            return NO;
        }
        if(currentVolunteerNum >= requiredVolunteerNum){
            return YES;
        }
        return NO;
    }
    
    return YES;
}

- (IBAction)doAdvancedSearch:(id)sender {
//    NSInteger row = [self.eventIntervalPicker selectedRowInComponent:0];
//    NSInteger rowCity = [self.eventLocationPicker selectedRowInComponent:0];
    searchResults = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *item in volunteerEvents) {
        if (![self isIntervalMatch:item]){
            NSLog(@"remove because isIntervalMatch");
            continue;
        }
        
        if (![self isVolunteerTypeMatch:item]){
            NSLog(@"remove because isVolunteerTypeMatch");
            continue;
        }
        
        if (![self isAddressCityMatch:item]){
            NSLog(@"remove because isAddressCityMatch");
            continue;
        }
        
        if (![self isFullStatusMatch:item]){
            NSLog(@"remove because isFullStatusMatch");
            continue;
        }
        
        [searchResults addObject:item];
        
        
        
    }
    [self.volunteerEventCollectionView reloadData];
    
//    
//    if (row == 1) {
//        // 緊急
//        for (NSMutableDictionary *item in volunteerEvents) {
//            bool matchType = false;
//            for (NSString *type in enableType)
//            {
//                if ([[item valueForKey:@"volunteer_type"] isEqualToString:type]) {
//                    matchType = true;
//                }
//            }
//            if (!matchType) {
//                continue;
//            }
//            
//            if (rowCity == 0) {
//                if([[item valueForKey:@"is_urgent"] boolValue])
//                {
//                    [searchResults addObject:item];
//                }
//            }
//            else if([[item valueForKey:@"address_city"] isEqualToString:locationPickerData[rowCity]])
//            {
//                if([[item valueForKey:@"is_urgent"] boolValue])
//                {
//                    [searchResults addObject:item];
//                }
//            }
//        }
//        [self.volunteerEventCollectionView reloadData];
//        
//    } else if(row == 2) {
//        // 長期
//        for (NSMutableDictionary *item in volunteerEvents) {
//            bool matchType = false;
//            for (NSString *type in enableType)
//            {
//                if ([[item valueForKey:@"volunteer_type"] isEqualToString:type]) {
//                    matchType = true;
//                }
//            }
//            if (!matchType) {
//                continue;
//            }
//            
//            if (rowCity == 0) {
//                if(![[item valueForKey:@"is_urgent"] boolValue] && ![[item valueForKey:@"is_short"] boolValue])
//                {
//                    [searchResults addObject:item];
//                }
//            }
//            else if([[item valueForKey:@"address_city"] isEqualToString:locationPickerData[rowCity]])
//            {
//                if(![[item valueForKey:@"is_urgent"] boolValue] && ![[item valueForKey:@"is_short"] boolValue])
//                {
//                    [searchResults addObject:item];
//                }
//            }
//        }
//        [self.volunteerEventCollectionView reloadData];
//    } else if(row == 3) {
//        // 短期
//        for (NSMutableDictionary *item in volunteerEvents) {
//            bool matchType = false;
//            for (NSString *type in enableType)
//            {
//                if ([[item valueForKey:@"volunteer_type"] isEqualToString:type]) {
//                    matchType = true;
//                }
//            }
//            if (!matchType) {
//                continue;
//            }
//            
//            if (rowCity == 0) {
//                if([[item valueForKey:@"is_short"] boolValue])
//                {
//                    [searchResults addObject:item];
//                }
//            }
//            else if([[item valueForKey:@"address_city"] isEqualToString:locationPickerData[rowCity]])
//            {
//                if([[item valueForKey:@"is_short"] boolValue])
//                {
//                    [searchResults addObject:item];
//                }
//            }
//        }
//        [self.volunteerEventCollectionView reloadData];
//    } else {
//        for (NSMutableDictionary *item in volunteerEvents) {
//            bool matchType = false;
//            for (NSString *type in enableType)
//            {
//                if ([[item valueForKey:@"volunteer_type"] isEqualToString:type]) {
//                    matchType = true;
//                }
//            }
//            if (!matchType) {
//                continue;
//            }
//            
//            if (rowCity == 0) {
//                [searchResults addObject:item];
//            }
//            else if([locationPickerData[rowCity] isEqualToString:[item valueForKey:@"address_city"]])
//            {
//                [searchResults addObject:item];
//            }
//        }
//        
//        [self.volunteerEventCollectionView reloadData];
//    }
    self.advanceSearch.hidden = true;
    self.volunteerEventCollectionView.hidden = false;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueResourceToEventDetail"]) {
        NSArray *indexPaths = [self.volunteerEventCollectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        EventDetailViewController *destViewController = segue.destinationViewController;
        
        NSMutableArray *useArray;
        if ([self.searchBar.text length] != 0 || isAdvancedSearch) {
            useArray = searchResults;
        } else {
            useArray = volunteerEvents;
        }
        
        NSMutableDictionary *event = useArray[indexPath.row];
        destViewController.eventId = [[event valueForKey:@"id"] intValue];
        destViewController.event = event;
        [self.volunteerEventCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    } else if ([segue.identifier isEqualToString:@"segueResourceEventToEvent"]) {
        EventViewController *destViewController = segue.destinationViewController;
        destViewController.title = title;
        destViewController.events = events;
    } else if ([segue.identifier isEqualToString:@"segueResourceEventToNpoDetail"]) {
        NSArray *indexPaths = [self.volunteerNpoCollectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        NpoDetailViewController *destViewController = segue.destinationViewController;
        
        NSMutableArray *useArray;
        if ([self.searchBar.text length] != 0 || isAdvancedSearch) {
            useArray = searchResults;
        } else {
            useArray = volunteerNpos;
        }
        
        NSMutableDictionary *npo = useArray[indexPath.row];
        destViewController.npo = npo;
        destViewController.npoId = [[npo valueForKey:@"id"] intValue];

    } else if ([segue.identifier isEqualToString:@"segueResourceEventToUserProfile"]) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        UserProfileViewController *destViewController = segue.destinationViewController;
        destViewController.profile = appDelegate.user;
        destViewController.isEditable = true;
    } else if([segue.identifier isEqualToString:@"segeuResourceEventToEditEventType"]) {
        EditEventTypeViewController *destViewController = segue.destinationViewController;
        destViewController.delegate = self;
        destViewController.typeEnableList = [NSMutableArray arrayWithArray:enableType];
        destViewController.useArray = allType;
    }
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
