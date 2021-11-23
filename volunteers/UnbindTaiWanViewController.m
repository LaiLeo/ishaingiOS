//
//  UnbindTaiWanViewController.m
//  volunteers
//
//  Created by NJUser on 2021/10/28.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import "UnbindTaiWanViewController.h"
#import "LogHeader.h"
#import "LoginServer.h"
#import "UIView+Toast.h"

@interface UnbindTaiWanViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *realName;
@property(nonatomic,strong)UITextField *email;
@property(nonatomic,strong)UITextField *employeeNumber;
@property(nonatomic,strong)UITextField *identifer;
@property(nonatomic,strong)UITextField *phone;
@property(nonatomic,strong)UITextField *part;
@property(nonatomic,strong)UITextField *enterpriseSerialType;
@property(nonatomic,strong)UITextField *enterpsiseSerialGroup;
@property (strong,nonatomic)UIScrollView *baseView;

@property(nonatomic,strong)UIButton *logButton;

@end

@implementation UnbindTaiWanViewController{
    int movementDistance;
    UITextField *selectTextField;
    CGSize keyboardSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatBackButton];
    [self setUI];
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
   
    self.baseView = [[UIScrollView alloc]init];
    self.baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.baseView];
    if ((lz_iPhoneX || lz_iPhoneXr || lz_iPhoneXs || lz_iPhoneXsMax)) {
        [ self.baseView setFrame:CGRectMake(0, 44+35, kScreenW,kScreenH)];

    }else{
        [ self.baseView setFrame:CGRectMake(0, 44+20, kScreenW,kScreenH)];

    }
    [self.baseView setContentSize:CGSizeMake(kScreenW, kScreenH+340)];

   
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
    [self.baseView addGestureRecognizer:tap];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-250)/2, 44, 250, 30)];
    titleLabel.text=@"我是台灣大哥大員工";
    titleLabel.font =[UIFont boldSystemFontOfSize:25];
    titleLabel.textAlignment =NSTextAlignmentCenter ;
    titleLabel.textColor = [UIColor blackColor];
    [self.baseView addSubview:titleLabel];
    
    UIImageView *fubonImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame)-20, 44, 30, 30)];
    fubonImage.image = [UIImage imageNamed:@"taiwan_logo_login_small"];
    [self.baseView addSubview:fubonImage];
    
    
    self.realName = [self creatTitle:@"真實姓名，中文或英文" y:134 baseView:self.baseView];
    self.email = [self creatTitle:@"電子信箱" y:134+80 baseView:self.baseView];
    self.employeeNumber = [self creatTitle:@"員工編號" y:134+80*2 baseView:self.baseView];
    self.identifer = [self creatTitle:@"身份證字號" y:134+80*3 baseView:self.baseView];
    self.phone = [self creatTitle:@"電話" y:134+80*4 baseView:self.baseView];
    self.part = [self creatTitle:@"部門" y:134+80*5 baseView:self.baseView];
    self.enterpriseSerialType = [self creatTitle:@"公司別" y:134+80*6 baseView:self.baseView];
    self.enterpsiseSerialGroup = [self creatTitle:@"企業誌工分組" y:134+80*7 baseView:self.baseView];
    
    UIButton * logButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 134+80*8+30, kScreenW-40, 50)];
    logButton.backgroundColor = [UIColor colorWithRed:0 green:153/255.0 blue:204/255.0 alpha:1.0];
    [logButton setTitle:@"確定" forState:UIControlStateNormal];
    [logButton addTarget:self action:@selector(unbindAction:) forControlEvents:UIControlEventTouchUpInside];
    logButton.layer.cornerRadius = 25.0f;
    self.logButton = logButton;
    [self.baseView addSubview:logButton];
    
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(logButton.frame)+20, kScreenW-40, 50)];
    backButton.backgroundColor = [UIColor whiteColor];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:0 green:153/255.0 blue:204/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backButton.layer.cornerRadius = 25.0f;
    backButton.layer.borderColor = [UIColor colorWithRed:0 green:153/255.0 blue:204/255.0 alpha:1.0].CGColor;
    backButton.layer.borderWidth = 1;
    backButton.layer.masksToBounds = YES;
    [self.baseView addSubview:backButton];
    
}

-(void)unbindAction:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    if ([self.employeeNumber.text length] == 0) {
        [self.view makeToast:@"請輸入員工編號" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if ([self.email.text length] == 0) {
        [self.view makeToast:@"請輸入電子郵件" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if ([self.part.text length] == 0) {
        [self.view makeToast:@"請輸入部門" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if ([self.realName.text length] == 0) {
        [self.view makeToast:@"請輸入真實姓名，中文或英文" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if ([self.identifer.text length] == 0) {
        [self.view makeToast:@"請輸入身份證字號" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if ([self.phone.text length] == 0) {
        [self.view makeToast:@"請輸入電話" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if ([self.enterpriseSerialType.text length] == 0) {
        [self.view makeToast:@"請輸入公司別" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if ([self.enterpsiseSerialGroup.text length] == 0) {
        [self.view makeToast:@"請輸入企業誌工分組" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    
    [[LoginServer shareInstance]PostTaiwanMemberBindWithEnterpriseSerialNumber:self.employeeNumber.text enterpriseSerialEmail:self.email.text enterpriseSerialDepartment:self.part.text enterpriseSerialName:self.realName.text enterpriseSerialId:self.identifer.text enterpriseSerialPhone:self.phone.text enterpriseSerialType:self.enterpriseSerialType.text enterpriseSerialGroup:self.enterpsiseSerialGroup.text success:^(NSDictionary * _Nonnull dic) {
        NSArray *errorsArray = dic[@"errors"];
        NSString *username = dic[@"enterpriseSerialNumber"];
        for (NSDictionary *item in errorsArray) {
            NSString *error = item[@"error"];
            NSLog(@"error%@",error);
           
            if ([error isEqualToString:@"twmAlreadyBindUser"]) {
                [self.view makeToast:@"此台湾大哥大员工资料已绑定其他帐号" duration:2.0 position:@"CSToastPositionCenter"];

            }
            if ([error isEqualToString:@"twmAlreadyBind"]) {
                [self.view makeToast:@"您的帐号已绑定此台湾大哥大员工资料" duration:2.0 position:@"CSToastPositionCenter"];
            }
            if ([error isEqualToString:@"userNotFound"]) {
                [self.view makeToast:@"您輸入的賬號或密碼有誤，請重新輸入" duration:2.0 position:@"CSToastPositionCenter"];
            }
            

        }
        [self.view makeToast:@"success" duration:2.0 position:@"CSToastPositionCenter"];

    } failure:^(NSError * _Nonnull error) {
       NSData *data = error.userInfo[@"com.alamofire.error.serialization.response.error.data"];
        NSString *errorStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"台湾大哥大会员绑定%@",errorStr);

        [self.view makeToast:@"failure" duration:2.0 position:@"CSToastPositionCenter"];
    }];
    btn.userInteractionEnabled = YES;
}
-(void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];

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
-(void)dismissKeyboard {
    
    [self.realName resignFirstResponder];
    [self.email resignFirstResponder];
    [self.employeeNumber resignFirstResponder];
    [self.identifer resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.part resignFirstResponder];
    [self.enterpriseSerialType resignFirstResponder];
    [self.enterpsiseSerialGroup resignFirstResponder];
   
    
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
@end
