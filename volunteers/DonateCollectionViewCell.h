//
//  DonateCollectionViewCell.h
//  volunteers
//
//  Created by jauyou on 2015/3/6.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonateCollectionViewCell : UICollectionViewCell
@property UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@end
