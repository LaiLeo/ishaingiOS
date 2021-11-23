//
//  RegistEventViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/3.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "RegistEventViewController.h"
#import "WilloAPIV2.h"
#import "SkillsHabitsViewController.h"
#import "volunteers-Swift.h"
#import "UIView+Toast.h"

@interface RegistEventViewController ()
{
    NSMutableArray *_KTVArray;


}
@property(nonatomic,strong) UILabel *guardianNameTipView;//FIH-add for Add Guardian Information 
@property(nonatomic,strong) UILabel *guardianPhoneTipView;//FIH-add for Add Guardian Information 
@property(nonatomic,strong) UILabel *PersionIDTipView;//FIH-add for Add Guardian Information
@property(nonatomic,strong) UILabel *emplyeeTipView;//FIH-add for Add Guardian Information
@property(nonatomic,strong) UILabel *enterpriseTipView;//FIH-add for Add Guardian Information

@end

@implementation RegistEventViewController
{
    long long birthInMiniSecond;
    UIDatePicker *datePicker;
    NSLocale *dateLocale;
    
    int eventId;
    int skill_pk;
    NSString *skills;
    NSMutableArray* skillGroupArray;
    
    int movementDistance;
    UITextField *selectTextField;
    CGSize keyboardSize;
    bool isEnterprise;
    bool isResourceEvent;
    bool isInsuranceEvent;//FIH-add for 身份有勾需要保險資料判断

}
@synthesize eventId;
@synthesize skill_pk;
@synthesize skills;
@synthesize isEnterprise;
@synthesize isResourceEvent;
@synthesize isInsuranceEvent;//FIH-add for 身份有勾需要保險資料判断

