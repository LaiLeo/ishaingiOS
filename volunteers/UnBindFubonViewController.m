//
//  UnBindFubonViewController.m
//  volunteers
//
//  Created by NJUser on 2021/10/28.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//
#import <JSonKit.h>
#import <MBProgressHUD.h>
#import "UnBindFubonViewController.h"
#import "VolunteersServers.h"
#import "UIView+Toast.h"
#import "LoginServer.h"
#import "RegistAccountViewController.h"
#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import "UserProfileData.h"

@interface UnBindFubonViewController ()
@property(nonatomic,strong)UITextField *account;
@property(nonatomic,strong)UITextField *password;
@property(nonatomic,strong)UIButton *logButton;
@property(nonatomic,assign)NSInteger typeFu;
@end

@implementation UnBindFubonViewController{
    int movementDistance;
    UITextField *selectTextField;
    CGSize keyboardSize;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.logButton.userInteractionEnabled = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.typeFu = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    // 鍵盤消失時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self creatBackButton];
    [self setUI];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
//       NSForegroundColorAttributeName:UIColor.blackColor}];
//}
//-(void)viewWillDisappear:(BOOL)animated{
//   [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
//   }
-(void)creatBackButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置frame
    button.frame = CGRectMake(0, 0, 50, 50);
    //  [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 10)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(backAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.userInteractionEnabled = YES;
    UIBarButtonItem *btnItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=btnItem;
}
-(void)backAction:(UIButton *)btn{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)setUI{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIImageView *fubonImage = [[UIImageView alloc]initWithFrame:CGRectMake((screenWidth-100)/2, 94, 100, 100)];
    fubonImage.image = [UIImage imageNamed:@"fubon_logo_login_big"];
    [self.view addSubview:fubonImage];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(fubonImage.frame)+30, screenWidth, 30)];
    titleLabel.text=@"我是富邦愛心志工社會員";
    titleLabel.font =[UIFont boldSystemFontOfSize:25];
    titleLabel.textAlignment =NSTextAlignmentCenter ;
    titleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:titleLabel];
    
    self.account = [self creatTitle:@"電子信箱" y:270 baseView:self.view];
    self.password = [self creatTitle:@"密碼" y:340 baseView:self.view];
    self.password.secureTextEntry = YES;
    
    UIButton * logButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 480, screenWidth-40, 50)];
    logButton.backgroundColor = [UIColor colorWithRed:0 green:153/255.0 blue:204/255.0 alpha:1.0];
    [logButton setTitle:@"確定" forState:UIControlStateNormal];
    [logButton addTarget:self action:@selector(logFubonAction:) forControlEvents:UIControlEventTouchUpInside];
    logButton.layer.cornerRadius = 25.0f;
    self.logButton = logButton;
    [self.view addSubview:logButton];
    
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(logButton.frame)+20, screenWidth-40, 50)];
    backButton.backgroundColor = [UIColor whiteColor];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:0 green:153/255.0 blue:204/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backButton.layer.cornerRadius = 25.0f;
    backButton.layer.borderColor = [UIColor colorWithRed:0 green:153/255.0 blue:204/255.0 alpha:1.0].CGColor;
    backButton.layer.borderWidth = 1;
    backButton.layer.masksToBounds = YES;
    [self.view addSubview:backButton];
    
}
- (UITextField *)creatTitle:(NSString *)title y:(CGFloat)y baseView:(UIView *)supView{
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(20, y, [UIScreen mainScreen].bounds.size.width-40, 50)];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.layer.cornerRadius = 25;
    baseView.layer.borderWidth = 1;
    baseView.layer.borderColor = [UIColor grayColor].CGColor;
    baseView.layer.masksToBounds = YES;
    [supView addSubview:baseView];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width-80, 50)];
    textField.font = [UIFont systemFontOfSize:14];
    textField.textColor = [UIColor grayColor];
    textField.placeholder = title;
    textField.delegate = self;
    [baseView addSubview:textField];

    return textField;
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
-(void)dismissKeyboard {
    [self.account resignFirstResponder];
    [self.password resignFirstResponder];
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
-(void)logFubonAction:(id)sender {
    if ([self.account.text length] == 0) {
        [self.view makeToast:@"請輸入電子郵件" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if (![self NSStringIsValidEmail:self.account.text] && ![self.account.text isEqualToString:@"admin"]) {
        
        [self.view makeToast:@"電子郵件格式錯誤請重新輸入" duration:2.0 position:@"CSToastPositionCenter"];

        return;
    }
    
    if ([self.password.text length] == 0) {
        [self.view makeToast:@"請輸入密碼" duration:2.0 position:@"CSToastPositionCenter"];

        return;
    }

    [self loginWithAccount:self.account.text Password:self.password.text Sender:sender];
}
- (void)loginWithAccount:(NSString *) account Password:(NSString *) password Sender:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    
    [[LoginServer shareInstance]PostFubonWithUserName:account PassCode:password success:^(NSDictionary * _Nonnull dic) {
        
        NSArray *errorsArray = dic[@"errors"];
        NSString *username = dic[@"enterpriseSerialNumber"];
        for (NSDictionary *item in errorsArray) {
            NSString *error = item[@"error"];
            NSLog(@"error%@",error);
           
            if ([error isEqualToString:@"fubonAlreadyBindUser"]) {
                [self.view makeToast:@"此富邦愛心誌工社會員電子信箱已绑定其他帐号" duration:2.0 position:@"CSToastPositionCenter"];

            }
            if ([error isEqualToString:@"fubonAlreadyBind"]) {
                [self.view makeToast:@"您的帐号已绑定此富邦愛心誌工社會員電子信箱" duration:2.0 position:@"CSToastPositionCenter"];
            }
            if ([error isEqualToString:@"userNotFound"]) {
                [self.view makeToast:@"您輸入的賬號或密碼有誤，請重新輸入" duration:2.0 position:@"CSToastPositionCenter"];
            }
        }
        } failure:^(NSError * _Nonnull error) {
            [self.view makeToast:@"failure" duration:2.0 position:@"CSToastPositionCenter"];

        }];
    sender.userInteractionEnabled = YES;
}
-(void)LoginResultConfigWithJSON:(NSDictionary *)json{
    

      NSLog(@"%@",json);
//      [[QYJClienServer shareClient]loginAcountWithJsonData:json sourceController:self];
}

-(BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
