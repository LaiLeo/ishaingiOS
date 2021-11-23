//
//  ImageDetailViewController.h
//  volunteers
//
//  Created by jauyou on 2015/2/2.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailViewController : UIViewController<UIScrollViewDelegate>
@property UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)doDismiss:(id)sender;

@end
