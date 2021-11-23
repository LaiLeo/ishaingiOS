//
//  UserProfileViewController.h
//  volunteers
//
//  Created by jauyou on 2015/2/3.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController
@property NSDictionary *profile;
@property BOOL isEditable;
@property (strong,nonatomic)UILabel *userName;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *userScore;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UILabel *totalHour;
@property (weak, nonatomic) IBOutlet UILabel *totalEvent;
@property (weak, nonatomic) IBOutlet UILabel *volunteerRanking;
@property (weak, nonatomic) IBOutlet UITextView *aboutMe;
@property (weak, nonatomic) IBOutlet UIView *registedEventButton;
@property (weak, nonatomic) IBOutlet UIView *joinedEventButton;
@property (weak, nonatomic) IBOutlet UIView *registedResourceButton;
@property (weak, nonatomic) IBOutlet UIView *followedEventButton;
@property (weak, nonatomic) IBOutlet UIView *followedItemButton;
@property (weak, nonatomic) IBOutlet UIView *followedNpoButton;
@property (weak, nonatomic) IBOutlet UIView *advanceSearchButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeight;

- (IBAction)doDismiss:(id)sender;

    
- (IBAction)showServiceArea:(id)sender;
- (IBAction)showServiceItem:(id)sender;
- (IBAction)showFastJoin:(id)sender;
- (IBAction)showUnregistEvent:(id)sender;
- (IBAction)showJoinedEvent:(id)sender;
- (IBAction)showFollowedEvent:(id)sender;
- (IBAction)showAllResource:(id)sender;
- (IBAction)showFollowedResource:(id)sender;
- (IBAction)showFollowedNpo:(id)sender;
- (IBAction)showScoreMsg:(id)sender;
- (IBAction)showAdvanceSearch:(id)sender;
- (IBAction)showLicense:(id)sender;


@end
