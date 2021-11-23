//
//  SkillsHabitsViewController.h
//  volunteers
//
//  Created by jauyou on 2015/2/4.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillsHabitsViewController : UIViewController
@property bool isSkill;
@property(nonatomic, copy) NSString * _Nonnull title;
@property NSString * _Nonnull skillHabitString;
@property void (^ _Nullable listener)(NSArray* _Nonnull, NSArray* _Nonnull);
@property NSArray * _Nullable allItems;
@property bool selectable;
@property int maxSelectableItem;
@property (weak, nonatomic) IBOutlet UINavigationItem * _Nullable viewControllerTitle;
@property (weak, nonatomic) IBOutlet UICollectionView * _Nullable collectionView;

- (IBAction)doDismiss:(id _Nonnull)sender;
@end
