//
//  EditSkillStringViewController.h
//  volunteers
//
//  Created by jauyou on 2015/3/2.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditSkillStringViewController;

@protocol EditSkillStringViewControllerDelegate <NSObject>
- (void)addItemViewController:(EditSkillStringViewController *)controller didFinishEnteringItem:(NSString *)item;
@end

@interface EditSkillStringViewController : UIViewController
@property NSMutableArray *skills;
@property NSString *skillDescription;
@property (nonatomic, weak) id <EditSkillStringViewControllerDelegate> delegate;

- (IBAction)doDissmiss:(id)sender;
- (IBAction)changeSkill:(id)sender;

@end
