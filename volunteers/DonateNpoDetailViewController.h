//
//  DonateNpoDetailViewController.h
//  volunteers
//
//  Created by jauyou on 2015/3/6.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonateNpoDetailViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *voiceView;
@property (weak, nonatomic) IBOutlet UIView *choiceView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *denateNpoDescription;
@property (weak, nonatomic) IBOutlet UITextField *donatePrice;
@property (weak, nonatomic) IBOutlet UIView *donateSelectBlock;
@property NSMutableDictionary *donateNpo;
- (IBAction)doDismiss:(id)sender;
- (IBAction)callForDonate:(id)sender;
- (IBAction)showMoreInfo:(id)sender;
- (IBAction)showPhoneDonateBlock:(id)sender;
- (IBAction)callForNewEBPay:(id)sender;




@end
