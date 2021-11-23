//
//  RegistAccountViewController.m
//  volunteers
//
//  Created by jauyou on 2015/1/31.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <MBProgressHUD.h>
#import "RegistAccountViewController.h"
#import "WilloAPIV2.h"
#import "LoginServer.h"
#import "UIView+Toast.h"
#import "MainTabBarViewController.h"

@interface RegistAccountViewController ()

@end

@implementation RegistAccountViewController
{
    int movementDistance;
    UITextField *selectTextField;
    CGSize keyboardSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.checkButton.tag = 0;
    
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
    if (self.type == 1) {
        self.account.enabled = NO;
        self.account.text = self.fubonAccount;

    }else{
        self.account.enabled = YES;

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (IBAction)buttonClicked:(id)sender {
    if (self.checkButton.tag == 0) {
        self.checkButton.tag = 1;
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox_select.png"] forState:UIControlStateNormal];
    } else {
        self.checkButton.tag = 0;
        [self.checkButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)registAccount:(id)sender {
    if ([self.account.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"必填資料" message:@"請輸入電子郵件" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![self NSStringIsValidEmail:self.account.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"格式錯誤" message:@"電子郵件格式錯誤請重新輸入" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.password.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"必填資料" message:@"請輸入密碼" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([self.confirmPassword.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"必填資料" message:@"請輸入確認密碼" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![self checkPassword:self.password.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"必填資料" message:@"請輸入位數8-12碼英數字混合密碼" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![self.password.text isEqualToString:self.confirmPassword.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密碼錯誤" message:@"您輸入的密碼與確認密碼不符，請重新輸入" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        self.password.text = nil;
        self.confirmPassword.text = nil;
        return;
    }
    
    if (self.checkButton.tag == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"同意條款" message:@"請確認詳閱、了解並接受徵志工APP服務條款" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self registEmail:self.account.text Password:self.password.text sender:sender];
}

- (void)registEmail:(NSString *)email Password:(NSString *)password sender:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
        NSDictionary *parameters = @{@"username": email,
                                     @"password": password,
                                     @"password2": password};

   
//注册富邦
    
    if (self.type == 1) {
//        NSDictionary *parameters = @{@"username": self.fubonAccount,
//                                     @"password": password,
//                                     @"password2": password};
        [[LoginServer shareInstance]PostRegisteWithUserName:email PassCode:password FirstName:@"" LastName:@"" AccessCode:self.accessCode Email:email isSuperuser:@"" isStaff:@"" twmAccount:@"" success:^(NSArray * _Nonnull dic) {

                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:email forKey:@"account"];
                    [userDefaults synchronize];
            for (NSDictionary *item in dic) {
                for (NSString *key in item) {
                    if ([key isEqualToString:@"errors"]) {
                        for (NSArray *arr in item[@"errors"]) {
                            for (NSDictionary *dec in arr) {
                                NSString *description = dec[@"deccription"];
                                [self.view makeToast:description duration:2.0 position:@"CSToastPositionCenter"];

                            }

                        }
                    }
                    if ([key isEqualToString:@"id"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"註冊成功"
                                                                        message:@"註冊成功請使用註冊帳號登入"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                NSLog(@"%@ : %@", key, [item objectForKey:key]);
                }

            }
                    sender.userInteractionEnabled = YES;
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        // Do something...
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        });
                    });
                        } failure:^(NSError * _Nonnull error) {
                            [self.view makeToast:@"failure" duration:2.0 position:@"CSToastPositionCenter"];
                        }];
    }else{
        
        [WilloAPIV2 registAccountParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (operation.response.statusCode == 201) {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:email forKey:@"account"];
                [userDefaults synchronize];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"註冊成功"
                                                                message:@"註冊成功請使用註冊帳號登入"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                alert.tag = 1;
            }
            sender.userInteractionEnabled = YES;
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"My Error: %@", operation.responseString);
            NSLog(@"Error: %@", error);

            
            if (operation.error.code == -1009 || operation.error.code == -1004) {
                // 沒有網路
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"網路" message:@"沒有網路" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            } else if([operation.response statusCode] == 400) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"註冊失敗"
                                                                message:operation.responseString
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            sender.userInteractionEnabled = YES;
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });
        }];
    }
    
}

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (alertView.tag == 1) {
//        if (self.type == 1) {
//            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
//            [self presentViewController:vc animated:YES completion:nil];
//        }
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma 正则匹配用户密码6-12位数字和字母组合
//^ 匹配一行的开头位置
//(?![0-9]+$) 预测该位置后面不全是数字
//(?![a-zA-Z]+$) 预测该位置后面不全是字母
//[0-9A-Za-z] {8,16} 由8-16位数字或这字母组成
//$ 匹配行结尾位置
- (BOOL)checkPassword:(NSString*) password

{

NSString *pattern =@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,12}";

NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];

BOOL isMatch = [pred evaluateWithObject:password];

return isMatch;

}
// 大小写数字判断
- (BOOL)judgePassWordLegal:(NSString *)pass {

    // 验证密码长度
    if(pass.length < 8 || pass.length > 12) {
        NSLog(@"请输入8-12的密码");
        return NO;
    }
   
    // 验证密码是否包含数字
    NSString *numPattern = @".*\\d+.*";
    NSPredicate *numPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numPattern];
    if (![numPred evaluateWithObject:pass]) {
        NSLog(@"密码必须包含数字");
        return NO;
    }

    // 验证密码是否包含小写字母
    NSString *lowerPattern = @".*[a-z]+.*";
    NSPredicate *lowerPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", lowerPattern];
    if (![lowerPred evaluateWithObject:pass]) {
        NSLog(@"密码必须包含小写字母");
        return NO;
    }
   
    // 验证密码是否包含大写字母
    NSString *upperPattern = @".*[A-Z]+.*";
    NSPredicate *upperPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", upperPattern];
    if (![upperPred evaluateWithObject:pass]) {
        NSLog(@"密码必须包含大写字母");
        return NO;
    }
    
    return YES;
}
@end
