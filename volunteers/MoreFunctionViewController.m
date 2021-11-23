//
//  MoreFunctionViewController.m
//  volunteers
//
//  Created by jauyou on 2015/1/31.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import "MoreFunctionViewController.h"
#import "AboutUsViewController.h"
#import "TermsViewController.h"
#import "WilloAPIV2.h"
#import <Masonry/Masonry.h> 

@interface MoreFunctionViewController ()

@end

@implementation MoreFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton *partnerButton = [[UIButton alloc]init];
//    [self.view addSubview:partnerButton];
//    [partnerButton setImage:[UIImage imageNamed:@"judge_partner"] forState:UIControlStateNormal];
//    [partnerButton setTitle:@"成為夥伴"forState:0];
//    partnerButton.titleLabel.font = [UIFont systemFontOfSize:18];
//    [partnerButton setTitleColor:[UIColor blackColor] forState:0];
//    partnerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    partnerButton.imageEdgeInsets = UIEdgeInsetsMake(0,12, 0, 0);
//    partnerButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
//    partnerButton.layer.masksToBounds = YES;
//    partnerButton.layer.borderColor = [UIColor colorWithRed:236.0/255.0 green:108/255.0 blue:0.0 alpha:1.0].CGColor;
//    partnerButton.layer.borderWidth = 1.2;
//    [partnerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.loginButton.mas_bottom).offset(0);
//        make.left.equalTo(self.loginButton.mas_left).offset(0);
//        make.width.equalTo(self.view);
//        make.height.mas_equalTo(44);
//    }];
//    [partnerButton addTarget:self action:@selector(partner) forControlEvents:UIControlEventTouchUpInside];

}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    if (token != nil) {
        [self.loginButton setTitle:@"登出" forState:UIControlStateNormal];
        [self.loginButton setTitle:@"登出" forState:UIControlStateSelected];
        [self.loginButton setImage:[UIImage imageNamed:@"logout_icon"] forState:UIControlStateNormal];
        [self.loginButton setImage:[UIImage imageNamed:@"logout_icon"] forState:UIControlStateSelected];
    } else {
        [self.loginButton setTitle:@"登入" forState:UIControlStateNormal];
        [self.loginButton setTitle:@"登入" forState:UIControlStateSelected];
        [self.loginButton setImage:[UIImage imageNamed:@"login_icon"] forState:UIControlStateNormal];
        [self.loginButton setImage:[UIImage imageNamed:@"login_icon"] forState:UIControlStateSelected];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)gotoQA:(id)sender {
    NSString *url = @"https://www.isharing.tw/faq/plain/";
    NSString *encodeUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodeUrl]];
}

- (IBAction)doLogin:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    
    if (token != nil) {
        [self.loginButton setTitle:@"登入" forState:UIControlStateNormal];
        [self.loginButton setTitle:@"登入" forState:UIControlStateSelected];
        [self.loginButton setImage:[UIImage imageNamed:@"login_icon"] forState:UIControlStateNormal];
        [self.loginButton setImage:[UIImage imageNamed:@"login_icon"] forState:UIControlStateSelected];
        [userDefaults removeObjectForKey:@"token"];
        [userDefaults synchronize];
    } else {
        [self performSegueWithIdentifier:@"segueMoreFunctionToLogin" sender:self];
    }
}

- (IBAction)gotoJudge:(id)sender {
    NSString *url = @"https://itunes.apple.com/tw/app/wei-le-zhi-gong/id823341128?l=zh&mt=8";
    NSString *encodeUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodeUrl]];
}

- (IBAction)gotoFacebookFanPage:(id)sender {
    NSString *url = @"https://www.facebook.com/isharing.tw/";
    NSString *encodeUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodeUrl]];
}

- (IBAction)becomePartner:(id)sender {
    NSString *url = @"https://www.isharing.tw/join/";
    NSString *encodeUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodeUrl]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"segueMoreFunctionToAboutUs"]) {
//        AboutUsViewController *aboutUsVC = (AboutUsViewController *)segue.destinationViewController;
//
//    } else if ([segue.identifier isEqualToString:@"segueMoreFunctionToTerms"]) {
//        TermsViewController *termsVC = segue.destinationViewController;
//    }
//}
@end