- (void)viewDidLoad {
    [super viewDidLoad];
    //FIH-add for 必填星号提醒 start
    UILabel *nameTipView = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.name.frame)+10, 10, 10)];
    nameTipView.text = @"*";
    nameTipView.textColor = [UIColor redColor];
    nameTipView.font = [UIFont systemFontOfSize:10];

    [self.scrowView addSubview:nameTipView];
    UILabel *phoneTipView = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.phone.frame)+10, 10, 10)];
    phoneTipView.text = @"*";
    phoneTipView.textColor = [UIColor redColor];
    phoneTipView.font = [UIFont systemFontOfSize:10];
    [self.scrowView addSubview:phoneTipView];
    UILabel *emailTipView = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.email.frame)+10, 10, 10)];
    emailTipView.text = @"*";
    emailTipView.textColor = [UIColor redColor];
    emailTipView.font = [UIFont systemFontOfSize:10];
    [self.scrowView addSubview:emailTipView];
    UILabel *birthTipView = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.birth.frame)+10, 10, 10)];
    birthTipView.text = @"*";
    birthTipView.textColor = [UIColor redColor];
    birthTipView.font = [UIFont systemFontOfSize:10];
    [self.scrowView addSubview:birthTipView];
    UILabel *PersionIDTipView = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.PersionID.frame)+10, 10, 10)];
    PersionIDTipView.text = @"*";
    PersionIDTipView.textColor = [UIColor redColor];
    PersionIDTipView.font = [UIFont systemFontOfSize:10];
    self.PersionIDTipView = PersionIDTipView;
    [self.scrowView addSubview:PersionIDTipView];
    UILabel *guardianNameTipView = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.guardianName.frame)+10, 10, 10)];
    guardianNameTipView.text = @"*";
    guardianNameTipView.textColor = [UIColor redColor];
    guardianNameTipView.font = [UIFont systemFontOfSize:10];
    self.guardianNameTipView = guardianNameTipView;
    [self.scrowView addSubview:guardianNameTipView];
    UILabel *guardianPhoneTipView = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.guardianPhone.frame)+10, 10, 10)];
    guardianPhoneTipView.text = @"*";
    guardianPhoneTipView.textColor = [UIColor redColor];
    guardianPhoneTipView.font = [UIFont systemFontOfSize:10];
    self.guardianPhoneTipView = guardianPhoneTipView;
    [self.scrowView addSubview:guardianPhoneTipView];
    UILabel *enterpriseTipView = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.enterpriseSerialNumber.frame)+10, 10, 10)];
    enterpriseTipView.text = @"*";
    enterpriseTipView.textColor = [UIColor redColor];
    enterpriseTipView.font = [UIFont systemFontOfSize:10];
    self.enterpriseTipView = enterpriseTipView;
    [self.scrowView addSubview:enterpriseTipView];
    UILabel *emplyeeTipView = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.employeeSerialNumber.frame)+10, 10, 10)];
    emplyeeTipView.text = @"*";
    emplyeeTipView.textColor = [UIColor redColor];
    emplyeeTipView.font = [UIFont systemFontOfSize:10];
    self.emplyeeTipView = emplyeeTipView;
    [self.scrowView addSubview:emplyeeTipView];
    //FIH-add for 必填星号提醒 end
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

    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *user = appDelegate.user;
    self.name.text = [user valueForKey:@"name"];
    self.phone.text = [user valueForKey:@"phone"];
    self.email.text = [user valueForKey:@"email"];
    self.birth.text = [user valueForKey:@"birthday"];
    self.PersionID.text = [user valueForKey:@"security_id"];
    self.guardianName.text = [user valueForKey:@"guardian_name"];
    self.guardianPhone.text = [user valueForKey:@"guardian_phone"];
    
    if(isResourceEvent){
        self.registTitle.text = @"認捐報名";
    }
    

    birthInMiniSecond = 0;
    [self checkAdultSetDate:false];
    
    if (isEnterprise){
        self.emplyeeTipView.hidden = NO;
        self.enterpriseTipView.hidden = NO;
        self.enterpriseSerialNumber.hidden = NO;
        self.employeeSerialNumber.hidden = NO;
    }else{
        self.emplyeeTipView.hidden = YES;
        self.enterpriseTipView.hidden = YES;
        self.enterpriseSerialNumber.hidden = YES;
        self.employeeSerialNumber.hidden = YES;
    }
    
    self.serviceArea.text = [user valueForKey:@"interest"];
    self.serviceItem.text = [user valueForKey:@"skills_description"];

    
    self.birth.delegate = self;
    // 建立 UIDatePicker
    datePicker = [[UIDatePicker alloc]init];
    // 時區的問題請再找其他協助 不是本篇重點
    dateLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.locale = dateLocale;
    datePicker.datePickerMode = UIDatePickerModeDate;
    // 以下這行是重點 (螢光筆畫兩行) 將 UITextField 的 inputView 設定成 UIDatePicker
    // 則原本會跳出鍵盤的地方 就改成選日期了
    self.birth.inputView = datePicker;
    
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;

    
    [self refreshItemsBlock];
    [self initSkillGroupArray];
    
}

- (void)initSkillGroupArray {
    NSArray* arr = [self.event valueForKey:@"skill_groups"];
    skillGroupArray = [[NSMutableArray alloc] initWithCapacity:arr.count];
    for(int i = 0; i < arr.count ; i ++){
        [skillGroupArray addObject:@(0)];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([segue.identifier isEqualToString:@"segueRegistEventToServiceArea"]) {
        NSLog(@"可服務區域");
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
            self.serviceArea.text = result;
        };
        destViewController.skillHabitString = self.serviceArea.text;
    }else if([segue.identifier isEqualToString:@"segueRegistEventToServiceItem"]){
        NSLog(@"可服務項目");
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
            self.serviceItem.text = result;
        };
        destViewController.skillHabitString = self.serviceItem.text;
        
    }else{
        NSLog(@"?!QAQ");
    }
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle{
    return UIUserInterfaceStyleLight;
}

