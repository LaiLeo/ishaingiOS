//
//  EventDetailViewController.h
//  volunteers
//
//  Created by jauyou on 2015/2/2.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditSkillStringViewController.h"

@interface EventDetailViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, EditSkillStringViewControllerDelegate>
@property UIView *inputAccView;
@property UIButton *btnGroupDetial;
@property int eventId;
@property NSMutableDictionary *event;
@property NSArray *skills;
@property (weak, nonatomic) IBOutlet UIButton *judgeButton;
@property (weak, nonatomic) IBOutlet UIButton *score1;
@property (weak, nonatomic) IBOutlet UIButton *score2;
@property (weak, nonatomic) IBOutlet UIButton *score3;
@property (weak, nonatomic) IBOutlet UIButton *score4;
@property (weak, nonatomic) IBOutlet UIButton *score5;
@property (weak, nonatomic) IBOutlet UILabel *judgeNum;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *npoName;
@property (weak, nonatomic) IBOutlet UILabel *registTime;
@property (weak, nonatomic) IBOutlet UILabel *registTimeCount;
@property (weak, nonatomic) IBOutlet UILabel *beginTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *registLocation;
@property (weak, nonatomic) IBOutlet UILabel *volunteerNeed;
@property (weak, nonatomic) IBOutlet UIImageView *volunteerTimeIcon;
@property (weak, nonatomic) IBOutlet UILabel *voluteerTime;
@property (weak, nonatomic) IBOutlet UILabel *cooperationNpo;

@property (weak, nonatomic) IBOutlet UITextView *eventDescription;
@property (weak, nonatomic) IBOutlet UIButton *volunteerTrainButton;
@property (weak, nonatomic) IBOutlet UIButton *followOrNotButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *eventResultButton;

@property (weak, nonatomic) IBOutlet UIView *judgePanel;
@property (weak, nonatomic) IBOutlet UIButton *judgeScore1;
@property (weak, nonatomic) IBOutlet UIButton *judgeScore2;
@property (weak, nonatomic) IBOutlet UIButton *judgeScore3;
@property (weak, nonatomic) IBOutlet UIButton *judgeScore4;
@property (weak, nonatomic) IBOutlet UIButton *judgeScore5;

@property (weak, nonatomic) IBOutlet UITextField *joinGroup;
@property (weak, nonatomic) IBOutlet UIButton *joinSkill;
@property (weak, nonatomic) IBOutlet UIView *scoreBlock;
@property (weak, nonatomic) IBOutlet UIView *infoBlock;
@property (weak, nonatomic) IBOutlet UIImageView *volunteerImage;

@property (weak, nonatomic) IBOutlet UIImageView *volunteerTimeImage;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreBlockHeight;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoBlockHeight;
@property (strong,nonatomic)UIImageView *startTimeImage;//活动开始时间
@property (strong,nonatomic)UILabel *startTimeLabel;//活动开始时间
@property (strong,nonatomic)UILabel *endTimeLabel;//活动结束时间
@property (strong,nonatomic)UIImageView *endTimeImage;//活动结束时间
@property (strong,nonatomic)UILabel *surplusLabel;//倒数时间
@property (strong,nonatomic)UIImageView *addressImage;//地址
@property (strong,nonatomic)UILabel *addressLabel;//地址
@property (strong,nonatomic)UILabel *demandNumberLabel;//志工需求
@property (strong,nonatomic)UIImageView *demandNumberImage;//志工需求
@property (strong,nonatomic)UILabel *typeLabel;//活动类型
@property (strong,nonatomic)UIImageView *typeImage;//活动类型
@property (strong,nonatomic)UILabel *organizerLabel;//主办单位
@property (strong,nonatomic)UIImageView *organizerImage;//主办单位
@property (strong,nonatomic)UILabel *numberLabel;//尚缺
@property (strong,nonatomic)UIImageView *numberImage;//尚缺
@property (strong,nonatomic)UILabel *serviceLabel;//服务时间
@property (strong,nonatomic)UIImageView *serviceImage;//服务时间
@property (strong,nonatomic)UIView *lineDashView;//物资需求
@property (strong,nonatomic)UILabel *demandLabel;//物资需求
@property (strong,nonatomic)UIImageView *demandImage;//物资需求
@property (strong,nonatomic)UILabel *demandContent;//物资需求

@property (weak, nonatomic) IBOutlet UIView *cooperationNpoIcon;

- (IBAction)doJudgeScore1:(id)sender;
- (IBAction)doJudgeScore2:(id)sender;
- (IBAction)doJudgeScore3:(id)sender;
- (IBAction)doJudgeScore4:(id)sender;
- (IBAction)doJudgeScore5:(id)sender;

- (IBAction)doDismiss:(id)sender;
- (IBAction)doJudge:(id)sender;
- (IBAction)showJudgePanel:(id)sender;
- (IBAction)hideJudgePanel:(id)sender;
- (IBAction)doFollowOrNot:(id)sender;
- (IBAction)doShare:(id)sender;
- (IBAction)shareToLine:(id)sender;
- (IBAction)doRegist:(id)sender;
- (IBAction)doCancel:(id)sender;

@end
