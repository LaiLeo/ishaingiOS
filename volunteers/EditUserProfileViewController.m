//
//  EditUserProfileViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/5.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "EditUserProfileViewController.h"
#import "SkillsHabitsViewController.h"
#import "WilloAPIV2.h"
#import "volunteers-Swift.h"
#import <Masonry/Masonry.h>
#import "LogHeader.h"
#import "UserProfileData.h"
#import "FuBonLoginViewController.h"
#import "LoginServer.h"
#import "UnbindTaiWanViewController.h"
#import "UnBindFubonViewController.h"
#import "UIView+Toast.h"

@interface EditUserProfileViewController ()
@property(nonatomic,strong)NSDictionary *data;
@end

@implementation EditUserProfileViewController
{
    int movementDistance;
    UITextField *selectTextField;
    CGSize keyboardSize;
    
    NSString *imagePath;;
    UIImagePickerController *imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _data = [UserProfileData myProfile];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *urlLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], [appDelegate.user valueForKey:@"icon"]];
    NSString *fileName = [appDelegate.user valueForKey:@"icon"];
//    NSString *urlLick2 = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getImageUrlName], fileName];
//    NSString *fileNames = [[fileName componentsSeparatedByString:@"/"] lastObject];
    NSString *strUrl = [fileName stringByReplacingOccurrencesOfString:@"uploads" withString:@"resources"];

    NSString *urlLick2 = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getImageUrlName], strUrl];

    [self.spinner startAnimating];
    NSLog(@"urlLick: %@", urlLick);
    // Here we use the new provided setImageWithURL: method to load the web image
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:urlLick2]
                     placeholderImage:[UIImage imageNamed:fileName]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                [self.spinner stopAnimating];
                            }];
    
    self.name.text = [appDelegate.user valueForKey:@"name"];
    self.phone.text = [appDelegate.user valueForKey:@"phone"];
    
//    [self.isPublic setOn:[[appDelegate.user valueForKey:@"is_public"] boolValue] animated:YES];
    [self.publicSwitch setOn:[[appDelegate.user valueForKey:@"is_public"] boolValue] animated:YES];
 
    self.aboutMe.text = [appDelegate.user valueForKey:@"about_me"];
    
//    self.isPublic.selected = [[appDelegate.user valueForKey:@"is_public"] boolValue];
    self.publicSwitch.selected = [[appDelegate.user valueForKey:@"is_public"] boolValue];
;

    self.skillList.text = [appDelegate.user valueForKey:@"interest"];
    self.habitList.text = [appDelegate.user valueForKey:@"skills_description"];
    
    
    
    self.baseView = [[UIScrollView alloc]init];
    self.baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.baseView];
    if ((lz_iPhoneX || lz_iPhoneXr || lz_iPhoneXs || lz_iPhoneXsMax)) {
        [ self.baseView setFrame:CGRectMake(0, 44+35, kScreenW,kScreenH)];

    }else{
        [ self.baseView setFrame:CGRectMake(0, 44+20, kScreenW,kScreenH)];

    }
    [self.baseView setContentSize:CGSizeMake(kScreenW, kScreenH+220)];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // 鍵盤消失時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.baseView addGestureRecognizer:tap];
    
    imagePath = nil;
    // 設定UIImagePickerController代理
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self initSubViews:_data];
}
-(void)initSubViews:(NSDictionary*)data{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 171)];
    headView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [self.baseView addSubview:headView];
    
    UIImageView *userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(32, 32, 100, 100)];
    userIcon.image = [UIImage imageNamed:@"user_icon"];
    userIcon.layer.cornerRadius = 50;
    userIcon.layer.masksToBounds = YES;
    self.userHeadIcon = userIcon;
    [self.baseView addSubview:userIcon];
    
    _data = [UserProfileData myProfile];

    
    NSString *urlLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], [appDelegate.user valueForKey:@"icon"]];
    NSString *fileName = [appDelegate.user valueForKey:@"icon"];
    NSString *strUrl = [fileName stringByReplacingOccurrencesOfString:@"uploads" withString:@"resources"];
    NSString *urlLick2 = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getImageUrlName], strUrl];
    [self.spinner startAnimating];
    NSLog(@"urlLick: %@", urlLick);
    // Here we use the new provided setImageWithURL: method to load the web image
    [self.userHeadIcon sd_setImageWithURL:[NSURL URLWithString:urlLick2]
                     placeholderImage:[UIImage imageNamed:fileName]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                [self.spinner stopAnimating];
                            }];
    
    //
    UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(40, 108, 84, 30)];
    [editButton setTitle:@"編輯照片" forState:0];
    [editButton setBackgroundColor:[UIColor colorWithRed:74/255.0 green:174/255.0 blue:255/255.0 alpha:0.65]];
    editButton.userInteractionEnabled = YES;
    editButton.layer.cornerRadius = 15;
    [editButton addTarget:self action:@selector(editImage) forControlEvents:(UIControlEventTouchUpInside)];

    [self.baseView addSubview:editButton];
    
    self.realName = [self creatTitle:@"  請填寫真實姓名" y:28 width:199 height:30 tag:1 baseView:self.baseView];
    self.phoneNumber = [self creatTitle:@"  請填寫手機/電話" y:68 width:199 height:30 tag:2 baseView:self.baseView];
    //公開個人護照
    self.publicSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(152, 113, 52, 31)];
    self.publicSwitch.on = YES;
    [self.publicSwitch addTarget:self action:@selector(publicImage) forControlEvents:(UIControlEventValueChanged)];
    [self.baseView addSubview:self.publicSwitch];
