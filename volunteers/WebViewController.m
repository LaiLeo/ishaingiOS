//
//  WebViewController.m
//  volunteers
//
//  Created by NJUser on 2021/10/11.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import "WebViewController.h"
#import "LoginServer.h"
#import "MainTabBarViewController.h"
#import "UIView+Toast.h"
#import "RegistAccountViewController.h"
#import "WilloAPIV2.h"
#import <MBProgressHUD.h>
#import "UserProfileData.h"
#import "LogHeader.h"

@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WebViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;

}

//-(void)backAction:(UIButton *)btn{
//    
//    if ([self.webView canGoBack]) {
//        [self.webView goBack];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _creatWebview];
    self.automaticallyAdjustsScrollViewInsets=NO;

}

-(void)buttonAct:(UIButton *)btn{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)_creatWebview{
    self.baseNavView = [[UIImageView alloc]init];
    [self.view insertSubview:self.baseNavView atIndex:10];
    self.baseNavView.userInteractionEnabled = YES;
    self.baseNavView.backgroundColor = [UIColor whiteColor];
    self.baseNavView.contentMode = UIViewContentModeScaleAspectFill;
//    self.baseNavView.image = [UIImage imageNamed:@"icon-NavigationBG"];
    self.baseNavView.layer.masksToBounds = YES;
    
    self.baseBackItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.baseNavView addSubview:self.baseBackItem];
    [self.baseBackItem setImage:[UIImage imageNamed:@"back"] forState:0];
    [self.baseBackItem addTarget:self action:@selector(buttonAct:) forControlEvents:UIControlEventTouchUpInside];
    if ((lz_iPhoneX || lz_iPhoneXr || lz_iPhoneXs || lz_iPhoneXsMax)) {
         [self.baseNavView setFrame:CGRectMake(0, 0, kScreenW, 44+35)];
         [self.baseBackItem setFrame:CGRectMake(0, 35, 44, 44)];
    
    }else{
         [self.baseNavView setFrame:CGRectMake(0, 0, kScreenW, 44+20)];
         [self.baseBackItem setFrame:CGRectMake(0, 20, 44, 44)];
         
    }

    WKWebViewConfiguration *configer = [[WKWebViewConfiguration alloc] init];
    configer.userContentController = [[WKUserContentController alloc] init];
    configer.preferences.javaScriptEnabled = YES;
    configer.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    configer.allowsInlineMediaPlayback = YES;
    
   
    self.webView =[[WKWebView alloc]initWithFrame:CGRectMake(0, YC_KNavHeight, kScreenW, kScreenH-YC_KNavHeight) configuration:configer];
   
//    self.webView =[[WKWebView alloc]initWithFrame:self.view.bounds configuration:configer];

    [self.webView setNavigationDelegate:self];
    [self.view addSubview:self.webView];
//    NSString *url=@"https://stage.oauth.taiwanmobile.com/MemberOAuth/authPageLogin?response_type=code&client_id=fihcloud&redirect_uri=https://stage-isharing.fihcloud.com/oauth/twmcallback&state=/" ;
    NSString *url=@"https://stage.oauth.taiwanmobile.com/MemberOAuth/authPageLogin?response_type=code&client_id=fihcloud&redirect_uri=http://isharing.fihcloud.com/oauth/twmcallback&state=/";

    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}


//在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
//{
//    NSString * url = navigationAction.request.URL.absoluteString;
////    if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL])
////              {
////                  [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
////                  if(decisionHandler)
////                  {
////                      decisionHandler(WKNavigationActionPolicyCancel);
////                  }
////
////              }
//    decisionHandler(WKNavigationActionPolicyCancel);
//
//}
//在收到响应之后决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * url = navigationResponse.response.URL.absoluteString;
    if ([url containsString:@"code="]) {
        NSRange range = [url rangeOfString:@"code="];//匹配得到的下标
        NSString *value = [url substringFromIndex:range.location+5];//截取下标：之后的字符串
       
        decisionHandler(WKNavigationActionPolicyCancel);
        
        //请求接口
        [[LoginServer shareInstance]PostLoginTaiWanWithCode:value success:^(NSDictionary * _Nonnull dic) {
            
            //
            NSString *accessCode = dic[@"accessCode"];
            NSString *username = dic[@"username"];
            NSArray *listArray = dic[@"errors"];
            NSDictionary *tokenDic = dic[@"token"];
            NSString *token = [tokenDic objectForKey:@"accessToken"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:token forKey:@"token"];
            [userDefaults synchronize];
            

            if (token) {
                [[LoginServer shareInstance]GetPersonInformationToken:token Success:^(NSDictionary * _Nonnull dic) {
                    [UserProfileData saveProfile:dic];
                    [self.view makeToast:@"success" duration:2.0 position:@"CSToastPositionCenter"];

                            } failure:^(NSError * _Nonnull error) {
                                [self.view makeToast:@"failure" duration:2.0 position:@"CSToastPositionCenter"];

                            }];
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MainTabBarViewController *vc = [sb instantiateViewControllerWithIdentifier:@"mainTabBarViewController"];
                vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [self presentViewController:vc animated:YES completion:nil];
                return;
            }
            if (listArray.count != 0) {
                for (NSDictionary *item in listArray) {
                    NSString *error = item[@"error"];
                    NSLog(@"error%@",error);
        //            [self.view makeToast:error duration:2.0 position:@"CSToastPositionCenter"];
                    if ([error isEqualToString:@"userNotFound"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密碼錯誤" message:@"您輸入的帳號或密碼有誤，請重新輸入" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];

                       
                    }
                    if ([error isEqualToString:@"userNotRegister"]) {
                        
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        RegistAccountViewController *vc = [sb instantiateViewControllerWithIdentifier:@"registAccountViewController"];
                        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                        vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        vc.type = 1;
                        vc.fubonAccount = username;
                        vc.accessCode = accessCode;
                        [self presentViewController:vc animated:YES completion:nil];


                    }

                }
            }
            
                } failure:^(NSError * _Nonnull error) {
                    [self.view makeToast:@"failure" duration:2.0 position:@"CSToastPositionCenter"];

                }];
        

    }else{
        decisionHandler(WKNavigationActionPolicyAllow);

    }


//http://isharing.fihcloud.com/oauth/twmcallback?state=%2F&scopes=646&code=nVZn-ug.o.z-rQ%2FTMrCuEJwL-yuDeLhzCJU%3D
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
