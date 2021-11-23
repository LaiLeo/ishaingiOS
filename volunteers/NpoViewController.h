//
//  NpoViewController.h
//  volunteers
//
//  Created by jauyou on 2015/3/18.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NpoViewController : UIViewController
@property NSString *viewControllerTitle;
@property NSArray *npos;

@property (weak, nonatomic) IBOutlet UINavigationItem *viewTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)doDismiss:(id)sender;
@end
