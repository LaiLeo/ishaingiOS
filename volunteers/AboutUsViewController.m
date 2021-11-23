//
//  AboutUsViewController.m
//  volunteers
//
//  Created by jauyou on 2015/1/31.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //attributed text could be relatively easily modified in storyboard,
    //text here just for ref
    /*
    self.aboutUsTextView.text = @"關於我們
     台灣大哥大基金會2014年推出全國首創跨網站與APP的微樂志工公益媒合平台，提供公益團體尋找志工人力的管道，也鼓勵全民利用零散時間輕鬆報名做志工。此後陸續新增捐物資、找企業志工、信用卡捐款等功能，使得找志工、募物資、捐善款得以一站完成。
     
     誠摯歡迎全民一起集合「微」小志工力量，替社會創造巨大快「樂」能量，也歡迎公益團體上架微樂志工平台，以科技化方式更快速找到所需的資源！
     
     ※公益團體成為微樂志工夥伴：https://www.isharing.tw/join/
     
     關於台灣大哥大基金會
     台灣大哥大基金會成立於1999年，以發展電信學術、提升電信科技、促進國際交流、舉辦公益活動為宗旨，結合企業核心資源，投入各項社會、文化、教育、環保活動，持續服務社會、回饋大眾。
     
     ※Email : TWMSBD@taiwanmobile.com
     ※網址：www.twmf.org.tw
     ※FB : https://zh-tw.facebook.com/twmf.org
     
     隱私權政策
     https://www.isharing.tw/privacy/
     
     服務條款
     https://www.isharing.tw/tos/";
     */
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

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
