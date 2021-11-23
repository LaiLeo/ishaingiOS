//
//  VolunteerNpoCollectionViewCell.h
//  volunteers
//
//  Created by jauyou on 2015/1/28.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolunteerNpoCollectionViewCell : UICollectionViewCell
@property int npoId;
@property UIActivityIndicatorView *spinner;
@property UIViewController *viewController;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *judgeNum;
@property (weak, nonatomic) IBOutlet UILabel *followNum;
@property (weak, nonatomic) IBOutlet UILabel *eventCount;
@property (weak, nonatomic) IBOutlet UILabel *joinNum;
@property (weak, nonatomic) IBOutlet UIImageView *score1;
@property (weak, nonatomic) IBOutlet UIImageView *score2;
@property (weak, nonatomic) IBOutlet UIImageView *score3;
@property (weak, nonatomic) IBOutlet UIImageView *score4;
@property (weak, nonatomic) IBOutlet UIImageView *score5;
@property (weak, nonatomic) IBOutlet UIButton *followOrNotButton;
- (IBAction)followOrNot:(id)sender;
@end
