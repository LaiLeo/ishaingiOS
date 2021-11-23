//
//  ReplyCollectionViewCell.h
//  volunteers
//
//  Created by jauyou on 2015/2/2.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *userSpinner;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userComment;
@property (weak, nonatomic) IBOutlet UIButton *userIconButton;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *userImageButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *uerImageSpinner;

@end
