    //
//  EventDetailViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/2.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "BarCodeScannerViewController.h"
#import "EditSkillStringViewController.h"
#import "EventDetailViewController.h"
#import "EventResultViewController.h"
#import "ImageDetailViewController.h"
#import "LoginViewController.h"
#import "RegistEventViewController.h"
#import "VolunteerNoticeViewController.h"
#import "NpoDetailViewController.h"
#import "WilloAPIV2.h"
#import "UIView+Toast.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController
{
    int eventId;
    NSMutableDictionary *event;
    bool isRegist;
    int score;
    NSArray *skills;
    
    int movementDistance;
    UITextField *selectTextField;
    CGSize keyboardSize;
    
    NSMutableArray *skillGroupArray;
    UIPickerView *skillGroupPicker;
    UIView *inputAccView;
    UIButton *btnGroupDetial;
    
    NSString *groupDetail;

}
@synthesize inputAccView;
@synthesize btnGroupDetial;
@synthesize eventId;
@synthesize event;
@synthesize skills;

#define TAG_CANCEL_ALERT_DIALAG 1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    self.scrollWidth.constant = screenWidth;
    
    self.judgeButton.userInteractionEnabled = false;
    isRegist = false;
    
    if ([[event valueForKey:@"required_group"] boolValue]) {
        if ([[event valueForKey:@"is_volunteer_event"] boolValue]) {
            self.joinGroup.hidden = false;
        
            skillGroupPicker = [[UIPickerView alloc] init];
            self.joinGroup.inputView = skillGroupPicker;
            skillGroupPicker.dataSource = self;
            skillGroupPicker.delegate = self;
            skillGroupPicker.showsSelectionIndicator = YES;
        }
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, 40.0)];
        
        // Set the view’s background color. We’ ll set it here to gray. Use any color you want.
        [inputAccView setBackgroundColor:[UIColor lightGrayColor]];
        
        // We can play a little with transparency as well using the Alpha property. Normally
        // you can leave it unchanged.
        [inputAccView setAlpha: 0.8];
        
        btnGroupDetial = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnGroupDetial setFrame:CGRectMake(screenWidth - 90.0, 0.0f, 80.0f, 40.0f)];
        [btnGroupDetial setTitle:@"組別說明" forState:UIControlStateNormal];
        // [btnGroupDetial setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnGroupDetial addTarget:self action:@selector(showGroupDetail) forControlEvents:UIControlEventTouchUpInside];
        
        // Now that our buttons are ready we just have to add them to our view.

        [inputAccView addSubview:btnGroupDetial];
        
        self.joinGroup.inputAccessoryView = inputAccView;
        
        skillGroupArray = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *skill in [event valueForKey:@"skill_groups"]) {
            if ([[skill valueForKey:@"volunteer_number"] intValue] - [[skill valueForKey:@"current_volunteer_number"]intValue] > 0)
            {
                [skillGroupArray addObject:skill];
            }
        }
    } else {
        self.joinSkill.hidden = false;
        if ([[event valueForKey:@"skills_description"] length] == 0) {
            skills = nil;
            self.joinSkill.hidden = true;
        } else {
            skills = [[event valueForKey:@"skills_description"] componentsSeparatedByString:@","];
        }
    }
    
    float totalRatingScore = [[event valueForKey:@"total_rating_score"] floatValue];
    if (totalRatingScore >= 5) {
        [self.score1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score2 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score3 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score4 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score5 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    } else if(totalRatingScore >= 4) {
        [self.score1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score2 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score3 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score4 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    } else if(totalRatingScore >= 3) {
        [self.score1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score2 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score3 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score4 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
        [self.score5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    } else if(totalRatingScore >= 2) {
        [self.score1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score2 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score3 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
        [self.score4 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
        [self.score5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    } else if(totalRatingScore >= 1) {
        [self.score1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
        [self.score2 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
        [self.score3 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
        [self.score4 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
        [self.score5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    } else if(totalRatingScore == 0) {
        [self.score1 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
        [self.score2 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
        [self.score3 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
        [self.score4 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
        [self.score5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    }
    self.judgeNum.text = [NSString stringWithFormat:@"%d", [[event valueForKey:@"rating_user_num"] intValue]];
    
    self.eventTitle.text = [NSString stringWithFormat:@"%@", [event valueForKey:@"subject"]];
    
    self.npoName.text = [[event valueForKey:@"owner_NPO"] valueForKey:@"name"];
    
    self.registTime.text = [NSString stringWithFormat:@"%@", [event valueForKey:@"subject"]];

    NSString *register_deadline_date = [self translateTimeToLocaleZone:[event valueForKey:@"register_deadline_date"] hasMinSec:false];
    NSString *happen_date = [self translateTimeToLocaleZone:[event valueForKey:@"happen_date"] hasMinSec:true];
    NSString *close_date = [self translateTimeToLocaleZone:[event valueForKey:@"close_date"] hasMinSec:false];
    
    int current_volunteer_number = [[event valueForKey:@"current_volunteer_number"] intValue];
    int required_volunteer_number = [[event valueForKey:@"required_volunteer_number"] intValue];
    
    self.registTime.text = [NSString stringWithFormat:@"活動結束時間 %@", register_deadline_date];
    self.volunteerTrainButton.layer.cornerRadius = 14;

    //start活动开始时间
    self.startTimeImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 75, 20, 20)];
    self.startTimeImage.image = [UIImage imageNamed:@"card_time"];
    self.startTimeImage.userInteractionEnabled = YES;
    [self.infoBlock addSubview:self.startTimeImage];
    
    self.startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, screenWidth-80, 30)];
    self.startTimeLabel.numberOfLines = 0;
    self.startTimeLabel.font = [UIFont systemFontOfSize:17];
//    self.startTimeLabel.text = [NSString stringWithFormat:@"活動開始時間: %@", [event valueForKey:@"volunteer_type"]];
    [self.infoBlock addSubview:self.startTimeLabel];
    //活动结束时间
    self.endTimeImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.startTimeLabel.frame)+5, 20, 20)];
    self.endTimeImage.image = [UIImage imageNamed:@"card_time"];
    self.endTimeImage.userInteractionEnabled = YES;
    [self.infoBlock addSubview:self.endTimeImage];
    
    self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.startTimeLabel.frame), screenWidth-170, 30)];
    self.endTimeLabel.numberOfLines = 0;
    self.endTimeLabel.font = [UIFont systemFontOfSize:17];
    self.endTimeLabel.text = @"活動結束時間:";
    [self.infoBlock addSubview:self.endTimeLabel];
    
    //剩余天
    self.surplusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.endTimeLabel.frame)+2, CGRectGetMaxY(self.startTimeLabel.frame), 100, 30)];
    self.surplusLabel.font = [UIFont systemFontOfSize:17];
    self.surplusLabel.textColor = [UIColor redColor];
    [self.infoBlock addSubview:self.surplusLabel];

    //活动地点
    self.addressImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.endTimeLabel.frame)+5, 20, 20)];
    self.addressImage.image = [UIImage imageNamed:@"card_place"];
    self.addressImage.userInteractionEnabled = YES;
    [self.infoBlock addSubview:self.addressImage];
    //end主办单位
    //start地址
    self.volunteerImage.hidden = YES;
    self.volunteerTimeImage.hidden = YES;
//    NSString *content = @"这是一个地址这是一个地址这是一个地址这是一个地址这是一个地址这是一个地址这是一个地址这是一个地址";
    NSString *content = [NSString stringWithFormat:@"%@%@", [event valueForKey:@"address_city"], [event valueForKey:@"address" ]];
    float h1 = 0;
    h1 = [self textHeightFontSize:17 lablew:screenWidth-80 textString:content];
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.endTimeLabel.frame)+5, screenWidth-80, h1+3)];//地址
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.font = [UIFont systemFontOfSize:17];
    [self.infoBlock addSubview:self.addressLabel];
    //end地址
    //start 人员数
    NSString *content1 = [NSString stringWithFormat:@"志工需求:尚缺%d名 / 共需%d名", required_volunteer_number - current_volunteer_number, required_volunteer_number];
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.addressLabel.frame), screenWidth-80, 30)];
    self.numberLabel.numberOfLines = 0;
    self.numberLabel.font = [UIFont systemFontOfSize:17];
    [self.infoBlock addSubview:self.numberLabel];
    //image
    self.numberImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.addressLabel.frame)+5, 20, 20)];
    self.numberImage.image = [UIImage imageNamed:@"card_people"];
    self.numberImage.userInteractionEnabled = YES;
    [self.infoBlock addSubview:self.numberImage];
    //end 人员数
    
    //活动类型
    self.typeImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.numberLabel.frame)+5, 20, 20)];
    self.typeImage.image = [UIImage imageNamed:@"card_event_type"];
    self.typeImage.userInteractionEnabled = YES;
    [self.infoBlock addSubview:self.typeImage];
    
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.numberLabel.frame), screenWidth-80, 30)];//地址
    self.typeLabel.numberOfLines = 0;
    self.typeLabel.font = [UIFont systemFontOfSize:17];
    self.typeLabel.text = [NSString stringWithFormat:@"活動類型: %@", [event valueForKey:@"volunteer_type"]];
    [self.infoBlock addSubview:self.typeLabel];
    //start时间
    NSString *content2 = [NSString stringWithFormat:@"志工時數:服務 %.1f 小時", [[event valueForKey:@"event_hour"] floatValue]];
    self.serviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.typeLabel.frame), screenWidth-80, 30)];
    self.serviceLabel.numberOfLines = 0;
    self.serviceLabel.font = [UIFont systemFontOfSize:17];
    [self.infoBlock addSubview:self.serviceLabel];
    //image
    self.serviceImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.typeLabel.frame)+5, 20, 20)];//地址
    self.serviceImage.image = [UIImage imageNamed:@"card_people_time"];
    self.serviceImage.userInteractionEnabled = YES;
    [self.infoBlock addSubview:self.serviceImage];
    
    
    //end时间
