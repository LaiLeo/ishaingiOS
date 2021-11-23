//
//  EditEventTypeViewController.h
//  volunteers
//
//  Created by jauyou on 2015/3/5.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditEventTypeViewController;

@protocol EditEventTypeViewControllerDelegate <NSObject>
- (void)setTypeViewController:(EditEventTypeViewController *)controller didFinishEnteringItem:(NSArray *)enableTypes;
@end

@interface EditEventTypeViewController : UIViewController
@property NSMutableArray *typeEnableList;
@property NSArray *useArray;
@property (nonatomic, weak) id <EditEventTypeViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)doDissmiss:(id)sender;
- (IBAction)changeEnable:(id)sender;
@end
