//
//  AdvanceSearchViewController.h
//  volunteers
//
//  Created by Pichu Chen on 平成28/9/11.
//  Copyright © 平成28年 taiwanmobile. All rights reserved.
//

#ifndef AdvanceSearchViewController_h
#define AdvanceSearchViewController_h
#import <UIKit/UIKit.h>

@interface AdvanceSearchViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property NSDictionary *profile;
@property BOOL isEditable;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *userScore;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@property (weak, nonatomic) IBOutlet UIView *startYearButton;
@property (weak, nonatomic) IBOutlet UIView *endYearButton;

@property (weak, nonatomic) IBOutlet UILabel *startYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *endYearLabel;

@property (weak, nonatomic) IBOutlet UIView *searchButton;
@property (weak, nonatomic) IBOutlet UIView *generalVolunteerHourView;
@property (weak, nonatomic) IBOutlet UIView *enterpriseVolunteerHourView;
@property (weak, nonatomic) IBOutlet UIView *totalVolunteerHourView;

@property (weak, nonatomic) IBOutlet UILabel *generalVolunteerHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterpriseVolunteerHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalVolunteerHourLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeight;

- (void)initPickerArray;
- (void)showPicker:(NSString *)title withValue:(NSInteger) value completion:(void (^)(void))completion;
- (NSInteger)getNowYear;


- (IBAction)doDismiss:(id)sender;
- (IBAction)showStartYearPicker:(id)sender;
- (IBAction)showEndYearPicker:(id)sender;
- (IBAction)calculateVolunteerHours:(id)sender;



@end

#endif /* AdvanceSearchViewController_h */
