//
//  SettingViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/3.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
{
    NSString *chooseString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *first = [defaults objectForKey:@"first"];
    if (first == nil) {
        [defaults setObject:@"TRUE" forKey:@"first"];
        [defaults setObject:@"1.9" forKey:@"notifyTime"];
        [defaults synchronize];
        chooseString = @"1.9";
        _slider.value = 1.9;
    } else {
    
        chooseString = [defaults objectForKey:@"notifyTime"];
    
        _slider.value = [chooseString floatValue];
    }
    [self showText];
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

- (IBAction)doDismiss:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:chooseString forKey:@"notifyTime"];
    [defaults synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)changeSlider:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    chooseString = [NSString stringWithFormat:@"%f", slider.value];
    if (slider.value == 0) {
        _notificationText.text = @"不提醒";
    } else if(slider.value < 1){
        _notificationText.text = @"1 小時";
    } else if(slider.value < 2){
        _notificationText.text = @"24 小時";
    } else {
        _notificationText.text = @"48 小時";
    }
}

- (void)showText
{
    if (_slider.value == 0) {
        _notificationText.text = @"不提醒";
    } else if(_slider.value < 1){
        _notificationText.text = @"1 小時";
    } else if(_slider.value < 2){
        _notificationText.text = @"24 小時";
    } else {
        _notificationText.text = @"48 小時";
    }
}
@end
