//
//  NpoDetailViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/5.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "EventViewController.h"
#import "NpoDetailViewController.h"
#import "WilloAPIV2.h"

@interface NpoDetailViewController ()<WKNavigationDelegate,WKUIDelegate>

@end

@implementation NpoDetailViewController
{
    int npoId;
    NSMutableDictionary *npo;
}
@synthesize npoId;
@synthesize npo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.scrollWidth.constant = screenWidth;
    
    
    
    [self.spinner startAnimating];
    NSString *imageFile = [npo valueForKey:@"npo_icon"];
    NSString *strUrl = [imageFile stringByReplacingOccurrencesOfString:@"/uploads" withString:@"resources"];

    NSString *urlLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], strUrl];
    NSString *fileName = [[urlLick componentsSeparatedByString:@"/"] lastObject];
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [self.npoIcon sd_setImageWithURL:[NSURL URLWithString:urlLick]
                    placeholderImage:[UIImage imageNamed:fileName]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               [self.spinner stopAnimating];
                           }];
    
    self.npoName.text = [npo valueForKey:@"name"];
    NSString *npoLinkText = [npo valueForKey:@"contact_website"];
    NSRange range = [npoLinkText rangeOfString:@"http://"];
    if (range.location == NSNotFound) {
        range = [npoLinkText rangeOfString:@"https://"];
    }
    if (range.location != NSNotFound) {
        npoLinkText = [npoLinkText substringFromIndex:(range.location + range.length)];
    }
    [self.npoUrl setTitle:npoLinkText forState:UIControlStateNormal];
    self.npoDescription.text = [npo valueForKey:@"description"];
    
    float totalRatingScore = [[npo valueForKey:@"total_rating_score"] floatValue];
    if (totalRatingScore >= 5) {
        [self.score_1 setImage:[UIImage imageNamed:@"star_2"]];
        [self.score_2 setImage:[UIImage imageNamed:@"star_2"]];
        [self.score_3 setImage:[UIImage imageNamed:@"star_2"]];
        [self.score_4 setImage:[UIImage imageNamed:@"star_2"]];
        [self.score_5 setImage:[UIImage imageNamed:@"star_2"]];
    } else if(totalRatingScore >= 4) {
        [self.score_1 setImage:[UIImage imageNamed:@"star_2"]];
        [self.score_2 setImage:[UIImage imageNamed:@"star_2"]];
        [self.score_3 setImage:[UIImage imageNamed:@"star_2"]];
        [self.score_4 setImage:[UIImage imageNamed:@"star_2"]];
    } else if(totalRatingScore >= 3) {
        [self.score_1 setImage:[UIImage imageNamed:@"star_2"]];
        [self.score_2 setImage:[UIImage imageNamed:@"star_2"]];
        [self.score_3 setImage:[UIImage imageNamed:@"star_2"]];
    } else if(totalRatingScore >= 2) {
        [self.score_1 setImage:[UIImage imageNamed:@"star_2"]];
        [self.score_2 setImage:[UIImage imageNamed:@"star_2"]];
    } else if(totalRatingScore >= 1) {
        [self.score_1 setImage:[UIImage imageNamed:@"star_2"]];
    } else if(totalRatingScore == 0) {
        
    }
    
    self.npoRank.text = [NSString stringWithFormat:@"%d", [[npo valueForKey:@"rating_user_num"] intValue]];
    self.npoEvent.text = [NSString stringWithFormat:@"%d", [[npo valueForKey:@"event_num"] intValue]];
    self.npoRegistNum.text = [NSString stringWithFormat:@"%d", [[npo valueForKey:@"joined_user_num"] intValue]];
    self.npoFollowNum.text = [NSString stringWithFormat:@"%d", [[npo valueForKey:@"subscribed_user_num"] intValue]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if ([[npo valueForKey:@"event_num"] intValue] != 0) {
        self.holdEventHeight.constant = 40;
        self.npoHoldEvents.hidden = false;
    } else {
        self.holdEventHeight.constant = 0;
    }
    
    NSString *youtubeId = [npo valueForKey:@"youtube_code"];
    
    // id in NPO data can be empty or having invalid string: "ttps://www."
    if (([youtubeId length] != 0) &&
    !([youtubeId containsString:@"://"])) {
        self.npoVideoViewHeightConstraint.constant = screenWidth * 3 / 4;
        
        // make an embed link based on youtube id
        NSString *myYoutubeVideoLink = [NSString stringWithFormat:@"https://www.youtube.com/embed/%@", youtubeId];
        
        // initiate an indicator and a WKWebView and embed into the container view
        // adding webview directly in storyboard will cause crash/failure
        CGRect videoFrame = { CGPointZero, self.npoVideoContainerView.frame.size };
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:videoFrame];
        indicator.backgroundColor = UIColor.lightGrayColor;
        if (@available(iOS 13, *)) {
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
        } else {
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        }
        self.npoVideoIndicatorView = indicator;
        [self.npoVideoContainerView addSubview:self.npoVideoIndicatorView];
        [indicator startAnimating];
        
        self.npoVideoWebView = [[WKWebView alloc] initWithFrame:videoFrame];
        self.npoVideoWebView.UIDelegate = self;
        self.npoVideoWebView.navigationDelegate = self;
        self.npoVideoWebView.translatesAutoresizingMaskIntoConstraints = false;
        [self.npoVideoContainerView insertSubview:self.npoVideoWebView belowSubview:indicator];
        
        [self.npoVideoWebView.topAnchor constraintEqualToAnchor: self.npoVideoContainerView.topAnchor].active = YES;
        [self.npoVideoWebView.rightAnchor constraintEqualToAnchor: self.npoVideoContainerView.rightAnchor].active = YES;
        [self.npoVideoWebView.leftAnchor constraintEqualToAnchor: self.npoVideoContainerView.leftAnchor].active = YES;
        [self.npoVideoWebView.bottomAnchor constraintEqualToAnchor: self.npoVideoContainerView.bottomAnchor].active = YES;
        
        NSURL *embedURL = [[NSURL alloc] initWithString:myYoutubeVideoLink];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: embedURL];
        [self.npoVideoWebView loadRequest:request];
        self.npoVideoWebView.scrollView.scrollEnabled = NO;
        self.npoVideoWebView.scrollView.bounces = NO;
        
    } else {
        self.npoVideoViewHeightConstraint.constant = 0;
        self.npoVideoContainerView.hidden = true;
    }
    
    [self.followOrNotButton setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
    self.followOrNotButton.tag = 0;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    for (NSMutableDictionary *item in appDelegate.subscribe_npo) {
        if ([[[item valueForKey:@"subscribed_NPO"] valueForKey:@"id"] intValue] == npoId) {
            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
            self.followOrNotButton.tag = 1;
            break;
        }
    }
    
    self.npoFollowNum.text = [NSString stringWithFormat:@"%d", [[npo valueForKey:@"subscribed_user_num"] intValue]];
}

