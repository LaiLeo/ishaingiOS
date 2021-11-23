//
//  SettingViewController.h
//  volunteers
//
//  Created by jauyou on 2015/2/3.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *notificationText;
@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)doDismiss:(id)sender;
- (IBAction)changeSlider:(id)sender;
@end
