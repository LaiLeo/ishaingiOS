//
//  EventViewController.h
//  volunteers
//
//  Created by jauyou on 2015/2/4.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController
@property NSString *viewControllerTitle;
@property NSArray *events;
@property Boolean isResourceEvent;

@property (weak, nonatomic) IBOutlet UINavigationItem *viewTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)doDismiss:(id)sender;

@end
