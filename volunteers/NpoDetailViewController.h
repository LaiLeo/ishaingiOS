//
//  NpoDetailViewController.h
//  volunteers
//
//  Created by jauyou on 2015/2/5.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface NpoDetailViewController : UIViewController
@property int npoId;
@property NSMutableDictionary *npo;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *npoIcon;
@property (weak, nonatomic) IBOutlet UILabel *npoName;
@property (weak, nonatomic) IBOutlet UIButton *npoUrl;
@property (weak, nonatomic) IBOutlet UITextView *npoDescription;
@property (weak, nonatomic) IBOutlet UIButton *followOrNotButton;
@property (weak, nonatomic) IBOutlet UIView *npoVideoContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *npoVideoViewHeightConstraint;
@property (nonatomic, strong) WKWebView *npoVideoWebView;
@property (nonatomic, strong) UIActivityIndicatorView *npoVideoIndicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *score_1;
@property (weak, nonatomic) IBOutlet UIImageView *score_2;
@property (weak, nonatomic) IBOutlet UIImageView *score_3;
@property (weak, nonatomic) IBOutlet UIImageView *score_4;
@property (weak, nonatomic) IBOutlet UIImageView *score_5;

@property (weak, nonatomic) IBOutlet UILabel *npoRank;
@property (weak, nonatomic) IBOutlet UILabel *npoEvent;
@property (weak, nonatomic) IBOutlet UILabel *npoRegistNum;
@property (weak, nonatomic) IBOutlet UILabel *npoFollowNum;
@property (weak, nonatomic) IBOutlet UIView *npoHoldEvents;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holdEventHeight;

- (IBAction)doDismiss:(id)sender;
- (IBAction)gotoWebSite:(id)sender;
- (IBAction)doFollowOrNot:(id)sender;
@end
