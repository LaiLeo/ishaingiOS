//
//  VolunteerEventViewController.h
//  volunteers
//
//  Created by jauyou on 2015/1/27.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditEventTypeViewController.h"
#import "TabBarUpdateProtocol.h"

@interface VolunteerEventViewController : UIViewController<TabBarUpdateProtocol, UISearchBarDelegate, EditEventTypeViewControllerDelegate, UIAlertViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
//CLLocationManagerDelegate
- (IBAction)gotoPersonInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *volunteerEventCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *volunteerNpoCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *autoCompleteTableView;
@property (weak, nonatomic) IBOutlet UIView *advanceSearch;
//@property (weak, nonatomic) IBOutlet UIPickerView *eventIntervalPicker;
//@property (weak, nonatomic) IBOutlet UIPickerView *eventLocationPicker;
- (IBAction)doAdvancedSearch:(id)sender;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *userIcon;
@property (weak, nonatomic) IBOutlet UIButton *showAllEventButton;
@property (weak, nonatomic) IBOutlet UIButton *advancedSearchButton;
@property (weak, nonatomic) IBOutlet UIButton *showAllNpoButton;

@property (weak, nonatomic) IBOutlet UIButton *intervalButton;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UIButton *fullStatusButton;


- (IBAction)showAllEvent:(id)sender;
- (IBAction)advancedSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *showNearEventButton;
- (IBAction)showNearEvent:(id)sender;
- (IBAction)showAllNpo:(id)sender;
- (IBAction)showRegistedEvent:(id)sender;
@end

@interface VolunteerEventViewController()
@property(readwrite) bool isEnterprise;
@end
