//
//  MoreFunctionViewController.h
//  volunteers
//
//  Created by jauyou on 2015/1/31.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreFunctionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)doDismiss:(id)sender;
- (IBAction)gotoQA:(id)sender;
- (IBAction)doLogin:(id)sender;
- (IBAction)gotoJudge:(id)sender;
- (IBAction)gotoFacebookFanPage:(id)sender;
- (IBAction)becomePartner:(id)sender;
@end