-(void)keyboardWillShow:(NSNotification *) notification{
    NSLog(@"keyboardWillShow");
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
    NSLog(@"textFieldDidBeginEditing");
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


-(void)dismissKeyboard {
    [self.name resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.email resignFirstResponder];
    [self.birth resignFirstResponder];
    [self.PersionID resignFirstResponder];
    [self.guardianName resignFirstResponder];
    [self.guardianPhone resignFirstResponder];
    [self.enterpriseSerialNumber resignFirstResponder];
    [self.employeeSerialNumber resignFirstResponder];
    [self.view resignFirstResponder];
    
}


- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doRegist:(id)sender {
    // temp for py pass unhandle api
    _messageLabel.hidden = true;
    if ([_name.text length] == 0) {
//        _messageLabel.hidden = false;
//        _messageLabel.text = @"請輸入姓名";
        [self.view makeToast:@"請輸入姓名" duration:2.0 position:@"CSToastPositionCenter"];

        return;
    }
    
    if (![self NSStringIsValidName:_name.text]) {
//        _messageLabel.hidden = false;
//        _messageLabel.text = @"姓名格式錯誤請重新輸入";
        [self.view makeToast:@"姓名格式錯誤請重新輸入" duration:2.0 position:@"CSToastPositionCenter"];

        return;
    }
    
    if ([_phone.text length] == 0) {
//        _messageLabel.hidden = false;
//        _messageLabel.text = @"請輸入電話";
        [self.view makeToast:@"請輸入電話" duration:2.0 position:@"CSToastPositionCenter"];

        return;
    }
    
    if (![self NSStringIsValidPhone:_phone.text]) {
//        _messageLabel.hidden = false;
//        _messageLabel.text = @"電話格式錯誤請重新輸入";
        [self.view makeToast:@"電話格式錯誤請重新輸入" duration:2.0 position:@"CSToastPositionCenter"];

        return;
    }
    
    if ([_email.text length] == 0) {
//        _messageLabel.hidden = false;
//        _messageLabel.text = @"請輸入電子郵件";
        [self.view makeToast:@"請輸入電子郵件" duration:2.0 position:@"CSToastPositionCenter"];

        return;
    }
    
    if (![self NSStringIsValidEmail:_email.text]) {
//        _messageLabel.hidden = false;
//        _messageLabel.text = @"電子郵件格式錯誤請重新輸入";
        [self.view makeToast:@"電子郵件格式錯誤請重新輸入" duration:2.0 position:@"CSToastPositionCenter"];

        return;
    }
    
    if (birthInMiniSecond == 0) {
//        _messageLabel.hidden = false;
//        _messageLabel.text = @"請輸入生日";
        [self.view makeToast:@"請輸入生日" duration:2.0 position:@"CSToastPositionCenter"];

        return;
    }
   //FIH-add for 有勾需要保險資料 start
    if (!_PersionID.hidden) {
        if (isInsuranceEvent && [_PersionID.text length] == 0) {
    //        _messageLabel.hidden = false;
    //        _messageLabel.text = @"請輸入身份證";
            [self.view makeToast:@"請輸入身份證" duration:2.0 position:@"CSToastPositionCenter"];

            return;
        }
        
        if (isInsuranceEvent && ![self NSStringIsValidPersionID:_PersionID.text]) {
    //        self.messageLabel.hidden = false;
    //        self.messageLabel.text = @"身分證錯誤請重新輸入";
            [self.view makeToast:@"身分證錯誤請重新輸入" duration:2.0 position:@"CSToastPositionCenter"];

            return;
        }
    }

    //FIH-add for 有勾需要保險資料 end
    
    if (!_PersionID.hidden) {
        if ([_PersionID.text length] == 0) {
    //        _messageLabel.hidden = false;
    //        _messageLabel.text = @"請輸入身份證";
            [self.view makeToast:@"請輸入身份證" duration:2.0 position:@"CSToastPositionCenter"];
            return;
        }
        
        if (![self NSStringIsValidPersionID:_PersionID.text]) {
    //        self.messageLabel.hidden = false;
    //        self.messageLabel.text = @"身分證錯誤請重新輸入";
            [self.view makeToast:@"身分證錯誤請重新輸入" duration:2.0 position:@"CSToastPositionCenter"];

            return;
        }
    }
    
    if (!_guardianName.hidden){
        if ([_guardianName.text length] == 0) {
            [self.view makeToast:@"請輸入監護人姓名" duration:2.0 position:@"CSToastPositionCenter"];
            return;
        }
        
    }
    if (!_guardianPhone.hidden){
        if ([_guardianPhone.text length] == 0) {
            [self.view makeToast:@"請輸入監護人電話" duration:2.0 position:@"CSToastPositionCenter"];
            return;
        }
    }
    
    if (self.agreeButton.tag == 0)
    {
//        _messageLabel.hidden = false;
//        _messageLabel.text = @"請閱讀並同意會員條款";
        [self.view makeToast:@"請閱讀並同意會員條款" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    
    if (isEnterprise && [_enterpriseSerialNumber.text length] == 0){
        
//        _messageLabel.hidden = false;
//        _messageLabel.text = @"請輸入企業代碼";
        [self.view makeToast:@"請輸入企業代碼" duration:2.0 position:@"CSToastPositionCenter"];

        return;
    }
    
    if (isEnterprise && [_employeeSerialNumber.text length] == 0){
        
//        _messageLabel.hidden = false;
//        _messageLabel.text = @"請輸入員工編號";
        [self.view makeToast:@"請輸入員工編號" duration:2.0 position:@"CSToastPositionCenter"];

        return;
    }
    
    NSMutableDictionary *parameters =[[NSMutableDictionary alloc] init];;
    
    [parameters setObject:[NSString stringWithFormat:@"%d", eventId] forKey:@"event_id"];
    [parameters setObject:_name.text forKey:@"name"];
    [parameters setObject:_phone.text forKey:@"phone"];
    [parameters setObject:_email.text forKey:@"email"];
    [parameters setObject:_enterpriseSerialNumber.text forKey:@"enterprise_serial_number"];
    [parameters setObject:_employeeSerialNumber.text forKey:@"employee_serial_number"];
    [parameters setObject:[NSString stringWithFormat:@"%lld", birthInMiniSecond] forKey:@"birthday"];
    if (!_guardianName.hidden){
        [parameters setObject:_guardianName.text forKey:@"guardian_name"];
        [parameters setObject:_guardianPhone.text forKey:@"guardian_phone"];
    }
    if (!_PersionID.hidden) {
        [parameters setObject:_PersionID.text forKey:@"security_id"];

    }
    if (skill_pk != -1 && skill_pk != 0) {
        [parameters setObject:[NSString stringWithFormat:@"%d:1", skill_pk] forKey:@"skillgroup_list"];
    }else if([self isMulptiItemEvent]){

        NSArray* arr = [self.event valueForKey:@"skill_groups"];
        NSInteger totalNumber = 0;

        NSMutableString * list = [[NSMutableString alloc] initWithString:@""];
        for(int i=0;i<arr.count;i++) {
            if(i != 0){
                [list appendString:@","];
            }
            NSDictionary* skill = arr[i];
            NSInteger skill_id = [skill[@"id"] integerValue];
            NSInteger skill_number = [skillGroupArray[i] integerValue];
            [list appendFormat:@"%ld:%ld", (long)skill_id, (long)skill_number];
            
            NSInteger max = [[skill valueForKey:@"volunteer_number"] intValue] - [[skill valueForKey:@"current_volunteer_number"]intValue];
            if(max < skill_number){
//                _messageLabel.hidden = false;
//                _messageLabel.text = @"請輸入正確物資數量";
                [self.view makeToast:@"請輸入正確物資數量" duration:2.0 position:@"CSToastPositionCenter"];

                return;
            }
            totalNumber += skill_number;
            
        }
        
        
        [parameters setObject:list forKey:@"skillgroup_list"];
        if(totalNumber == 0){

//            _messageLabel.hidden = false;
//            _messageLabel.text = @"請輸入正確物資數量 (不得為零)";
            [self.view makeToast:@"請輸入正確物資數量 (不得為零)" duration:2.0 position:@"CSToastPositionCenter"];

            return;
        }
        
        
    }
    
    if (skills != nil) {
        [parameters setObject:skills forKey:@"skill"];
    }
    [parameters setObject:self.serviceArea.text forKey:@"service_area"];
    [parameters setObject:self.serviceItem.text forKey:@"service_item"];


    NSLog(@"register parameters: %@", parameters);
    
    ((UIButton *)sender).userInteractionEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WilloAPIV2 registEventParameters:parameters viewController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", string);
        if (operation.response.statusCode == 200) {
            [WilloAPIV2 getDump:^(){
//                if(event)
                NSString * message;
                if(isResourceEvent){
                    message = @"麻煩請至報名信箱查看「捐贈通知信」了解相關資訊";
                }else{
                    message = @"報名成功";
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                alert.tag = 1;
                [alert show];
                ((UIButton *)sender).userInteractionEnabled = YES;
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    // Do something...
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if(isResourceEvent){
                            [self redirectToShoppingPage];
                        }
                        
                    });
                });
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error Code: %ld\nError: %@", (long)operation.response.statusCode, error);
        NSString *string = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"data: %@", string);
        ((UIButton *)sender).userInteractionEnabled = YES;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        if (operation.response.statusCode == 403) {
            _messageLabel.hidden = false;
            _messageLabel.text = @"報名截止";
        } else if (operation.response.statusCode == 404) {
            _messageLabel.hidden = false;
            _messageLabel.text = @"報名活動不存在";
        } else if (operation.response.statusCode == 405) {
            _messageLabel.hidden = false;
            _messageLabel.text = @"組別已滿";
        }
    }];
}

