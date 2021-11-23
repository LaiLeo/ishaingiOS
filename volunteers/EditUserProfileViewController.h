//
//  EditUserProfileViewController.h
//  volunteers
//
//  Created by jauyou on 2015/2/5.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUserProfileViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UISwitch *isPublic;
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *changePassword;
@property (weak, nonatomic) IBOutlet UITextField *changePasswordConfirm;//新密码确认
@property (weak, nonatomic) IBOutlet UITextField *aboutMe;
@property (weak, nonatomic) IBOutlet UITextField *skillList;
@property (weak, nonatomic) IBOutlet UITextField *habitList;
@property (strong,nonatomic)UIScrollView *baseView;
@property (strong,nonatomic)UIImageView *userHeadIcon;
@property (strong,nonatomic)UITextField *realName;
@property (strong,nonatomic)UITextField *phoneNumber;
@property (nonatomic,strong) UISwitch *publicSwitch;
@property (strong,nonatomic)UITextField *aboutMeNew;
@property (strong,nonatomic)UITextField *areaList;
@property (strong,nonatomic)UITextField *serviceList;
@property (strong,nonatomic)UITextField *picture;
@property (strong,nonatomic) UITextField *oldP;
@property (strong,nonatomic) UITextField *passWord;
@property (strong,nonatomic) UITextField *confireP;

@property(strong,nonatomic)UILabel *fubonTitle;
//@property(strong,)
- (IBAction)doDismiss:(id)sender;
- (IBAction)choosePicFromMedia:(id)sender;
- (IBAction)updateUserProfile:(id)sender;
@end
