//
//  ForgetPasswordViewController.m
//  volunteers
//
//  Created by jauyou on 2015/1/30.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//
#import <JSONKit.h>
#import <MBProgressHUD.h>
#import "ForgetPasswordViewController.h"
#import "WilloAPIV2.h"
#import "LoginServer.h"
#import "ServerConfig.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController
{
    int movementDistance;
    UITextField *selectTextField;
    CGSize keyboardSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (void)dismissKeyboard {
    [self.account resignFirstResponder];
}

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doSubmit:(id)sender {
    if (![self NSStringIsValidEmail:self.account.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"格式錯誤" message:@"電子郵件格式錯誤請重新輸入" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self resetPasswordWithAccount:self.account.text Sender:sender];
}

- (void)resetPasswordWithAccount:(NSString *)account Sender:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"username": self.account.text};
    NSString *accessPage = [NSString stringWithFormat:@"%@user/resetPassword",ServerConfig.base_url];
    [[LoginServer shareInstance]forgetPassword:self.account.text accessPage:accessPage success:^(NSDictionary * _Nonnull dic) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"忘記密碼" message:@"密碼重設信件已寄出" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert.tag = 1;
        
        sender.userInteractionEnabled = YES;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    } failure:^(NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"忘記密碼" message:@"帳號不存在" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert.tag = 1;
        sender.userInteractionEnabled = YES;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }];
//    [WilloAPIV2 resetAccountPasswordParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (operation.response.statusCode == 200) {
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"忘記密碼" message:@"密碼重設信件已寄出" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert.tag = 1;
//
//            sender.userInteractionEnabled = YES;
//            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//                // Do something...
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                });
//            });
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"My Error: %@", operation.responseString);
//        NSLog(@"Error: %@", error);
//
//        if (operation.response.statusCode == 404) {
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"忘記密碼" message:@"帳號不存在" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert.tag = 1;
//        }
//
//        sender.userInteractionEnabled = YES;
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//            // Do something...
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            });
//        });
//    }];
}

- (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