- (void)redirectToShoppingPage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"我們已將您的愛心告知受贈單位，接下來請您至報名信箱查看「捐贈通知信」。若有物資需求疑問、寄送問題或需索取捐物收據，請洽受贈單位，謝謝！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:okay];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (IBAction)doAgree:(id)sender {
    if (((UIButton *)sender).tag == 1)
    {
        // 不同意
        [self.agreeButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        ((UIButton *)sender).tag = 0;
    } else {
        // 同意
        [self.agreeButton setImage:[UIImage imageNamed:@"checkbox_select"] forState:UIControlStateNormal];
        ((UIButton *)sender).tag = 1;
    }
    
    
}

- (IBAction)showEditServiceArea:(UITapGestureRecognizer *)sender {
    UITextField *tv = (UITextField *)sender.view;
    [tv resignFirstResponder];
    
    [self performSegueWithIdentifier:@"segueRegistEventToServiceArea" sender:self];
    
}

- (IBAction)showServiceItem:(UITapGestureRecognizer *)sender {
    UITextField *tv = (UITextField *)sender.view;
    [tv resignFirstResponder];
    [self performSegueWithIdentifier:@"segueRegistEventToServiceItem" sender:self];
    
}

-(BOOL)NSStringIsValidName:(NSString *)checkString
{
    NSString *nameRegex = @"[^0-9`~!@#\\$%\\^&\\*()\\-_=\\+[{]}\\\\|;:'\\\",<\\.>/\\?]+";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [nameTest evaluateWithObject:checkString];
}

