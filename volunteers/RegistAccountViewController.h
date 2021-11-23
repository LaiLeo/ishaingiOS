//
//  RegistAccountViewController.h
//  volunteers
//
//  Created by jauyou on 2015/1/31.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistAccountViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *fubonAccount;
@property(nonatomic,copy)NSString *accessCode;

- (IBAction)buttonClicked:(id)sender;
- (IBAction)registAccount:(id)sender;
- (IBAction)doDismiss:(id)sender;
@end
