//
//  VolunteerNpoCollectionViewCell.m
//  volunteers
//
//  Created by jauyou on 2015/1/28.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import "TabBarUpdateProtocol.h"
#import "VolunteerNpoCollectionViewCell.h"
#import "WilloAPIV2.h"

@implementation VolunteerNpoCollectionViewCell
{
    int npoId;
    UIActivityIndicatorView *spinner;
    UIViewController *viewController;
}
@synthesize npoId;
@synthesize spinner;
@synthesize viewController;

- (IBAction)followOrNot:(id)sender {
    if (self.followOrNotButton.tag == 0) {
        [self followNpo:sender];
    } else {
        [self unfollowNpo:sender];
    }
}

- (void)followNpo:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    [WilloAPIV2 subscribeById:[NSString stringWithFormat:@"%d", npoId] viewController:viewController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            self.followOrNotButton.tag = 1;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
            self.followNum.text = [NSString stringWithFormat:@"%d 人", [self.followNum.text intValue] + 1];
            [WilloAPIV2 getDump:^void(){
                [(UIViewController<TabBarUpdateProtocol> *)viewController reloadFocus];
            }];        }
        sender.userInteractionEnabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);
        if (operation.response.statusCode == 400) {
            self.followOrNotButton.tag = 1;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
            self.followNum.text = [NSString stringWithFormat:@"%d 人", [self.followNum.text intValue] + 1];
        }
        
        if (operation.error.code == 401){
            // token 已過期
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
        }
        sender.userInteractionEnabled = YES;
    }];
}

- (void)unfollowNpo:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    
    [WilloAPIV2 unsubscribeById:[NSString stringWithFormat:@"%d", npoId] viewController:viewController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            self.followOrNotButton.tag = 0;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
            self.followNum.text = [NSString stringWithFormat:@"%d 人", [self.followNum.text intValue] - 1];
            [WilloAPIV2 getDump:^void(){
                [(UIViewController<TabBarUpdateProtocol> *)viewController reloadFocus];
            }];
        }
        sender.userInteractionEnabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);
        if (operation.error.code == 400) {
            self.followOrNotButton.tag = 0;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
            self.followNum.text = [NSString stringWithFormat:@"%d 人", [self.followNum.text intValue] - 1];
        }
        if (operation.error.code == 401){
            // token 已過期
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        }
        
        if (operation.error.code == -1009 || operation.error.code == -1004){
            // 沒有網路
        }
        sender.userInteractionEnabled = YES;
    }];
}
@end