-(BOOL)NSStringIsValidPhone:(NSString *)checkString
{
    NSString *phoneRegex = @"[0-9]{7}[0-9]*";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:checkString];
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

/*
 身分證共有9個數字(N1~N9)加上開頭一個英文字(N0)
 
 N0 N1 N2 N3 N4 N5 N6 N7 N8 N9
 
 N0的英文字代表出生戶籍登記的地區 (不見得是出生地)
 
 英文字與出生地區對照表如下：
 
 Ａ台北市 Ｂ台中市 Ｃ基隆市 Ｄ台南市 Ｅ高雄市 Ｆ台北縣 Ｇ宜蘭縣
 Ｈ桃園縣 Ｉ嘉義市 Ｊ新竹縣 Ｋ苗栗縣 Ｌ台中縣 Ｍ南投縣 Ｎ彰化縣
 Ｏ新竹市 Ｐ雲林縣 Ｑ嘉義縣 Ｒ台南縣 Ｓ高雄縣 Ｔ屏東縣 Ｕ花蓮縣
 Ｖ台東縣 Ｗ金門縣 Ｘ澎湖縣 Ｙ陽明山 Ｚ連江縣
 
 每個英文字有其代表的數字, 用來稍後驗證時用, 其對照表如下：
 A=10 B=11 C=12 D=13 E=14 F=15 G=16
 H=17 I=34 J=18 K=19 L=20 M=21 N=22
 O=35 P=23 Q=24 R=25 S=26 T=27
 U=28 V=29 W=32 X=30 Y=31 Z=33
 
 身份證號碼驗證方式：
 
 (N0 十位數 + (N0 個位數 x 9) + (N1 x 8) + (N2 x 7) +  (N3 x 6) +  (N4 x 5) +  (N5 x 4) +  (N6 x 3) +  (N7 x 2) + N8 + N9)
 
 以上算式得出來的結果如果能被10整除, 此身分證字號即為正確。
 */