//主办单位
    float h2 = 0;
    NSString *content3 = [NSString stringWithFormat:@"主辦單位:%@",[[event valueForKey:@"owner_NPO"] valueForKey:@"name"]];

    h2 = [self textHeightFontSize:17 lablew:screenWidth-80 textString:content3];

    self.organizerImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.serviceImage.frame)+5, 20, 20)];
    self.organizerImage.image = [UIImage imageNamed:@"card_host"];
    self.organizerImage.userInteractionEnabled = YES;
    [self.infoBlock addSubview:self.organizerImage];
    
    self.organizerLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.serviceImage.frame), screenWidth-80, h2+10)];
    self.organizerLabel.numberOfLines = 0;
    self.organizerLabel.font = [UIFont systemFontOfSize:17];
    self.organizerLabel.text = content3;
    [self.infoBlock addSubview:self.organizerLabel];
    //主办单位end
    //物资需求
    self.lineDashView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.organizerImage.frame)+10, screenWidth-80, 70)];
    self.lineDashView.hidden = YES;
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = [UIColor blackColor].CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    //设置路径
    border.path = [UIBezierPath bezierPathWithRect:self.lineDashView.bounds].CGPath;
    border.frame = self.lineDashView.bounds;
    //虚线的宽度
    border.lineWidth = 1.f;
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    [self.lineDashView.layer addSublayer:border];
    [self.infoBlock addSubview:self.lineDashView];
    
    self.demandLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, screenWidth-80, 30)];
    self.demandLabel.numberOfLines = 0;
    self.demandLabel.font = [UIFont systemFontOfSize:17];
    self.demandLabel.text = @"物资需求：";
    [self.lineDashView addSubview:self.demandLabel];
    
    self.demandImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.demandLabel.frame)+5, 20, 20)];
    self.demandImage.image = [UIImage imageNamed:@"card_people_time"];
    self.demandImage.userInteractionEnabled = YES;
    [self.lineDashView addSubview:self.demandImage];
    
    self.demandContent = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.demandLabel.frame), screenWidth-80, 30)];
    self.demandContent.numberOfLines = 0;
    self.demandContent.font = [UIFont systemFontOfSize:17];
    self.demandContent.text = [event objectForKey:@"skills_description"];
    [self.lineDashView addSubview:self.demandContent];
    
    if ([[event valueForKey:@"is_volunteer_event"] boolValue]) {
        self.startTimeLabel.text = [NSString stringWithFormat:@"活動開始時間:%@", happen_date];
        self.endTimeLabel.text = [NSString stringWithFormat:@"活動結束時間:%@", close_date];
        self.addressLabel.text = [NSString stringWithFormat:@"活動舉辦地點:%@", content];
     

        //start 删除
//        self.volunteerNeed.text = [NSString stringWithFormat:@"尚缺%d名 / 共需%d名", required_volunteer_number - current_volunteer_number, required_volunteer_number];
        
//        self.voluteerTime.text = [NSString stringWithFormat:@"服務 %.1f 小時", [[event valueForKey:@"event_hour"] floatValue]];
        //end 删除
        //start add
        self.numberLabel.text = content1;
        self.serviceLabel.text = content2;
        //end add
        
        self.volunteerTrainButton.titleLabel.text = [NSString stringWithFormat:@"志工須知"];
    } else {
//            CGRect rect = CGRectMake(self.infoBlock.frame.origin.x,
//                                     self.infoBlock.frame.origin.y,
//                                     self.infoBlock.frame.size.width,
//                                     self.infoBlock.frame.size.height +
//                                     self.cooperationNpo.frame.size.height+100);
//            self.infoBlock.frame = rect;
        self.lineDashView.hidden = NO;
        self.organizerImage.frame = CGRectMake(5, CGRectGetMaxY(self.typeImage.frame)+5, 20, 20);
        self.organizerLabel.frame = CGRectMake(30, CGRectGetMaxY(self.typeImage.frame), screenWidth-80, h2+10);

        self.startTimeLabel.text = [NSString stringWithFormat:@"募集開始時間:%@", happen_date];
        self.endTimeLabel.text = [NSString stringWithFormat:@"募集結束時間:%@", close_date];
        self.addressLabel.text = [NSString stringWithFormat:@"物資募集地點:%@", content];

        NSString *content1 = [NSString stringWithFormat:@"志工需求:尚缺%d件 / 共需%d件", required_volunteer_number - current_volunteer_number, required_volunteer_number];
        self.numberLabel.text = content1;
        //start 删除
//        self.volunteerNeed.text = [NSString stringWithFormat:@"尚缺%d份 / 共需%d份", required_volunteer_number - current_volunteer_number, required_volunteer_number];
        //end 删除
        self.volunteerTimeIcon.hidden = true;
        self.serviceImage.hidden = true;
        self.voluteerTime.hidden = true;
        self.volunteerTrainButton.titleLabel.text = [NSString stringWithFormat:@"捐贈須知"];
    }
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *closeDate = [dateFormat dateFromString:[event valueForKey:@"close_date"]];
    if ([self daysBetweenDate:[NSDate date] andDate:closeDate] < 0) {
        self.scoreBlockHeight.constant = 60;
    } else {
        self.scoreBlock.hidden = true;
        self.scoreBlockHeight.constant = 0;
    }
    
    
    NSDate *registDate = [dateFormat dateFromString:[event valueForKey:@"register_deadline_date"]];
    if ([self daysBetweenDate:[NSDate date] andDate:registDate] < 0) {
        self.registTimeCount.text = @"報名截止";
    } else {
        self.registTimeCount.text = [NSString stringWithFormat:@"倒數%ld日", (long)([self daysBetweenDate:[NSDate date] andDate:registDate] / 86400) ] ;
        self.surplusLabel.text = [NSString stringWithFormat:@"倒數%ld日", (long)([self daysBetweenDate:[NSDate date] andDate:registDate] / 86400) ] ;
    }
    
