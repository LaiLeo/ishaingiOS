//
//  ForgetPasswordViewController.h
//  volunteers
//
//  Created by jauyou on 2015/1/30.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *account;
- (IBAction)doDismiss:(id)sender;
- (IBAction)doSubmit:(id)sender;

@end