-(BOOL)NSStringIsValidPersionID:(NSString *)checkString
{
    NSString *PersonIDRegex = @"[A-Z][0-9]{9}";
    NSPredicate *PersonIDTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PersonIDRegex];
    
    if (![PersonIDTest evaluateWithObject:checkString]) {
        return false;
    }
    
    NSArray *FirstSymbol = [NSArray arrayWithObjects: @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"34", @"18", @"19", @"20", @"21", @"22", @"35", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"32", @"30", @"31", @"33", nil];
    
    NSString *N0String = [FirstSymbol objectAtIndex:([checkString characterAtIndex:0]- (int)'A')];
    int N0 = [N0String intValue];
    int N1 = [checkString characterAtIndex:1] - (int)'0';
    int N2 = [checkString characterAtIndex:2] - (int)'0';
    int N3 = [checkString characterAtIndex:3] - (int)'0';
    int N4 = [checkString characterAtIndex:4] - (int)'0';
    int N5 = [checkString characterAtIndex:5] - (int)'0';
    int N6 = [checkString characterAtIndex:6] - (int)'0';
    int N7 = [checkString characterAtIndex:7] - (int)'0';
    int N8 = [checkString characterAtIndex:8] - (int)'0';
    int N9 = [checkString characterAtIndex:9] - (int)'0';
    
    int sum = N0 / 10 + N0 % 10 * 9 + N1 *8 + N2 *7 + N3 * 6 + N4 * 5 + N5 * 4 + N6 * 3 + N7 * 2 + N8 + N9;
    
    if (sum % 10 == 0) {
        return true;
    } else {
        return false;
    }
}

// 按下完成鈕後的 method
-(void) donePicker {
    // endEditing: 是結束編輯狀態的 method
    if ([self.view endEditing:NO]) {
        [self checkAdultSetDate:true];
    }
}

-(void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    self.birth.text = [formatter stringFromDate:date];
    [self checkAdultSetDate:true];
}

