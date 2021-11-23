//
//  VolunteerEventCollectionViewCell.h
//  volunteers
//
//  Created by jauyou on 2015/1/27.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolunteerEventCollectionViewCell : UICollectionViewCell
@property int eventId;
@property UIActivityIndicatorView *spinner;
@property UIViewController *viewController;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *dateCount;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *volunteerCount;
@property (weak, nonatomic) IBOutlet UIButton *followOrNotButton;
- (IBAction)followOrNot:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *urgentIcon;

@end
