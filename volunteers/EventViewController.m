//
//  EventViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/4.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "EventDetailViewController.h"
#import "EventViewController.h"
#import "VolunteerEventCollectionViewCell.h"
#import "WilloAPIV2.h"

@interface EventViewController ()

@end

@implementation EventViewController
{
    NSString *viewControllerTitle;
    NSArray *events;
    Boolean isResourceEvent;
}
@synthesize viewControllerTitle;
@synthesize events;
@synthesize isResourceEvent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (viewControllerTitle != nil) {
        self.viewTitle.title = viewControllerTitle;
    }
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
    return events.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VolunteerEventCollectionViewCell *myCell = [collectionView
                                                    dequeueReusableCellWithReuseIdentifier:@"EventCell"
                                                    forIndexPath:indexPath];
        
    long row = [indexPath row];
    NSMutableDictionary *eventEntity = (NSMutableDictionary *)events[row];
        
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
        

    myCell.distance.hidden = true;

        
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
        myCell.dateCount.text = [NSString stringWithFormat:@"剩%ld日", (long)[self daysBetweenDate:[NSDate date] andDate:closeDate]/86400];
    }
        
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    for (NSMutableDictionary *item in appDelegate.focused_event) {
        if ([[[item valueForKey:@"focused_event"] valueForKey:@"id"] intValue] == myCell.eventId) {
            [myCell.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
            myCell.followOrNotButton.tag = 1;
            break;
        }
    }
    
    return myCell;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueEventToEventDetail"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        EventDetailViewController *destViewController = segue.destinationViewController;
        NSMutableDictionary *event = events[indexPath.row];
        destViewController.eventId = [[event valueForKey:@"id"] intValue];
        destViewController.event = event;
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
}

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