- (void)viewDidAppear:(BOOL)animated {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGSize sizeThatShouldFitTheContent = [self.npoDescription sizeThatFits:self.npoDescription.frame.size];
    
    self.descriptionHeight.constant = sizeThatShouldFitTheContent.height;
    
    // 183 is the size of top 2 views (132+51) in the current storyboard
    // it's a bad way to calculate since screen sizes may be different
    float sizeCouting = 183 + self.descriptionHeight.constant + self.holdEventHeight.constant + self.npoVideoViewHeightConstraint.constant;

    if (screenHeight > sizeCouting) {
        self.scrollHeight.constant = screenHeight;
    } else {
        self.scrollHeight.constant = sizeCouting;
    }
    self.scrollWidth.constant = screenWidth;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)gotoWebSite:(id)sender {
    NSString *url = [npo valueForKey:@"contact_website"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction)doFollowOrNot:(id)sender {
    if (self.followOrNotButton.tag == 0) {
        [self followNpo:sender];
    } else {
        [self unfollowNpo:sender];
    }
}

- (void)followNpo:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    [WilloAPIV2 subscribeById:[NSString stringWithFormat:@"%d", npoId] viewController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            self.followOrNotButton.tag = 1;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
            [WilloAPIV2 getDump:^void(){
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                for (NSMutableDictionary *npoItem in appDelegate.npo)
                {
                    if ([[npoItem valueForKey:@"id"] intValue] == npoId) {
                        npo = npoItem;
                    }
                }
                
                self.npoFollowNum.text = [NSString stringWithFormat:@"%d", [[npo valueForKey:@"subscribed_user_num"] intValue]];

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

- (void)unfollowNpo:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    
    [WilloAPIV2 unsubscribeById:[NSString stringWithFormat:@"%d", npoId] viewController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            self.followOrNotButton.tag = 0;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
            [WilloAPIV2 getDump:^void(){
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                for (NSMutableDictionary *npoItem in appDelegate.npo)
                {
                    if ([[npoItem valueForKey:@"id"] intValue] == npoId) {
                        npo = npoItem;
                    }
                }
                
                self.npoFollowNum.text = [NSString stringWithFormat:@"%d", [[npo valueForKey:@"subscribed_user_num"] intValue]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueNpoDetailToEvent"]) {
        
        NSString *title = @"我參加過的活動";
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSMutableArray *events = [[NSMutableArray alloc] init];
        
        for(NSMutableDictionary *item in appDelegate.event)
        {
            if ([[[item valueForKey:@"owner_NPO"] valueForKey:@"id"] intValue] == npoId) {
                [events addObject:item];
            }
        }
        
        EventViewController *destViewController = segue.destinationViewController;
        destViewController.title = title;
        destViewController.events = events;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.npoVideoIndicatorView stopAnimating];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.npoVideoIndicatorView startAnimating];
    self.npoVideoIndicatorView.hidden = NO;
}

@end
