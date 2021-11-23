//
//  VolunteerNoticeViewController.h
//  volunteers
//
//  Created by jauyou on 2015/2/2.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolunteerNoticeViewController : UIViewController
@property NSString *description;
@property (weak, nonatomic) IBOutlet UITextView *volunteerNotice;

- (IBAction)doDismiss:(id)sender;
@end
