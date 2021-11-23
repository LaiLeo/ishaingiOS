//
//  LoginViewController.m
//  volunteers
//
//  Created by jauyou on 2015/1/27.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <JSonKit.h>
#import <MBProgressHUD.h>
#import "LoginViewController.h"
#import "WilloAPIV2.h"
#import "FuBonLoginViewController.h"
#import "RegistAccountViewController.h"
#import "ForgetPasswordViewController.h"
#import "WebViewController.h"
#import "LoginServer.h"
#import "UIView+Toast.h"
#import "UserProfileData.h"

@interface LoginViewController ()
@property(nonatomic,assign) UIModalPresentationStyle modalPresentationStyle API_AVAILABLE(ios(3.2));

@end

@implementation LoginViewController
{
    int movementDistance;
    UITextField *selectTextField;
    CGSize keyboardSize;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginButton.hidden = YES;
    self.registerButton.hidden = YES;
    self.forgetPasswordButton.hidden = YES;
    //使用NSNotificationCenter 鍵盤出現時
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
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.account.text = [defaults stringForKey:@"account"];
    [self setView];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.messageLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setView{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *emptyView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 30)];
    self.account.leftView=emptyView;
    self.account.leftViewMode=UITextFieldViewModeAlways;
    
    UIView *emptyView2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 30)];
    self.password.leftView=emptyView2;
    self.password.leftViewMode=UITextFieldViewModeAlways;
    
    UIButton *forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-120, CGRectGetMaxY(self.password.frame)+60, 120, 16)];
    [forgetBtn setTitle:@"忘記密碼?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor colorWithRed:54/255.0 green:151/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    [self.view addSubview:forgetBtn];
    [forgetBtn addTarget:self action:@selector(forgetAct) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * logButton = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(forgetBtn.frame)+14, screenWidth-40, 50)];
    logButton.backgroundColor = [UIColor orangeColor];
    [logButton setTitle:@"登入" forState:UIControlStateNormal];
    [logButton addTarget:self action:@selector(logAction:) forControlEvents:UIControlEventTouchUpInside];
    logButton.layer.cornerRadius = 25.0f;
    [self.view addSubview:logButton];
    
    UILabel *registeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(logButton.frame)+30, screenWidth/2, 16)];
    registeLabel.text=@"沒有帳號嗎?";
    registeLabel.font =[UIFont boldSystemFontOfSize:16];
    registeLabel.textAlignment =NSTextAlignmentRight ;
    registeLabel.textColor = [UIColor blackColor];
    [self.view addSubview:registeLabel];
    
    UIButton *zhuceBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(registeLabel.frame)+10, CGRectGetMaxY(logButton.frame)+30, 80, 16)];
    [zhuceBtn setTitle:@"註冊會員" forState:UIControlStateNormal];
    [zhuceBtn setTitleColor:[UIColor colorWithRed:54/255.0 green:151/255.0 blue:255/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    [zhuceBtn addTarget:self action:@selector(RegisterAgreeAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhuceBtn];

    UILabel *otherAcountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(registeLabel.frame)+20, screenWidth, 20)];
    otherAcountLabel.text=@"-------以其他帳號登入------";
    otherAcountLabel.font =[UIFont boldSystemFontOfSize:15];
    otherAcountLabel.textAlignment =NSTextAlignmentCenter ;
    otherAcountLabel.textColor = [UIColor grayColor];
    [self.view addSubview:otherAcountLabel];
    
    
    UIButton * fobonButton = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(otherAcountLabel.frame)+20, screenWidth-60, 50)];
    fobonButton.backgroundColor = [UIColor whiteColor];
     [fobonButton setTitle:@"我是富邦愛心志工社會員" forState:UIControlStateNormal];
    [fobonButton setTitleColor:[UIColor blackColor] forState:0];
     [fobonButton addTarget:self action:@selector(fobonAction:) forControlEvents:UIControlEventTouchUpInside];
    fobonButton.layer.borderWidth = 1;
    fobonButton.layer.borderColor = [[UIColor grayColor] CGColor];
    fobonButton.layer.cornerRadius = 25.0f;
    fobonButton.layer.masksToBounds = YES;
     [self.view addSubview:fobonButton];
    
    UIImageView *fubonImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 15, 20, 20)];
    fubonImage.image = [UIImage imageNamed:@"fubon_logo_login_small"];
    [fobonButton addSubview:fubonImage];

    
    UIButton * taiwanButton = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(fobonButton.frame)+20, screenWidth-60, 50)];
    taiwanButton.backgroundColor = [UIColor whiteColor];
    [taiwanButton setTitle:@"我是台灣大哥大會員" forState:UIControlStateNormal];
    [taiwanButton setTitleColor:[UIColor blackColor] forState:0];

    [taiwanButton addTarget:self action:@selector(taiwanAction:) forControlEvents:UIControlEventTouchUpInside];
    taiwanButton.layer.borderWidth = 1;
    taiwanButton.layer.borderColor = [[UIColor grayColor] CGColor];
    taiwanButton.layer.cornerRadius = 25.0f;
    taiwanButton.layer.masksToBounds = YES;
    [self.view addSubview:taiwanButton];
    
    UIImageView *taiwanImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 15, 20, 20)];
    taiwanImage.image = [UIImage imageNamed:@"taiwan_logo_login_small"];
    [taiwanButton addSubview:taiwanImage];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)logAction:(id)sender {
    self.messageLabel.hidden = true;
    if ([self.account.text length] == 0) {
        self.messageLabel.hidden = false;
        self.messageLabel.text = @"請輸入電子郵件";
        return;
    }
    if (![self NSStringIsValidEmail:self.account.text] && ![self.account.text isEqualToString:@"admin"]) {
        self.messageLabel.hidden = false;
        self.messageLabel.text = @"電子郵件格式錯誤請重新輸入";
        return;
    }
    
    if ([self.password.text length] == 0) {
        self.messageLabel.hidden = false;
        self.messageLabel.text = @"請輸入密碼";
        return;
    }

    [self loginWithAccount:self.account.text Password:self.password.text Sender:sender];
}
-(void)fobonAction:(id)sender{
    FuBonLoginViewController *fuBonVC = [[FuBonLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:fuBonVC];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nav animated:YES completion:nil];
    

}
-(void)taiwanAction:(id)sender{
    WebViewController *web = [[WebViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:web];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nav animated:YES completion:nil];

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
    [self.account resignFirstResponder];
    [self.password resignFirstResponder];
}


