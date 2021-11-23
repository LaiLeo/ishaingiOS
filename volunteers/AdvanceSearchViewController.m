//
//  AdvanceSearchViewController.m
//  volunteers
//
//  Created by Pichu Chen on 平成28/9/11.
//  Copyright © 平成28年 taiwanmobile. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
//#import "EventViewController.h"
//#import "NpoViewController.h"
//#import "SkillsHabitsViewController.h"
#import "AdvanceSearchViewController.h"
#import "WilloAPIV2.h"

@interface AdvanceSearchViewController ()

@end

@implementation AdvanceSearchViewController
{
//    NSMutableArray *events;
//    NSMutableArray *npos;
//    NSString *title;
    NSDictionary *profile;
    BOOL isEditable;
    NSMutableArray *pickerData;
    NSInteger selectedRow;
    NSInteger selectedStartYearRow;
    NSInteger selectedEndYearRow;
}


@synthesize profile;
@synthesize isEditable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.scrollWidth.constant = screenWidth;
}


- (void)viewDidAppear:(BOOL)animated {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if([[profile valueForKey:@"id" ] intValue] == [[appDelegate.user valueForKey:@"id"] intValue])
    {
        profile = appDelegate.user;
    }
    
    
//    self.descriptionHeight.constant = sizeThatShouldFitTheContent.height;
    
    //    self.scrollHeight.constant = 630 - 200 - 80 + self.scrollWidth.constant / 2 + sizeThatShouldFitTheContent.height;
    // WTF, who knows what "670", "200", "80" means!!!
//    self.scrollHeight.constant = 670 - 200 - 80 + self.scrollWidth.constant / 2 + sizeThatShouldFitTheContent.height;
    
    NSString *urlLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], [profile valueForKey:@"icon"]];
    NSString *fileName = [appDelegate.user valueForKey:@"icon"];
    NSString *strUrl = [fileName stringByReplacingOccurrencesOfString:@"uploads" withString:@"resources"];
    NSString *urlLick2 = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getImageUrlName], strUrl];

    [self.spinner startAnimating];
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:urlLick2]
                     placeholderImage:[UIImage imageNamed:fileName]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                [self.spinner stopAnimating];
                            }];
    
    self.name.text = [profile valueForKey:@"name"];
    self.email.text = [profile valueForKey:@"email"];
    
    int score = [[profile valueForKey:@"score"] intValue];
    
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
    } else {
        self.editButton.hidden = true;
    }
    [self initPickerArray];
}

- (void)initPickerArray{
    pickerData = [[NSMutableArray alloc] init];
    
    [pickerData addObject:@"不限"];
    for( NSInteger i = [self getNowYear] ; i >= 2014; i -= 1 ){
        [pickerData addObject:[[NSString alloc] initWithFormat:@"%ld",(long)i]];
    }
    
}

- (NSInteger)getNowYear{
    // http://stackoverflow.com/questions/3694867/nsdate-get-year-month-day
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = [components year];
    return year;
}


- (void)showPicker:(NSString *)title withValue:(NSInteger) value completion:(void (^)(void))completion{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIPickerView *yearPicker = [[UIPickerView alloc] init];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion();
    }];
    
    yearPicker.delegate = self;
    yearPicker.dataSource = self;
    [yearPicker selectRow:value inComponent:0 animated:NO];
    
    [alert.view addSubview:yearPicker];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)showStartYearPicker:(id)sender{
    [self showPicker:@"選擇開始時間" withValue:selectedStartYearRow completion:^{
        selectedStartYearRow = selectedRow;
        [_startYearLabel setText:pickerData[selectedStartYearRow]];
        
    }];
}
- (IBAction)showEndYearPicker:(id)sender{
    [self showPicker:@"選擇結束時間" withValue:selectedEndYearRow completion:^{
        selectedEndYearRow = selectedRow;
        [_endYearLabel setText:pickerData[selectedEndYearRow]];
    }];
    
}


- (IBAction)calculateVolunteerHours:(id)sender {
    NSInteger thisYear = [self getNowYear];
    NSInteger startYear = 0;
    NSInteger endYear = 0;
    if(selectedStartYearRow != 0){
        startYear = thisYear - selectedStartYearRow + 1;
    }
    
    if(selectedEndYearRow != 0){
        endYear = thisYear - selectedEndYearRow + 1;
    }
    
    
    [_generalVolunteerHourLabel setText: [[NSString alloc] initWithFormat:@"%ld", [WilloAPIV2 queryUserGeneralEventHourFrom:startYear to:endYear] ] ];
    [_enterpriseVolunteerHourLabel setText: [[NSString alloc] initWithFormat:@"%ld", [WilloAPIV2 queryUserEnterpriseEventHourFrom:startYear to:endYear] ] ];
    [_totalVolunteerHourLabel setText: [[NSString alloc] initWithFormat:@"%ld", [WilloAPIV2 queryUserEventHourFrom:startYear to:endYear] ] ];
    
    
    _generalVolunteerHourView.hidden = NO;
    _enterpriseVolunteerHourView.hidden = NO;
    _totalVolunteerHourView.hidden = NO;
    
}



#pragma mark - UIPicker Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerData count];
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    timeLabel.text = pickerData[row];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    return timeLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedRow = row;
}

@end