//
    UILabel *imageTitle = [[UILabel alloc]initWithFrame:CGRectMake(213, 119, 100, 20)];
    imageTitle.text = @"公開個人護照";
    imageTitle.font = [UIFont systemFontOfSize:14];
    imageTitle.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0];
    [self.baseView addSubview:imageTitle];
    
    UILabel *changePasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 171+269, 100, 24)];
    changePasswordLabel.text = @"修改密碼";
    changePasswordLabel.font = [UIFont systemFontOfSize:16];
    [self.baseView addSubview:changePasswordLabel];
    
    UILabel *EnterpriseBind = [[UILabel alloc]initWithFrame:CGRectMake(24, 171+451, 100, 24)];
    EnterpriseBind.text = @"企業綁定";
    EnterpriseBind.font = [UIFont systemFontOfSize:16];
    [self.baseView addSubview:EnterpriseBind];
    
    UILabel *fubonTitle = [[UILabel alloc]initWithFrame:CGRectMake(32, 171+484, 108, 25)];
    fubonTitle.text = @"富邦集團員工";
    fubonTitle.font = [UIFont systemFontOfSize:16];
    [self.baseView addSubview:fubonTitle];
    
    UILabel *fubonBind = [[UILabel alloc]initWithFrame:CGRectMake(171, 171+484, 100, 25)];
    fubonBind.font = [UIFont systemFontOfSize:16];
    [self.baseView addSubview:fubonBind];
    
    UIButton *relieveButton = [[UIButton alloc]initWithFrame:CGRectMake(255, 171+484, 82, 24)];
    [relieveButton setTitleColor:[UIColor colorWithRed:54/255.0 green:151/255.0 blue:255/255.0 alpha:1] forState:0];
    [relieveButton addTarget:self action:@selector(fubonBindAction) forControlEvents:UIControlEventTouchUpInside];
    NSString *isFubon = [NSString stringWithFormat:@"%@",[data valueForKey:@"isFubon"]];

    if ([isFubon isEqualToString:@"1"]) {
        fubonBind.text = @"已綁定";
        fubonBind.textColor = [UIColor greenColor];
        [relieveButton setTitle:@"解除綁定" forState:0];

    }else{
        fubonBind.text = @"未綁定";
        fubonBind.textColor = [UIColor redColor];
        [relieveButton setTitle:@"前往綁定" forState:0];

    }
    [self.baseView addSubview:relieveButton];
    
    UILabel *taiwanTitle = [[UILabel alloc]initWithFrame:CGRectMake(32, 171+521, 115, 25)];
    taiwanTitle.text = @"台灣大哥大員工";
    taiwanTitle.font = [UIFont systemFontOfSize:16];
    [self.baseView addSubview:taiwanTitle];
    
    UILabel *taiwanBind = [[UILabel alloc]initWithFrame:CGRectMake(171, 171+521, 100, 25)];
    taiwanBind.font = [UIFont systemFontOfSize:16];
    [self.baseView addSubview:taiwanBind];
    
    UIButton *trelieveButton = [[UIButton alloc]initWithFrame:CGRectMake(255, 171+521, 82, 24)];
    [trelieveButton setTitleColor:[UIColor colorWithRed:54/255.0 green:151/255.0 blue:255/255.0 alpha:1] forState:0];
    [trelieveButton addTarget:self action:@selector(taiwanBindAction) forControlEvents:UIControlEventTouchUpInside];
    NSString *isTwm = [NSString stringWithFormat:@"%@",[data valueForKey:@"isTwm"]];
    if ([isTwm isEqualToString:@"1"]) {
        taiwanBind.text = @"已綁定";
        taiwanBind.textColor = [UIColor greenColor];
        [trelieveButton setTitle:@"解除綁定" forState:0];
    }else{
        taiwanBind.text = @"未綁定";
        taiwanBind.textColor = [UIColor redColor];
        [trelieveButton setTitle:@"前往綁定" forState:0];
    }
    [self.baseView addSubview:trelieveButton];
    //xiugai
    
    UIButton * changeButton = [[UIButton alloc]initWithFrame:CGRectMake(36, 171+592, kScreenW-72, 50)];
    changeButton.backgroundColor = [UIColor orangeColor];
    [changeButton setTitle:@"確認修改" forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    changeButton.layer.cornerRadius = 25.0f;
//    self.changeButton = logButton;
    [self.baseView addSubview:changeButton];
    //
    

    self.aboutMeNew = [self creatTitle:@"  關於我" y:191 width:kScreenW-48 height:48 tag:3 baseView:self.baseView];
    self.areaList = [self creatTitle:@"  可服務區域" y:171+83 width:kScreenW-48 height:48 tag:4 baseView:self.baseView];
    self.areaList.enabled = NO;
    self.serviceList = [self creatTitle:@"  可服務項目" y:171+146 width:kScreenW-48 height:48 tag:5 baseView:self.baseView];
    self.serviceList.enabled = NO;

    self.picture = [self creatTitle:@"  專業證照" y:171+209 width:kScreenW-48 height:30 tag:6 baseView:self.baseView];
    self.picture.enabled = NO;

    self.oldP = [self creatTitle:@"  原密碼" y:171+301 width:kScreenW-48 height:30 tag:7 baseView:self.baseView];
    self.passWord = [self creatTitle:@"  新密碼" y:171+349 width:kScreenW-48 height:30 tag:8 baseView:self.baseView];
    self.confireP = [self creatTitle:@"  新密碼確認" y:171+391 width:kScreenW-48 height:30 tag:9 baseView:self.baseView];
    
    UIButton *areaListButton = [[UIButton alloc]initWithFrame:CGRectMake(24, 171+83, kScreenW-48, 48)];
    [areaListButton addTarget:self action:@selector(areaListAction) forControlEvents:UIControlEventTouchUpInside];
    areaListButton.userInteractionEnabled = YES;
    [self.baseView addSubview:areaListButton];
    
    UIButton *serviceListButton = [[UIButton alloc]initWithFrame:CGRectMake(24, 171+146, kScreenW-48, 48)];
    serviceListButton.userInteractionEnabled = YES;

    [serviceListButton addTarget:self action:@selector(serviceListAction) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:serviceListButton];
    
    UIButton *pictureButton = [[UIButton alloc]initWithFrame:CGRectMake(24, 171+209, kScreenW-48, 48)];
    pictureButton.userInteractionEnabled = YES;

    [pictureButton addTarget:self action:@selector(imageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:pictureButton];
    //profile
    
    self.realName.text =[NSString stringWithFormat:@"%@",[appDelegate.user valueForKey:@"name"]];
    self.phoneNumber.text = [NSString stringWithFormat:@"%@",[appDelegate.user valueForKey:@"phone"]] ;
    self.aboutMeNew.text = [NSString stringWithFormat:@"%@",[appDelegate.user valueForKey:@"about_me"]];
    self.areaList.text = [NSString stringWithFormat:@"%@",[appDelegate.user valueForKey:@"interest"]];
    self.serviceList.text = [NSString stringWithFormat:@"%@",[appDelegate.user valueForKey:@"skills_description"]];
    [self.publicSwitch setOn:[[appDelegate.user valueForKey:@"is_public"] boolValue] animated:YES];
    self.publicSwitch.selected = [[appDelegate.user valueForKey:@"is_public"] boolValue];
}
-(void)fubonBindAction{
    NSString *isFubon = [NSString stringWithFormat:@"%@",[_data valueForKey:@"isFubon"]];

    if ([isFubon isEqualToString:@"1"]) {
        //跳入对话框
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確定要解除綁定"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"確定", nil];
        alert.tag = 1;
        [alert show];
    }else{
        UnBindFubonViewController *fuBonVC = [[UnBindFubonViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:fuBonVC];
        nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
        nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
}
-(void)taiwanBindAction{
    NSString *isTwm = [NSString stringWithFormat:@"%@",[_data valueForKey:@"isTwm"]];
    if ([isTwm isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確定要解除綁定"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"確定", nil];
        alert.tag = 2;
        [alert show];
    }else{
        UnbindTaiWanViewController *taiWanVC = [[UnbindTaiWanViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:taiWanVC];
        nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
        nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1 && buttonIndex == 1) {
       //富邦解除绑定
        [[LoginServer shareInstance]DeleteFubonNumberSuccess:^(NSDictionary * _Nonnull dic) {
//            [self.view makeToast:@"success" duration:2.0 position:@"CSToastPositionCenter"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *devToken = [userDefaults stringForKey:@"token"];
            
            [[LoginServer shareInstance]GetPersonInformationToken:devToken Success:^(NSDictionary * _Nonnull dic) {
                [UserProfileData saveProfile:dic];
                [self dismissViewControllerAnimated:YES completion:nil];
                        } failure:^(NSError * _Nonnull error) {
                            [self.view makeToast:@"failure" duration:2.0 position:@"CSToastPositionCenter"];

                        }];

        } failure:^(NSError * _Nonnull error) {
            [self.view makeToast:@"failure" duration:2.0 position:@"CSToastPositionCenter"];

        }];
        
    }
    if (alertView.tag == 2 && buttonIndex == 1) {
       //台湾大哥大会员解除绑定
        [[LoginServer shareInstance]DeleteTwmNumberSuccess:^(NSDictionary * _Nonnull dic) {
            [self.view makeToast:@"success" duration:2.0 position:@"CSToastPositionCenter"];

        } failure:^(NSError * _Nonnull error) {
            [self.view makeToast:@"failure" duration:2.0 position:@"CSToastPositionCenter"];

        }];
        
    }
}
-(void)areaListAction{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SkillsHabitsViewController *destViewController = [sb instantiateViewControllerWithIdentifier:@"skillsHabitsViewController"];
    destViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    destViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    destViewController.isSkill = true;
    destViewController.title = @"可服務區域";
    destViewController.selectable = true;
    destViewController.maxSelectableItem = 3;
    destViewController.allItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countryMapping" ofType:@"plist"] ];
    destViewController.listener = ^(NSArray* allItems, NSArray* selectedItems){
        NSMutableArray * resultArray = [[NSMutableArray alloc]init];
        for(int i=0;i<selectedItems.count; i++){
            if([[selectedItems objectAtIndex:i] boolValue] == YES){
                [resultArray addObject:[allItems objectAtIndex:i]];
            }
        }
        NSString * result = [resultArray componentsJoinedByString:@", "];
        self.areaList.text = result;
    };
    destViewController.skillHabitString = self.skillList.text;
    [self presentViewController:destViewController animated:YES completion:nil];

}
-(void)serviceListAction{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SkillsHabitsViewController *destViewController = [sb instantiateViewControllerWithIdentifier:@"skillsHabitsViewController"];
    destViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    destViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;    destViewController.isSkill = true;
    destViewController.title = @"可服務項目";
    destViewController.selectable = true;
    destViewController.maxSelectableItem = 3;
    destViewController.allItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"serviceItemType" ofType:@"plist"] ];
    destViewController.listener = ^(NSArray* allItems, NSArray* selectedItems){
        NSMutableArray * resultArray = [[NSMutableArray alloc]init];
        for(int i=0;i<selectedItems.count; i++){
            if([[selectedItems objectAtIndex:i] boolValue] == YES){
                [resultArray addObject:[allItems objectAtIndex:i]];
            }
        }
        NSString * result = [resultArray componentsJoinedByString:@", "];
        self.serviceList.text = result;

    };
    destViewController.skillHabitString = self.serviceList.text;
    [self presentViewController:destViewController animated:YES completion:nil];

}
-(void)imageAction{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserPhotoViewController *destViewController = [sb instantiateViewControllerWithIdentifier:@"userPhotoViewController"];
    destViewController.images = [appDelegate.user valueForKey:@"images"];
    destViewController.title = @"專業證照";
    destViewController.canAdd = YES;
    destViewController.canDelete = YES;
    [self presentViewController:destViewController animated:YES completion:nil];

}
-(void)editImage{
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //以動畫方式顯示圖庫
    [self presentViewController:imagePicker animated:YES completion:nil];
}
-(void)publicImage{
    
}
- (UITextField *)creatTitle:(NSString *)title y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height tag:(NSInteger)tag baseView:(UIView *)supView{
    UIView *baseView = [[UIView alloc]init];//WithFrame:CGRectMake(kScreenW-199-24, y, 199, 30)];
    if (tag == 1 || tag == 2) {
        [baseView setFrame:CGRectMake(kScreenW-199-24, y, width, height)];
    }else if (tag == 3 || tag == 4 || tag == 5){
        [baseView setFrame:CGRectMake(24, y, width, height)];

    }else if (tag == 6 || tag == 7 || tag == 8 || tag == 9){
        [baseView setFrame:CGRectMake(24, y, width, height)];

    }
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.layer.cornerRadius = 4;
    baseView.layer.borderWidth = 2;
    baseView.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
    baseView.layer.masksToBounds = YES;
    [supView addSubview:baseView];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    textField.font = [UIFont systemFontOfSize:14];
    textField.textColor = [UIColor grayColor];
    textField.placeholder = title;
    textField.delegate = self;
    [baseView addSubview:textField];

    return textField;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle{
    return UIUserInterfaceStyleLight;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([segue.identifier isEqualToString:@"segueEditUserProfileToServiceArea"]) {
        SkillsHabitsViewController *destViewController = segue.destinationViewController;
        destViewController.isSkill = true;
        destViewController.title = @"可服務區域";
        destViewController.selectable = true;
        destViewController.maxSelectableItem = 3;
        destViewController.allItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countryMapping" ofType:@"plist"] ];
        destViewController.listener = ^(NSArray* allItems, NSArray* selectedItems){
            NSMutableArray * resultArray = [[NSMutableArray alloc]init];
            for(int i=0;i<selectedItems.count; i++){
                if([[selectedItems objectAtIndex:i] boolValue] == YES){
                    [resultArray addObject:[allItems objectAtIndex:i]];
                }
            }
            NSString * result = [resultArray componentsJoinedByString:@", "];
            self.skillList.text = result;
        };
        destViewController.skillHabitString = self.skillList.text;
    }else if([segue.identifier isEqualToString:@"segueEditUserProfileToServiceItem"]){
        SkillsHabitsViewController *destViewController = segue.destinationViewController;
        destViewController.isSkill = true;
        destViewController.title = @"可服務項目";
        destViewController.selectable = true;
        destViewController.maxSelectableItem = 3;
        destViewController.allItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"serviceItemType" ofType:@"plist"] ];
        destViewController.listener = ^(NSArray* allItems, NSArray* selectedItems){
            NSMutableArray * resultArray = [[NSMutableArray alloc]init];
            for(int i=0;i<selectedItems.count; i++){
                if([[selectedItems objectAtIndex:i] boolValue] == YES){
                    [resultArray addObject:[allItems objectAtIndex:i]];
                }
            }
            NSString * result = [resultArray componentsJoinedByString:@", "];
            self.habitList.text = result;
        };
        destViewController.skillHabitString = self.habitList.text;
        
    }else if([segue.identifier isEqualToString:@"segueEditUserProfileToUserPhoto"]) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UserPhotoViewController *destViewController = segue.destinationViewController;
        destViewController.images = [appDelegate.user valueForKey:@"images"];
        destViewController.title = @"專業證照";
        destViewController.canAdd = YES;
        destViewController.canDelete = YES;
        //        destViewController.profile = appDelegate.user;
        NSLog(@"user: %@", appDelegate.user);
        //        destViewController.isEditable = true;
    }
    
    
}


-(void)keyboardWillShow:(NSNotification *) notification{
    NSDictionary* info = [notification userInfo];
    // kbSize即為鍵盤尺寸 (有width, height)
    keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    //再依據不同的高度 作不同的因應
    
    const float movementDuration = 0.3f; // tweak as needed
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    int movement;
    float textFieldBottom = selectTextField.frame.origin.y + selectTextField.frame.size.height + selectTextField.tag;
    float keyboardTop = screenHeight - keyboardSize.height;
    
    float shouldMove = textFieldBottom - keyboardTop + 50;
    if (movementDistance - shouldMove >= 0) {
        movement = 0;
    } else {
        movement = movementDistance - shouldMove;
        movementDistance = shouldMove; // tweak as needed
    }
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

//鍵盤消失時則是加這個
- (void)keyboardWillHidden:(NSNotification*)aNotification{
    // something
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = movementDistance;
    movementDistance = 0;
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    /* keyboard is visible, move views */
    selectTextField = textField;
    
    const float movementDuration = 0.3f; // tweak as needed
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    int movement;
    float textFieldBottom = selectTextField.frame.origin.y + selectTextField.frame.size.height;
    float keyboardTop = screenHeight - keyboardSize.height;
    
    float shouldMove = textFieldBottom - keyboardTop + 50;
    if (movementDistance - shouldMove >= 0) {
        movement = 0;
    } else {
        movement = movementDistance - shouldMove;
        movementDistance = shouldMove; // tweak as needed
    }
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)dismissKeyboard {
    [self.name resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.oldPassword resignFirstResponder];
    [self.changePassword resignFirstResponder];
    [self.changePasswordConfirm resignFirstResponder];
    [self.aboutMe resignFirstResponder];
    [self.skillList resignFirstResponder];
    [self.habitList resignFirstResponder];
    
    [self.realName resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.oldPassword resignFirstResponder];
    [self.changePassword resignFirstResponder];
    [self.changePasswordConfirm resignFirstResponder];
    [self.aboutMeNew resignFirstResponder];
    [self.serviceList resignFirstResponder];
    [self.areaList resignFirstResponder];
    [self.oldP resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.confireP resignFirstResponder];

    
}

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//
-(void)changeUserProfile:(id)sender{
    if ([self.realName.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
                                                        message:@"必須填寫姓名"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    if ([self.phoneNumber.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
                                                        message:@"必須填寫電話"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

//    if ([self.habitList.text length] == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
//                                                        message:@"必須填寫興趣"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }

    if ([self.aboutMeNew.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
                                                        message:@"必須填寫關於我"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

//    if ([self.skillList.text length] == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
//                                                        message:@"必須填寫技能"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }

    ((UIButton *)sender).userInteractionEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.realName.text forKey:@"name"];
    [parameters setObject:self.phoneNumber.text forKey:@"phone"];
    [parameters setObject:self.serviceList.text forKey:@"service_item"];
    [parameters setObject:self.aboutMeNew.text forKey:@"about_me"];

//    if (self.publicSwitch.on) {
//        [parameters setObject:@"true" forKey:@"is_public"];
//    } else {
//        [parameters setObject:@"false" forKey:@"is_public"];
//    }

    [parameters setObject:self.areaList.text forKey:@"service_area"];
    if ([self.oldP.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
                                                        message:@"舊密碼不能為空"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([self.passWord.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
                                                        message:@"新密碼不能為空"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
//    if (![self checkPassword:self.passWord.text]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
//                                                        message:@"請輸入8-12碼英數字混合密碼"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    if (![self.passWord.text isEqualToString:self.confireP.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密碼錯誤" message:@"您輸入的密碼與確認密碼不符，請重新輸入" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([self.oldP.text length] != 0 && self.passWord.text !=0 && [self.passWord.text isEqualToString:self.confireP.text]) {
        [parameters setObject:self.oldP.text forKey:@"old_password"];
        [parameters setObject:self.passWord.text forKey:@"password"];
    }

    [WilloAPIV2 editProfileWithParameters:parameters viewController:self constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imagePath != nil) {
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
            [formData appendPartWithFileData:data name:@"icon" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WilloAPIV2 getDump:^(){
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });
            ((UIButton *)sender).userInteractionEnabled = YES;

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"編輯個人資料"
                                                            message:@"修改個人資料完成"
                                                           delegate:self
                                                  cancelButtonTitle:@"好"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        ((UIButton *)sender).userInteractionEnabled = YES;
    }];

}
//确认修改
- (IBAction)updateUserProfile:(id)sender {
    if ([self.name.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
                                                        message:@"必須填寫姓名"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.phone.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
                                                        message:@"必須填寫電話"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
//    if ([self.habitList.text length] == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
//                                                        message:@"必須填寫興趣"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    
    if ([self.aboutMe.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
                                                        message:@"必須填寫關於我"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
//    if ([self.skillList.text length] == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"個人資料修改"
//                                                        message:@"必須填寫技能"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    
    ((UIButton *)sender).userInteractionEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.name.text forKey:@"name"];
    [parameters setObject:self.phone.text forKey:@"phone"];
    [parameters setObject:self.habitList.text forKey:@"service_item"];
    [parameters setObject:self.aboutMe.text forKey:@"about_me"];
    
    if (self.isPublic.on) {
        [parameters setObject:@"true" forKey:@"is_public"];
    } else {
        [parameters setObject:@"false" forKey:@"is_public"];
    }
    
    [parameters setObject:self.skillList.text forKey:@"service_area"];
    
    if ([self.oldPassword.text length] != 0 && self.changePassword.text !=0 && [self.changePassword.text isEqualToString:self.changePasswordConfirm.text]) {
        [parameters setObject:self.oldPassword.text forKey:@"old_password"];
        [parameters setObject:self.changePassword.text forKey:@"password"];
    }
    
    [WilloAPIV2 editProfileWithParameters:parameters viewController:self constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imagePath != nil) {
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
            [formData appendPartWithFileData:data name:@"icon" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WilloAPIV2 getDump:^(){
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });
            ((UIButton *)sender).userInteractionEnabled = YES;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"編輯個人資料"
                                                            message:@"修改個人資料完成"
                                                           delegate:self
                                                  cancelButtonTitle:@"好"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        ((UIButton *)sender).userInteractionEnabled = YES;
    }];

}

- (IBAction)showEditServiceArea:(UITapGestureRecognizer *)sender {
    NSLog(@"showEditServiceArea");
    UITextField * tv = (UITextField *)sender.view;
    [tv resignFirstResponder];
    [self performSegueWithIdentifier:@"segueEditUserProfileToServiceArea" sender:self];
}

- (IBAction)showEditServiceItem:(UITapGestureRecognizer *)sender {
    NSLog(@"showEditServiceItem");
    UITextField * tv = (UITextField *)sender.view;
    [tv resignFirstResponder];
    [self performSegueWithIdentifier:@"segueEditUserProfileToServiceItem" sender:self];
}


- (IBAction)showLicense:(UITapGestureRecognizer *)sender {
    NSLog(@"showLicense");
    UITextField * tv = (UITextField *)sender.view;
    [tv resignFirstResponder];
    [self performSegueWithIdentifier:@"segueEditUserProfileToUserPhoto" sender:self];
}


- (IBAction)choosePicFromMedia:(id)sender {
    //設定MediaType類型(不做此設定會自動忽略圖庫中的所有影片)
    
    // NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    // imagePicker.mediaTypes = mediaTypes;
    
    //設定開啓圖庫的類型(預設圖庫/全部/新拍攝)
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //以動畫方式顯示圖庫
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//UIImagePickerController內建函式
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //取得使用的檔案格式
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        //取得圖片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *resizedImage = [AppDelegate resizeImageToSize:600 sourceImage:image];
//        [self.userIcon setImage:resizedImage];
        [self.userHeadIcon setImage:resizedImage];
        //obtaining saving path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        imagePath = [documentsDirectory stringByAppendingPathComponent:@"photo.jpg"];
        [AppDelegate saveImage:resizedImage withFileName:@"photo" ofType:@"jpg" inDirectory:documentsDirectory];
        
        /*
         //extracting image from the picker and saving it
         NSData *webData = UIImagePNGRepresentation(image);
         [webData writeToFile:imagePath atomically:YES];
         */
    }
    /*
     if ([mediaType isEqualToString:@"public.movie"]) {
     
     //取得影片位置
     // videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
     }
     */
    
    
    //已動畫方式返回先前畫面
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}



- (BOOL)checkPassword:(NSString*) password

{

NSString *pattern =@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,12}";

NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];

BOOL isMatch = [pred evaluateWithObject:password];

return isMatch;

}

@end
