//
//  DonateNpoDetailViewController.m
//  volunteers
//
//  Created by jauyou on 2015/3/6.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "DonateNpoDetailViewController.h"
#import "WilloAPIV2.h"
#import "LogHeader.h"

@interface DonateNpoDetailViewController ()

@end

@implementation DonateNpoDetailViewController
{
    NSMutableDictionary *donateNpo;
    NSArray *priceNames;
    UIPickerView *pricePicker;
    int movementDistance;
    UITextField *selectTextField;
    CGSize keyboardSize;
}
@synthesize donateNpo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *fileName = [donateNpo valueForKey:@"npo_icon"];

    NSString *strUrl = [fileName stringByReplacingOccurrencesOfString:@"/uploads" withString:@"resources"];

    NSString *urlLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], strUrl];
    NSString *fileNames = [[urlLick componentsSeparatedByString:@"/"] lastObject];
    
    NSLog(@"file name: %@ %@", urlLick, fileName);
    
    [self.spinner startAnimating];
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [self.icon sd_setImageWithURL:[NSURL URLWithString:urlLick]
                   placeholderImage:[UIImage imageNamed:fileNames]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              if ([self.spinner isAnimating]) {
                                  [self.spinner stopAnimating];
                              }
                          }];
    
    self.name.text = [donateNpo valueForKey:@"name"];
    
    
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

    
    // pricePicker
    pricePicker = [[UIPickerView alloc] init];
    pricePicker.dataSource = self;
    pricePicker.delegate = self;
    pricePicker.showsSelectionIndicator = YES;
    
    self.denateNpoDescription.text = [donateNpo valueForKey:@"description"];
    self.donatePrice.inputView = pricePicker;

    
    priceNames = [[NSArray alloc] initWithObjects:
                  @"自行輸入",
                  @"捐 100 元",
                  @"捐 200 元",
                  @"捐 300 元",
                  @"捐 500 元",
                  @"捐 1000 元",
                  @"捐 2000 元",
                  @"捐 3000 元",
                  @"捐 6000 元",nil];
    NSString *newebpayPeriodUrl = [NSString stringWithFormat:@"%@",[donateNpo valueForKey:@"newebpayPeriodUrl"]];
    if ([newebpayPeriodUrl containsString:@"http"]) {
        //定期定额捐款
            UIButton *periodicButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 66, self.choiceView.bounds.size.width-56, 50)];
            [periodicButton setTitle:@"定期定額捐款" forState:0];
            [periodicButton.titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
            [periodicButton setBackgroundColor:[UIColor colorWithRed:235/255.0 green:109/255.0 blue:1/255.0 alpha:1]];
            periodicButton.userInteractionEnabled = YES;
            periodicButton.layer.cornerRadius = 25;
            [periodicButton addTarget:self action:@selector(periodicAction) forControlEvents:(UIControlEventTouchUpInside)];
            [self.choiceView addSubview:periodicButton];
    }
    

}
-(void)periodicAction{
    NSString *newebpayPeriodUrl = [NSString stringWithFormat:@"%@",[donateNpo valueForKey:@"newebpayPeriodUrl"]];
    NSString *encodeUrl = [newebpayPeriodUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodeUrl]];
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

#pragma mark -
#pragma mark picker methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [priceNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [priceNames objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.donatePrice.tag = row;
    self.donatePrice.text = [priceNames objectAtIndex:row];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1 && buttonIndex == 1) {
        if (self.donatePrice.tag == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:5180%@", [donateNpo valueForKey:@"code"]]]];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:5180%@,1,%1ld,1,1,1", [donateNpo valueForKey:@"code"], self.donatePrice.tag]]];
        }
    }
}

-(void)dismissKeyboard {
    [self.donatePrice resignFirstResponder];
}

- (IBAction)callForDonate:(id)sender {
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        UIAlertView *moreInfo;
        if (self.donatePrice.tag == 0) {
            moreInfo=[[UIAlertView alloc] initWithTitle:@"小提醒" message:@"按下確認後，將啟動自動撥號捐款流程，不需再自行輸入代碼，請等到最後感謝語音，再掛斷電話。成功捐款後您將收到電信商的捐款作業完成確認簡訊。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"繼續", nil];
        } else {
            moreInfo=[[UIAlertView alloc] initWithTitle:@"小提醒" message:@"按下確認後，將啟動自動撥號捐款流程，不需再自行輸入代碼，請等到最後感謝語音，再掛斷電話。成功捐款後您將收到電信商的捐款作業完成確認簡訊。\n\n（此功能預設同意電信商將您的聯絡資訊提供給受贈之公益團體寄送收據使用）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"繼續", nil];
        }
        moreInfo.tag = 1;
        [moreInfo show];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}

- (IBAction)showMoreInfo:(id)sender {
    UIAlertView *moreInfo=[[UIAlertView alloc] initWithTitle:@"詳細說明" message:@"此專區服務是走台灣大哥大既有手機捐款系統流程，金流部分由台灣大哥大從隔月電信帳單扣款。如果選擇100,500,1000的捐款，都是預設要領取收據，若您不希望領取，請點選「手動選其他金額」。\n微樂志工是用撥電話自動送出代碼，減少民眾操作按鈕，微樂志工並不會拿到使用者的個人隱私資料，請放心。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [moreInfo show];
}

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showPhoneDonateBlock:(id)sender{
    [self.donateSelectBlock setHidden:YES];
}


- (IBAction)callForNewEBPay:(id)sender {
    
    NSString * url = [donateNpo valueForKey:@"newebpay_url"];
    if(url.length == 0) {
        UIAlertView *moreInfo=[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"此單位不同意使用數位捐款\n請選擇語音捐款或洽此單位官網，謝謝！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [moreInfo show];
        return;
        
    }

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
    NSLog(@"info: %@", donateNpo);
    
}


- (UIUserInterfaceStyle)overrideUserInterfaceStyle{
    return UIUserInterfaceStyleLight;
}


@end
