//
//  EventImageCollectionViewCell.h
//  volunteers
//
//  Created by jauyou on 2015/2/2.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventImageCollectionViewCell : UICollectionViewCell
@property UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@end