//    self.registLocation.text = [NSString stringWithFormat:@"%@%@", [event valueForKey:@"address_city"], [event valueForKey:@"address" ]];
    
    NSString *description = [event valueForKey:@"skill_description"];
    self.eventDescription.text = [event valueForKey:@"description"];
    // self.eventDescription.selectable = NO;
    
    if ([[event valueForKey:@"volunteer_training"] boolValue] || [[event valueForKey:@"insurance"] boolValue]) {
        self.volunteerTrainButton.hidden = false;
    } else {
        self.volunteerTrainButton.hidden = true;
    }
    
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    // 鍵盤消失時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    
    CGSize sizeThatShouldFitTheContent = [self.eventDescription sizeThatFits:self.eventDescription.frame.size];
    
    self.descriptionHeight.constant = sizeThatShouldFitTheContent.height;
    
    _cooperationNpo.numberOfLines = 0;
    if (![self isEnterpriseEvent]){
        _cooperationNpoIcon.hidden = true;
    }else{
        if ([[event valueForKey:@"cooperation_NPO"] count] == 0){
            _cooperationNpoIcon.hidden = true;
        }else{
            NSArray *npoList = [event valueForKey:@"cooperation_NPO"];
            NSString *list = @"";
            for(int i = 0; i < npoList.count; i++){
                NSLog(@"XXX%d %@", i , list);
                if(i != 0){
                    list = [NSString stringWithFormat: @"%@、", list];
                }
                list = [NSString stringWithFormat: @"%@%@", list, [npoList[i] valueForKey:@"name"]];
            }
            _cooperationNpo.text = list;
            
        }
    }
    NSLog(@"cn sizea: %f", self.cooperationNpo.frame.size.height);
    [self.cooperationNpo sizeToFit];
    NSLog(@"cn sizeb: %f", self.cooperationNpo.frame.size.height);
//    CGRect rect = CGRectMake(self.infoBlock.frame.origin.x,
//                             self.infoBlock.frame.origin.y,
//                             self.infoBlock.frame.size.width,
//                             self.infoBlock.frame.size.height +
//                             self.cooperationNpo.frame.size.height);
//    self.infoBlock.frame = rect;
    NSLog(@"ib sizea: %f", self.infoBlock.frame.size.height);
    [self.infoBlock updateConstraints];
    NSLog(@"ib sizeb: %f", self.infoBlock.frame.size.height);
    
    
    self.scrollHeight.constant = [self measuredScrollContentHeight];
    
    [self initNPONameLabel];
//    self.infoBlock.backgroundColor = [UIColor redColor];
}

- (void)initNPONameLabel {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(npoNameDidTouched)];
    [self.npoName addGestureRecognizer: tap];
//    [self.npoName setText:@"QAQ"];
    [self.npoName setUserInteractionEnabled:YES];

}

-(void) npoNameDidTouched{
    NSLog(@"npoNameDidTouched");
    [self performSegueWithIdentifier:@"segueEventDetailToNpoDetail" sender:self];
}

