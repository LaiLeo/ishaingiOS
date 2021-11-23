//
//  RegistEventViewController.hMyTextField
//  volunteers
//
//  Created by jauyou on 2015/2/3.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistEventViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property int eventId;
@property NSMutableDictionary *event;
@property int skill_pk;
@property NSString *skills;
@property bool isEnterprise;
@property bool isResourceEvent;
@property bool isInsuranceEvent;//FIH-add for 有勾需要保險資料 

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *birth;
@property (weak, nonatomic) IBOutlet UITextField *PersionID;
@property (weak, nonatomic) IBOutlet UILabel *PersionIDDeclaration;
@property (weak, nonatomic) IBOutlet UITextField *guardianName;
@property (weak, nonatomic) IBOutlet UITextField *guardianPhone;
@property (weak, nonatomic) IBOutlet UITextField *enterpriseSerialNumber;
@property (weak, nonatomic) IBOutlet UITextField *employeeSerialNumber;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *registTitle;
@property (weak, nonatomic) IBOutlet UITextField *serviceArea;
@property (weak, nonatomic) IBOutlet UITextField *serviceItem;
@property (weak, nonatomic) IBOutlet UIView *itemsBlock;

@property (weak, nonatomic) IBOutlet UIScrollView *scrowView;

- (IBAction)doDismiss:(id)sender;
- (IBAction)doRegist:(id)sender;
- (IBAction)doAgree:(id)sender;
- (IBAction)showEditServiceArea:(UITapGestureRecognizer *)sender;
- (IBAction)showServiceItem:(UITapGestureRecognizer *)sender;
@end
