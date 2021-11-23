//
//  PrivacyViewController.m
//  volunteers
//
//  Created by Volodymyr Andriychenko on 2020/12/17.
//  Copyright © 2020 taiwanmobile. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()

@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma mark - Outlet methods

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