-(void) checkAdultSetDate:(BOOL)isSet
{
    NSLog(@"checkAdultSetDate: %d", isSet);
    if (_birth.text.length != 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        // [formatter setLocale:dateLocale];
        
        NSDate *earlier;
        
        if(isSet){
            // 將選取後的日期 填入 UITextField
            _birth.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
            
            NSTimeInterval timeInSeconds = [datePicker.date timeIntervalSince1970];
            birthInMiniSecond = timeInSeconds * 1000;
            earlier = datePicker.date;
        } else {
            NSString *dateStr = _birth.text;
            
            // Convert string to date object
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            earlier = [dateFormat dateFromString:dateStr];
            NSTimeInterval timeInSeconds = [earlier timeIntervalSince1970];
            birthInMiniSecond = timeInSeconds * 1000;
        }
        NSDate *today = [NSDate date];
        
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
        
        // pass as many or as little units as you like here, separated by pipes
        NSUInteger units = NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth;
        
        NSDateComponents *components = [gregorian components:units fromDate:earlier toDate:today options:0];
        
        NSInteger years = [components year];
        //小于20一定要填
        if (years < 20) {
            _PersionID.hidden = false;
            _guardianName.hidden = false;
            _guardianPhone.hidden = false;
	    //FIH-add for 隐藏或显示监护人信息 start
            self.guardianNameTipView.hidden = false;
            self.guardianPhoneTipView.hidden = false;
            self.PersionIDTipView.hidden = false;

	    //FIH-add for 隐藏或显示监护人信息 end
        }
        else{
            if (!isInsuranceEvent) {
                _PersionID.hidden = true;
                self.PersionIDTipView.hidden = true;
                //            _PersionID.hidden = true;
                            _PersionID.text = nil;
                            _guardianName.hidden = true;
                            _guardianName.text = nil;
                            _guardianPhone.hidden = true;
                            _guardianPhone.text = nil;
                        //FIH-add for 隐藏或显示监护人信息 start
                            self.guardianNameTipView.hidden = true;
                            self.guardianPhoneTipView.hidden = true;
                //            self.PersionIDTipView.hidden = true;
                        //FIH-add for 隐藏或显示监护人信息 end
            }
            else{
                _PersionID.hidden = false;
                self.PersionIDTipView.hidden = false;
                //            _PersionID.hidden = true;
                            _PersionID.text = nil;
                            _guardianName.hidden = true;
                            _guardianName.text = nil;
                            _guardianPhone.hidden = true;
                            _guardianPhone.text = nil;
                        //FIH-add for 隐藏或显示监护人信息 start
                            self.guardianNameTipView.hidden = true;
                            self.guardianPhoneTipView.hidden = true;
                //            self.PersionIDTipView.hidden = true;
                        //FIH-add for 隐藏或显示监护人信息 end
            }

        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (bool) isMulptiItemEvent {
    if(![[self.event valueForKey:@"required_group"] boolValue]){
        return false;
    }
    
    if([[self.event valueForKey:@"is_volunteer_event"] boolValue]) {
        return false;
    }
    return true;
    
    
}

- (void) refreshItemsBlock {
    if (![self isMulptiItemEvent]) {
        [self.itemsBlock setHidden:YES];
        return;
    }

    [self.itemsBlock setHidden:NO];
    NSLog(@"event: %@", self.event);
    
    
//    skills = [[self.event valueForKey:@"skills_description"] componentsSeparatedByString:@","];
    
}

#pragma UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray* arr = [self.event valueForKey:@"skill_groups"];
    return arr.count;
}

- (__kindof UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RegisterItemCellViewController * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSArray* arr = [self.event valueForKey:@"skill_groups"];
    NSDictionary* skill = arr[indexPath.row];
    cell.titleLabel.text = [skill valueForKey:@"name"];
    NSUInteger max = [[skill valueForKey:@"volunteer_number"] intValue] - [[skill valueForKey:@"current_volunteer_number"]intValue];
    [cell setMaxNumber: max];
    cell.currentNumberTextField.delegate = self;
    __weak RegisterItemCellViewController * thisCell = cell;
    cell.onAddTouched = ^{
        NSInteger newValue = [[skillGroupArray objectAtIndex:indexPath.row] intValue] + 1;
        if(newValue <= 0) {
            newValue = 0;
        }
        if(newValue >= max) {
            newValue = max;
        }
        [skillGroupArray setObject:@(newValue) atIndexedSubscript:indexPath.row];
        thisCell.currentNumberTextField.text = [[NSString alloc] initWithFormat:@"%ld", (long)newValue];
    };
    
    cell.onMinusTouched = ^{
        NSInteger newValue = [[skillGroupArray objectAtIndex:indexPath.row] intValue] - 1;
        if(newValue <= 0) {
            newValue = 0;
        }
        if(newValue >= max) {
            newValue = max;
        }
        [skillGroupArray setObject:@(newValue) atIndexedSubscript:indexPath.row];
        thisCell.currentNumberTextField.text = [[NSString alloc] initWithFormat:@"%ld", (long)newValue];
    };
    cell.onValueChanged = ^(NSInteger newValue){
        NSLog(@"onValueChanged: %lu", (unsigned long)newValue);
        if(newValue <= 0) {
            newValue = 0;
        }
        if(newValue >= max) {
            newValue = max;
        }
        [skillGroupArray setObject:@(newValue) atIndexedSubscript:indexPath.row];
        thisCell.currentNumberTextField.text = [[NSString alloc] initWithFormat:@"%ld", (long)newValue];
    };

    
    return cell;
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 30.0);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    scrollView.contentOffset.x = 0;
    scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
}

@end