- (void)viewDidAppear:(BOOL)animated {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    self.scrollWidth.constant = screenWidth;
    
    CGSize sizeThatShouldFitTheContent = [self.eventDescription sizeThatFits:self.eventDescription.frame.size];
    
    self.descriptionHeight.constant = sizeThatShouldFitTheContent.height;
    
    NSLog(@"ib sizea: %f", self.infoBlock.frame.size.height);
    [self.infoBlock updateConstraints];
    NSLog(@"ib sizeb: %f", self.infoBlock.frame.size.height);
    
    self.scrollHeight.constant = [self measuredScrollContentHeight];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (NSMutableDictionary *item in appDelegate.event) {
        if ([[item valueForKey:@"id"] intValue] == eventId) {
            event = item;
            break;
        }
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    
    if ([[event valueForKey:@"is_volunteer_event"] boolValue]) {
        self.joinGroup.placeholder = @"請選擇您的組別";
        [self.joinSkill setTitle:@"請選擇您的技能" forState:UIControlStateNormal];
        [self.joinSkill setTitle:@"請選擇您的技能" forState:UIControlStateSelected];
    } else {
        
        self.joinGroup.placeholder = @"請選擇皮卡丘的種類";
        [self.joinSkill setTitle:@"請選擇物資的描述" forState:UIControlStateNormal];
        [self.joinSkill setTitle:@"請選擇物資的描述" forState:UIControlStateSelected];
    }
    
    if (token == nil) {
        self.followOrNotButton.hidden = true;
        self.judgeButton.userInteractionEnabled = false;
        self.registButton.tag = 5;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *registDate = [dateFormat dateFromString:[event valueForKey:@"register_deadline_date"]];
        NSLog(@"registDate: %@, now: %@", registDate, [NSDate date]);
        if ([self daysBetweenDate:[NSDate date] andDate:registDate] > 0) {
            if ([[event valueForKey:@"is_volunteer_event"] boolValue]) {
                if ([self isFull]){
                    [self.registButton setTitle:@"已额满" forState:UIControlStateNormal];
                }else{
                    [self.registButton setTitle:@"我要報名" forState:UIControlStateNormal];
                    self.registButton.layer.cornerRadius = 15;
                }
            } else {
                if ([self isFull]){
                    [self.registButton setTitle:@"已被認捐" forState:UIControlStateNormal];
                }else{
                    [self.registButton setTitle:@"我要捐" forState:UIControlStateNormal];
                }
            }
            // require login
            self.registButton.tag = 5;
        } else {
            if ([[event valueForKey:@"is_volunteer_event"] boolValue]) {
                [self.registButton setTitle:@"報名截止" forState:UIControlStateNormal];
            } else {
                [self.registButton setTitle:@"受理截止" forState:UIControlStateNormal];
            }
            // disable button
            self.registButton.tag = 0;
        }
    } else {
    
        for (NSMutableDictionary *item in appDelegate.focused_event) {
            if ([[[item valueForKey:@"focused_event"] valueForKey:@"id"] intValue] == eventId) {
                [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
                self.followOrNotButton.tag = 1;
                break;
            }
        }
        int current_volunteer_number = [[event valueForKey:@"current_volunteer_number"] intValue];
        int required_volunteer_number = [[event valueForKey:@"required_volunteer_number"] intValue];
        int surplus = required_volunteer_number - current_volunteer_number;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *registDate = [dateFormat dateFromString:[event valueForKey:@"register_deadline_date"]];
        
        if ([self daysBetweenDate:[NSDate date] andDate:registDate] > 0) {
            if ([[event valueForKey:@"is_volunteer_event"] boolValue]) {
                if (surplus == 0) {
                    [self.registButton setTitle:@"已额满" forState:UIControlStateNormal];
                    // disable button
                    self.registButton.tag = 0;
                }else{
                    [self.registButton setTitle:@"我要報名" forState:UIControlStateNormal];
                    self.registButton.layer.cornerRadius = 15;

                    self.registButton.tag = 1;
                }
            } else {
                if ([self isFull]){
                    [self.registButton setTitle:@"已被認捐" forState:UIControlStateNormal];
                    
                    // disable button
                    self.registButton.tag = 0;
                }else{
                    [self.registButton setTitle:@"我要捐" forState:UIControlStateNormal];
                    self.registButton.tag = 1;
                }
            }
        } else {
            if ([[event valueForKey:@"is_volunteer_event"] boolValue]) {
                [self.registButton setTitle:@"報名截止" forState:UIControlStateNormal];
                self.registButton.tag = 0;
            } else {
                [self.registButton setTitle:@"活動截止" forState:UIControlStateNormal];
                self.registButton.tag = 0;
            }
        }
    
        for (NSMutableDictionary *item in appDelegate.registered_event) {
            if ([[[item valueForKey:@"registered_event"] valueForKey:@"id"] intValue] == eventId) {
                [self.followOrNotButton setImage:[UIImage imageNamed:@"regist"] forState:UIControlStateNormal];
                if ([[item valueForKey:@"isJoined"] boolValue]) {
                    NSDate *registDate = [dateFormat dateFromString:[event valueForKey:@"close_date"]];
                    if ([self daysBetweenDate:[NSDate date] andDate:registDate] < 0) {
                        [self.judgeButton setTitle:@"我要評分" forState:UIControlStateNormal];
                        self.judgeButton.userInteractionEnabled = true;
                    }
                    
                    isRegist = true;
                    if ([[event valueForKey:@"is_volunteer_event"] boolValue]) {
                        if ([[event valueForKey:@"require_signout"] boolValue] && ![[item valueForKey:@"isLeaved"] boolValue]) {
                            [self.registButton setTitle:@"我要簽退" forState:UIControlStateNormal];
                            self.registButton.tag = 3;
                        } else {
                            [self.registButton setTitle:@"完成活動" forState:UIControlStateNormal];
                            self.registButton.tag = 4;
                        }
                    } else {
                        [self.registButton setTitle:@"捐贈受理" forState:UIControlStateNormal];
                        self.registButton.tag = 4;
                    }
                } else {
                    NSDate *happenDate = [dateFormat dateFromString:[event valueForKey:@"happen_date"]];
                    if ([[event valueForKey:@"is_volunteer_event"] boolValue]) {
                        NSLog(@"id: %@",[event valueForKey:@"foreign_third_party_id"]  );
                    
                        if ([self daysBetweenDate:[NSDate date] andDate:happenDate] < 0) {
                            [self.registButton setTitle:@"我要報到" forState:UIControlStateNormal];
                            self.registButton.tag = 2;
                        } else {
                            [self.registButton setTitle:@"等候報到" forState:UIControlStateNormal];
                            self.registButton.tag = 4;
                        }
                        
                        // 沒超過報名截止時間我要取消
                        NSDate *registDate = [dateFormat dateFromString:[event valueForKey:@"register_deadline_date"]];
                        
                        if ([self daysBetweenDate:[NSDate date] andDate:registDate] > 0) {
                            self.cancelButton.hidden = false;
                            [self.cancelButton setTitle:@"我不能去了" forState:UIControlStateSelected];
                            [self.cancelButton setTitle:@"我不能去了" forState:UIControlStateNormal];
                        }
                        
                        if([[event valueForKey:@"foreign_third_party_id"] hasPrefix:@"TTVOLUNTEER|"]){
                            [self.registButton setTitle:@"確認中.." forState:UIControlStateNormal];
                            self.registButton.tag = 0;
                            self.cancelButton.hidden = YES;
                            [self queryTTVolunteerStatus];
                        }
                    } else {
                        // 沒超過報名截止時間我要取消
                        NSDate *registDate = [dateFormat dateFromString:[event valueForKey:@"register_deadline_date"]];
                        
                        if ([self daysBetweenDate:[NSDate date] andDate:registDate] > 0) {
                            [self.registButton setTitle:@"捐贈受理" forState:UIControlStateNormal];
                            self.registButton.tag = 4;
                            self.cancelButton.hidden = false;
                            [self.cancelButton setTitle:@"我不能捐了" forState:UIControlStateSelected];
                            [self.cancelButton setTitle:@"我不能捐了" forState:UIControlStateNormal];
                        }
                    }
                }
                break;
            }
        }
    }
    
    [_spinner startAnimating];
    
    NSString *urlLick = [NSString stringWithFormat:@"%@resources/%@", [WilloAPIV2 getImageUrlName], [event valueForKey:@"thumb_path"]];
    NSString *fileName = [[urlLick componentsSeparatedByString:@"/"] lastObject];
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [self.image sd_setImageWithURL:[NSURL URLWithString:urlLick]
                   placeholderImage:[UIImage imageNamed:fileName]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              [_spinner stopAnimating];
                          }];
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

-(void)keyboardWillShow:(NSNotification *) notification{
    NSDictionary* info = [notification userInfo];
    // kbSize即為鍵盤尺寸 (有width, height)
    keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    //再依據不同的高度 作不同的因應
    
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement;
    
    float shouldMove = keyboardSize.height;
    if (movementDistance - shouldMove >= 0) {
        movement = 0;
    } else {
        movement = movementDistance - shouldMove;
        movementDistance = shouldMove; // tweak as needed
    }
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

//鍵盤消失時則是加這個
- (void)keyboardWillHidden:(NSNotification*)aNotification{
    // something
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = movementDistance;
    movementDistance = 0;
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    /* keyboard is visible, move views */
    selectTextField = textField;
    
    const float movementDuration = 0.3f; // tweak as needed
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    int movement;
    float textFieldBottom = selectTextField.frame.origin.y + selectTextField.frame.size.height;
    float keyboardTop = screenHeight - keyboardSize.height;
    
    float shouldMove = textFieldBottom - keyboardTop + 50;
    if (movementDistance - shouldMove >= 0) {
        movement = 0;
    } else {
        movement = movementDistance - shouldMove;
        movementDistance = shouldMove; // tweak as needed
    }
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)dismissKeyboard {
    [self.joinGroup resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([skillGroupArray count] == 1) {
        self.joinGroup.text = [[skillGroupArray firstObject] valueForKey:@"name"];
        self.joinGroup.tag = [[[skillGroupArray firstObject] valueForKey:@"id"] integerValue];
    }
    return [skillGroupArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableDictionary *skillGroup = [skillGroupArray objectAtIndex:row];
    return [NSString stringWithFormat:@"需%d名：%@", [[skillGroup valueForKey:@"volunteer_number"] intValue] - [[skillGroup valueForKey:@"current_volunteer_number"] intValue], [skillGroup valueForKey:@"name"]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableDictionary *skillGroup = [skillGroupArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    if ([[skillGroup valueForKey:@"volunteer_number"] intValue] - [[skillGroup valueForKey:@"current_volunteer_number"] intValue] <= 0) {
        return;
    }
    self.joinGroup.text = [skillGroup valueForKey:@"name"];
    self.joinGroup.tag = [[skillGroup valueForKey:@"id"] intValue];
    groupDetail = [skillGroup valueForKey:@"skills_description"];
}

-(NSString *)translateTimeToLocaleZone:(NSString *)originTime hasMinSec:(BOOL)hasMicSec
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDateFormatter *dateOutFormat = [[NSDateFormatter alloc] init];
    if (hasMicSec) {
        [dateOutFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    } else {
        [dateOutFormat setDateFormat:@"yyyy/MM/dd"];
    }
    
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

-(CGFloat)measuredScrollContentHeight{
    CGFloat viewSize = [[self view] frame].size.height;
    NSLog(@"viewSize: %f", viewSize);
    CGFloat imageHeight = self.image.frame.size.height;
    CGFloat eventTitle = self.eventTitle.frame.size.height;
    CGFloat groupBlockHeight = 88;
    CGFloat registBlockHeight = 40;
    
    return self.scoreBlockHeight.constant +
    imageHeight +
    eventTitle +
    self.infoBlock.frame.size.height +
    self.descriptionHeight.constant +
    groupBlockHeight +
    registBlockHeight;
    
}

-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
//    [registDate compare:[NSDate date]] == NSOrderedDescending
    
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
//    NSInteger response = [difference day] * 24*60*60;
//    return response;
}

- (IBAction)doJudgeScore1:(id)sender {
    score = 1;
    [self.judgeScore1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore2 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    [self.judgeScore3 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    [self.judgeScore4 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    [self.judgeScore5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
}

- (IBAction)doJudgeScore2:(id)sender {
    score = 2;
    [self.judgeScore1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore2 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore3 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    [self.judgeScore4 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    [self.judgeScore5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
}

- (IBAction)doJudgeScore3:(id)sender {
    score = 3;
    [self.judgeScore1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore2 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore3 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore4 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    [self.judgeScore5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
}

- (IBAction)doJudgeScore4:(id)sender {
    score = 4;
    [self.judgeScore1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore2 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore3 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore4 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
}

- (IBAction)doJudgeScore5:(id)sender {
    score = 5;
    [self.judgeScore1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore2 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore3 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore4 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
    [self.judgeScore5 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
}

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doJudge:(id)sender {
    ((UIButton *)sender).userInteractionEnabled = NO;
    [WilloAPIV2 judgeEventWithUuid:[NSString stringWithFormat:@"%d", eventId] Score:[NSString stringWithFormat:@"%d", score] viewController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            
            [WilloAPIV2 getDump:^void(){
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                for (NSMutableDictionary *item in appDelegate.event) {
                    if ([[item valueForKey:@"id"] intValue] == eventId) {
                        event = item;
                        break;
                    }
                }
                float totalRatingScore = [[event valueForKey:@"total_rating_score"] floatValue];
                if (totalRatingScore >= 5) {
                    [self.score1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score2 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score3 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score4 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score5 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                } else if(totalRatingScore >= 4) {
                    [self.score1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score2 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score3 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score4 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                } else if(totalRatingScore >= 3) {
                    [self.score1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score2 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score3 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score4 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                    [self.score5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                } else if(totalRatingScore >= 2) {
                    [self.score1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score2 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score3 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                    [self.score4 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                    [self.score5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                } else if(totalRatingScore >= 1) {
                    [self.score1 setImage:[UIImage imageNamed:@"star_2"] forState:UIControlStateNormal];
                    [self.score2 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                    [self.score3 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                    [self.score4 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                    [self.score5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                } else if(totalRatingScore == 0) {
                    [self.score1 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                    [self.score2 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                    [self.score3 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                    [self.score4 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                    [self.score5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
                }
                self.judgeNum.text = [NSString stringWithFormat:@"%d", [[event valueForKey:@"rating_user_num"] intValue]];
                self.judgePanel.hidden = true;
                ((UIButton *)sender).userInteractionEnabled = YES;
            }];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);
        
        if (operation.response.statusCode == 400) {
            // 沒報名或 id 不合法
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"評分"
                                                            message:@"未報到"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            alert.tag = 2;
            [alert show];
        }
        ((UIButton *)sender).userInteractionEnabled = YES;
    }];
}

- (IBAction)showJudgePanel:(id)sender {
    score = 0;
    [self.judgeScore1 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    [self.judgeScore2 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    [self.judgeScore3 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    [self.judgeScore4 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];
    [self.judgeScore5 setImage:[UIImage imageNamed:@"star_0"] forState:UIControlStateNormal];

    self.judgePanel.hidden = false;
}

- (IBAction)hideJudgePanel:(id)sender {
    self.judgePanel.hidden = true;
}

- (IBAction)doFollowOrNot:(id)sender {
    if (self.followOrNotButton.tag == 0) {
        [self followEvent:sender];
    } else {
        [self unfollowEvent:sender];
    }
}

- (IBAction)doShare:(id)sender {
    NSString *register_deadline_date = [self translateTimeToLocaleZone:[event valueForKey:@"register_deadline_date"] hasMinSec:true];
    NSString *happen_date = [self translateTimeToLocaleZone:[event valueForKey:@"happen_date"] hasMinSec:true];
    NSString *close_date = [self translateTimeToLocaleZone:[event valueForKey:@"close_date"] hasMinSec:true];
    
    int current_volunteer_number = [[event valueForKey:@"current_volunteer_number"] intValue];
    int required_volunteer_number = [[event valueForKey:@"required_volunteer_number"] intValue];
    
    NSString *data = [NSString stringWithFormat:@"%@event/%d/\n%@\n舉辦：%@\n報名截止：%@\n活動開始：%@\n活動結束：%@\n活動地點：%@%@\n尚缺 %d 名 / 共需 %d 名\n服務 %d 小時\n\n- 分享自微樂志工 %@\n", [WilloAPIV2 getHostName], eventId, [event valueForKey:@"subject"],
                      [[event valueForKey:@"owner_NPO"] valueForKey:@"name"],
                      register_deadline_date,
                      happen_date,
                      close_date,
                      [event valueForKey:@"address_city"], [event valueForKey:@"address"],
                      current_volunteer_number,
                      required_volunteer_number,
                      [[event valueForKey:@"event_hour"] intValue],
                      @"https://www.isharing.tw"
                      ];
    
    
    
    NSString *photo_link = [[WilloAPIV2 getUploadDir] stringByAppendingString:[event valueForKey:@"thumb_path"]];
    
    UIImage *image;
    if ([photo_link length] != 0) {
        NSArray *fileTypeArray = [photo_link componentsSeparatedByString:@"."];
        NSString *fileType = fileTypeArray[[fileTypeArray count] - 1];
        NSString *fileName = [NSString stringWithFormat:@"Caches/PK_%d.%@", eventId, fileType];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
        
        // log dir
        // For error information
        NSError *error;
        
        // Create file manager
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        // Show contents of Documents directory
        NSLog(@"Documents directory: %@",
              [fileMgr contentsOfDirectoryAtPath:[paths objectAtIndex:0] error:&error]);
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
        if (fileExists) {
            // set image
            image = [UIImage imageWithContentsOfFile:path];
        } else {
            // set default image
            image = [UIImage imageNamed:@"event_default.png"];
        }
    } else {
        // set default image
        image = [UIImage imageNamed:@"event_default.png"];
        
    }
    
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:data, image, nil] applicationActivities:nil];
    //activityVC.excludedActivityTypes = @[UIActivityTypeMessage , UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    NSString *subject;
    
    if (token == nil) {
        subject = [NSString stringWithFormat:@"%@", [event valueForKey:@"subject"]];
    } else {
        subject = [NSString stringWithFormat:@"%@與您分享＜微樂志工＞%@", [appDelegate.user valueForKey:@"name"], [event valueForKey:@"subject"]];
    }
    [activityVC setValue:subject forKey:@"subject"];
    [self presentViewController:activityVC animated:YES completion:nil];
    
}

- (IBAction)shareToLine:(id)sender {
    
    NSString *register_deadline_date = [self translateTimeToLocaleZone:[event valueForKey:@"register_deadline_date"] hasMinSec:true];
    NSString *happen_date = [self translateTimeToLocaleZone:[event valueForKey:@"happen_date"] hasMinSec:true];
    NSString *close_date = [self translateTimeToLocaleZone:[event valueForKey:@"close_date"] hasMinSec:true];
    
    int current_volunteer_number = [[event valueForKey:@"current_volunteer_number"] intValue];
    int required_volunteer_number = [[event valueForKey:@"required_volunteer_number"] intValue];
    
    NSString *data = [NSString stringWithFormat:@"%@event/%d/\n%@\n舉辦：%@\n報名截止：%@\n活動開始：%@\n活動結束：%@\n活動地點：%@%@\n尚缺 %d 名 / 共需 %d 名\n服務 %d 小時\n\n- 分享自微樂志工 %@\n", [WilloAPIV2 getHostName], eventId, [event valueForKey:@"subject"],
                      [[event valueForKey:@"owner_NPO"] valueForKey:@"name"],
                      register_deadline_date,
                      happen_date,
                      close_date,
                      [event valueForKey:@"address_city"], [event valueForKey:@"address"],
                      current_volunteer_number,
                      required_volunteer_number,
                      [[event valueForKey:@"event_hour"] intValue],
                      @"https://www.isharing.tw"
                      ];
    
    NSString *lineUrl = [[NSString stringWithFormat:@"line://msg/text/%@", data] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *appURL = [NSURL URLWithString:lineUrl];
    if ([[UIApplication sharedApplication] canOpenURL: appURL]) {
        [[UIApplication sharedApplication] openURL: appURL];
    }
    else { //如果使用者沒有安裝，連結到App Store
        NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id443904275"];
        [[UIApplication sharedApplication] openURL:itunesURL];
    }

}

- (IBAction)doRegist:(id)sender {
//    int current_volunteer_number = [[event valueForKey:@"current_volunteer_number"] intValue];
//    int required_volunteer_number = [[event valueForKey:@"required_volunteer_number"] intValue];
//    int surplus = required_volunteer_number - current_volunteer_number;
//
//    if (surplus == 0) {
//        [self.view makeToast:@"活动已额满" duration:2.0 position:@"CSToastPositionCenter"];
//        return;
//    }
    UIButton *btn = sender;
    if (btn.tag == 1) {
        // 報名
        if ([[event valueForKey:@"required_group"] boolValue]) {
            if(self.joinGroup.tag == 0) {
                if ([[event valueForKey:@"is_volunteer_event"] boolValue]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"報名"
                                                                    message:@"請先選擇活動組別"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    alert.tag = 2;
                    [alert show];
                    return;
                }
//                else {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"報名"
//                                                                    message:@"請先選擇物資種類"
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"OK"
//                                                          otherButtonTitles:nil];
//                    alert.tag = 2;
//                    [alert show];
//                    return;
//                }
            }
        }
        
        [self performSegueWithIdentifier:@"segueEventDetailToRegistEvent" sender:sender];
    } else if (btn.tag == 2) {
        // 簽到
        [self performSegueWithIdentifier:@"segueEventDetailToBarCodeScanner" sender:sender];
    } else if (btn.tag == 3) {
        // 簽退
        [self performSegueWithIdentifier:@"segueEventDetailToBarCodeScanner" sender:sender];
    } else if (btn.tag == 5) {
        // 登入
        [self performSegueWithIdentifier:@"segueEventDetailToLogin" sender:sender];
    } else {
        return;
    }
}

UIButton * cancelSender = nil;
- (void)cancelEvent:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"是否確認取消"
                                                   delegate:self
                                          cancelButtonTitle:@"是"
                                          otherButtonTitles:@"否", nil];
    alert.tag = TAG_CANCEL_ALERT_DIALAG;
    cancelSender = sender;
    [alert show];
    
}

- (void)realCancelEvent:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WilloAPIV2 cancelRegistById:[NSString stringWithFormat:@"%d", self.eventId] viewController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            [WilloAPIV2 getDump:^(){
                self.cancelButton.hidden = true;
                if ([[event valueForKey:@"is_volunteer_event"] boolValue]) {
                    if ([self isFull]){
                        [self.registButton setTitle:@"已额满" forState:UIControlStateNormal];
                    }else{
                        [self.registButton setTitle:@"我要報名" forState:UIControlStateNormal];
                        self.registButton.layer.cornerRadius = 15;

                    }
                } else {
                    
                    if ([self isFull]){
                        [self.registButton setTitle:@"已被認捐" forState:UIControlStateNormal];
                    }else{
                        [self.registButton setTitle:@"我要捐" forState:UIControlStateNormal];
                    }
                }
                self.registButton.tag = 1;
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    // Do something...
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        NSString *message;
                        if ([[event valueForKey:@"is_volunteer_event"] boolValue]) {
                            message = @"已取消報名";
                        } else {
                            message = @"已取消認捐";
                        }
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:message
                                                                       delegate:self
                                                              cancelButtonTitle:@"是"
                                                              otherButtonTitles:nil];
                        alert.tag = 0;
                        [alert show];
                        
                    });
                });
                sender.userInteractionEnabled = YES;
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);

        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        sender.userInteractionEnabled = YES;
    }];
}


- (IBAction)doCancel:(id)sender {
    // 超過報名截止時間不可取消
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *registDate = [dateFormat dateFromString:[event valueForKey:@"register_deadline_date"]];
    
    if ([self daysBetweenDate:[NSDate date] andDate:registDate] < 0) {
        return;
    }
    
    [self cancelEvent:sender];
}

- (void)queryTTVolunteerStatus
{
    
    [WilloAPIV2 queryTTVolunteerRegisterStatusById:[NSString stringWithFormat:@"%d", self.eventId] viewController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            NSData * data = (NSData *)responseObject;
            NSString * string = [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
            NSString *fullObj = [NSString stringWithFormat:@"{\"s\":%@}", string];
            NSData *objectData = [fullObj dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:NULL];
            NSString *result = [dic valueForKey:@"s"];
            NSLog(@"response: %@", result);
            [self.registButton setTitle:result forState:UIControlStateNormal];
//            self.followOrNotButton.tag = 1;
//            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
//            [WilloAPIV2 getDump:nil];
        }
//        sender.userInteractionEnabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);
        if (operation.response.statusCode == 400) {
//            self.followOrNotButton.tag = 1;
//            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        }
//        sender.userInteractionEnabled = YES;
    }];
    
}

- (void)followEvent:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    [WilloAPIV2 focusById:[NSString stringWithFormat:@"%d", self.eventId] viewController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            self.followOrNotButton.tag = 1;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
            [WilloAPIV2 getDump:nil];
        }
        sender.userInteractionEnabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);
        if (operation.response.statusCode == 400) {
            self.followOrNotButton.tag = 1;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        }
        sender.userInteractionEnabled = YES;
    }];
}

- (void)unfollowEvent:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    
    [WilloAPIV2 unfocusById:[NSString stringWithFormat:@"%d", self.eventId] viewController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            self.followOrNotButton.tag = 0;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
            [WilloAPIV2 getDump:nil];
        }
        sender.userInteractionEnabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);
        if (operation.response.statusCode == 400) {
            self.followOrNotButton.tag = 0;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
        }
        sender.userInteractionEnabled = YES;
    }];
}

- (void)addItemViewController:(EditSkillStringViewController *)controller didFinishEnteringItem:(NSString *)item
{
    skills = [item componentsSeparatedByString:@","];
}

- (void)showGroupDetail
{
    if (groupDetail == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"組別說明"
                                                        message:@"未選擇組別"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.joinGroup.text
                                                        message:groupDetail
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (bool) isFull{
    if ([[event valueForKey:@"required_group"] boolValue]) {
        for (NSMutableDictionary *skill in [event valueForKey:@"skill_groups"]) {
            if ([[skill valueForKey:@"volunteer_number"] intValue] - [[skill valueForKey:@"current_volunteer_number"]intValue] > 0)
            {
                return NO;
            }
        }
        return YES;
    }else{
        int current_volunteer_number = [[event valueForKey:@"current_volunteer_number"] intValue];
        int required_volunteer_number = [[event valueForKey:@"required_volunteer_number"] intValue];
        if ( required_volunteer_number <= current_volunteer_number){
            return YES;
        }
        return NO;
    }
    
}

- (bool) isEnterpriseEvent{
    return [[[event valueForKey:@"owner_NPO"] valueForKey:@"is_enterprise"] boolValue];
}

- (bool) isResourceEvent{
    return ![[event valueForKey:@"is_volunteer_event"] boolValue];
}
//FIH-add for 有勾需要保險資料 start
- (bool) isInsuranceEvent{
    return [[event valueForKey:@"insurance"] boolValue];
}
//FIH-add for 有勾需要保險資料 end

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueEventDetailToVolunteerNotice"]) {
        VolunteerNoticeViewController *destViewController = segue.destinationViewController;
        
        if ([[event valueForKey:@"insurance"] boolValue]) {
            destViewController.description = [NSString stringWithFormat:@"%@\n\n==========保險說明==========\n\n%@", [event valueForKey:@"volunteer_training_description"], [event valueForKey:@"insurance_description"]];
        } else {
            destViewController.description = [NSString stringWithFormat:@"%@", [event valueForKey:@"volunteer_training_description"]];
        }
    } else if([segue.identifier isEqualToString:@"segueEventDetailToEventResult"]) {
        NSLog(@"segueEventDetailToEventResult");
        EventResultViewController *destViewController = segue.destinationViewController;
        destViewController.eventId = eventId;
        destViewController.event = event;
    } else if ([segue.identifier isEqualToString:@"segueEventDetailToImageDetail"]) {
        ImageDetailViewController *destViewController = segue.destinationViewController;
        destViewController.image = self.image.image;
    } else if ([segue.identifier isEqualToString:@"segueEventDetailToRegistEvent"]) {
        RegistEventViewController *destViewController = segue.destinationViewController;
        destViewController.eventId = eventId;
        destViewController.event = event;
        if ([[event valueForKey:@"required_group"] boolValue]) {
            destViewController.skill_pk = (int)self.joinGroup.tag;
        } else {
            destViewController.skill_pk = -1;

            if (skills.count == 0) {
                destViewController.skills = nil;
            } else if(skills.count == 1) {
                destViewController.skills = skills[0];
            } else {
                NSMutableString *itemToPassBack = [[NSMutableString alloc] initWithString:skills[0]];
                for (int i = 1; i < skills.count; i++) {
                    [itemToPassBack appendFormat:@",%@", skills[i]];
                }
                destViewController.skills = itemToPassBack;
            }
        }
        destViewController.isEnterprise = [self isEnterpriseEvent];
        destViewController.isResourceEvent = [self isResourceEvent];
        destViewController.isInsuranceEvent = [self isInsuranceEvent];//FIH-add for 有勾需要保險資料 

    } else if ([segue.identifier isEqualToString:@"segueEventDetailToBarCodeScanner"]) {
        BarCodeScannerViewController *destViewController = segue.destinationViewController;
        
        destViewController.event = event;
        if(self.registButton.tag == 3) {
            destViewController.isJoined = true;
        } else {
            destViewController.isJoined = false;
        }
    } else if([segue.identifier isEqualToString:@"segeuEventDetailToEditSkillString"]) {
        EditSkillStringViewController *destViewController = segue.destinationViewController;
        destViewController.delegate = self;
        destViewController.skillDescription = [event valueForKey:@"skills_description"];
        destViewController.skills = [NSMutableArray arrayWithArray:skills];
    } else if([segue.identifier isEqualToString:@"segueEventDetailToNpoDetail"]) {
        NpoDetailViewController *destViewController = segue.destinationViewController;
        destViewController.npo = [event valueForKey:@"owner_NPO"];
        destViewController.npoId = [[[event valueForKey:@"owner_NPO"] valueForKey:@"id"] intValue];
    }
        
        
        
}

- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == TAG_CANCEL_ALERT_DIALAG){
        switch (buttonIndex) {
            case 0:
                // 是
                
                [self realCancelEvent:cancelSender];
                break;
            case 1:
                // 否
                
            default:
                break;
        }
    }
}
- (CGFloat)textHeightFontSize:(CGFloat)fontSize lablew:(float)ww textString:(NSString *)string{
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ww, MAXFLOAT)];
    lable.text = string;
    lable.font = [UIFont systemFontOfSize:fontSize];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.numberOfLines = 0;
    [lable sizeToFit];
    float hh = lable.frame.size.height;
    lable = nil;
    return hh;

}

@end
