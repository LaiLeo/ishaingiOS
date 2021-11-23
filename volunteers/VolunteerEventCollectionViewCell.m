//
//  VolunteerEventCollectionViewCell.m
//  volunteers
//
//  Created by jauyou on 2015/1/27.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarUpdateProtocol.h"
#import "VolunteerEventCollectionViewCell.h"
#import "WilloAPIV2.h"

@implementation VolunteerEventCollectionViewCell
{
    int eventId;
    UIActivityIndicatorView *spinner;
    UIViewController *viewController;
}
@synthesize eventId;
@synthesize spinner;
@synthesize viewController;

- (IBAction)followOrNot:(id)sender {
    if (self.followOrNotButton.tag == 0) {
        [self followEvent:sender];
    } else {
        [self unfollowEvent:sender];
    }
}

- (void)followEvent:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    [WilloAPIV2 focusById:[NSString stringWithFormat:@"%d", self.eventId] viewController:viewController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            self.followOrNotButton.tag = 1;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
            [WilloAPIV2 getDump:^void(){
                [(UIViewController<TabBarUpdateProtocol> *)viewController reloadFocus];
            }];
        }
        sender.userInteractionEnabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);
        if (operation.response.statusCode == 400) {
            self.followOrNotButton.tag = 1;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        }
        sender.userInteractionEnabled = YES;
    }];
}

- (void)unfollowEvent:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    
    [WilloAPIV2 unfocusById:[NSString stringWithFormat:@"%d", self.eventId] viewController:viewController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            self.followOrNotButton.tag = 0;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
            [WilloAPIV2 getDump:^void(){
                [(UIViewController<TabBarUpdateProtocol> *)viewController reloadFocus];
            }];
        }
        sender.userInteractionEnabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);
        if (operation.response.statusCode == 400) {
            self.followOrNotButton.tag = 0;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
        }
        sender.userInteractionEnabled = YES;
    }];
}
@end