//登入
- (IBAction)doLogin:(id)sender {
    
    self.messageLabel.hidden = true;
    if ([self.account.text length] == 0) {
        self.messageLabel.hidden = false;
        self.messageLabel.text = @"請輸入電子郵件";
        return;
    }
    if (![self NSStringIsValidEmail:self.account.text] && ![self.account.text isEqualToString:@"admin"]) {
        self.messageLabel.hidden = false;
        self.messageLabel.text = @"電子郵件格式錯誤請重新輸入";
        return;
    }
    
    if ([self.password.text length] == 0) {
        self.messageLabel.hidden = false;
        self.messageLabel.text = @"請輸入密碼";
        return;
    }

    [self loginWithAccount:self.account.text Password:self.password.text Sender:sender];
}

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginWithAccount:(NSString *) account Password:(NSString *) password Sender:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *devToken = [userDefaults stringForKey:@"deviceToken"];
    
    [userDefaults removeObjectForKey:@"expiresIn"];
    [userDefaults synchronize];
    
    NSDictionary *parameters;
    if (devToken == nil) {
        parameters = @{@"username": account,
                       @"password": password};
    } else {
        parameters = @{@"username": account,
                       @"password": password,
                       @"device_name": @"ios",
                       @"uuid": devToken};
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WilloAPIV2 loginParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:account forKey:@"account"];
            
            NSString *response = operation.responseString;
            NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
            
            JSONDecoder* decoder = [[JSONDecoder alloc]
                                    initWithParseOptions:JKParseOptionLooseUnicode];
            NSDictionary* json = [decoder mutableObjectWithData:jsonData];
            NSString *token = [json objectForKey:@"token"];
            [userDefaults setObject:token forKey:@"token"];
            
            
            [userDefaults synchronize];

            [WilloAPIV2 getDump:^void(){
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    // Do something...
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    });
                });
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
                        [[LoginServer shareInstance]GetPersonInformationToken:token Success:^(NSDictionary * _Nonnull dic) {
                            [UserProfileData saveProfile:dic];
                            [self.view makeToast:@"success" duration:2.0 position:@"CSToastPositionCenter"];
            
                                    } failure:^(NSError * _Nonnull error) {
                                        [self.view makeToast:@"failure" duration:2.0 position:@"CSToastPositionCenter"];
            
                                    }];
            sender.userInteractionEnabled = YES;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"My Error: %@", operation.responseString);
        NSLog(@"Error: %@", error);
        
        if ([operation.response statusCode] == 400) {
            
            self.messageLabel.hidden = false;
            self.messageLabel.text = @"登入失敗";
            self.registerButton.hidden = true;
            self.forgetPasswordButton.hidden = YES;
            self.password.text = @"";
            
        }
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        sender.userInteractionEnabled = YES;
    }];
    //新登录API
    
    
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
//注册会员
-(void)RegisterAgreeAct{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistAccountViewController *vc = [sb instantiateViewControllerWithIdentifier:@"registAccountViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}
//忘记密码
-(void)forgetAct{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgetPasswordViewController *vc = [sb instantiateViewControllerWithIdentifier:@"forgetPasswordViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
