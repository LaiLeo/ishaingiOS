//
//  LogHeader.h
//  volunteers
//
//  Created by NJUser on 2021/10/18.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#ifndef LogHeader_h
#define LogHeader_h
/**
 tabbar高度
 */
#define  lz_tabbarHeight ((lz_iPhoneX || lz_iPhoneXr || lz_iPhoneXs || lz_iPhoneXsMax) ? (49.f + 34.f) : 49.f)
// 判断是否是ipad
#define lz_isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 判断iPhoneX
#define lz_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !lz_isPad : NO)
// 判断iPHoneXr
#define lz_iPhoneXr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !lz_isPad : NO)
// 判断iPhoneXs
#define lz_iPhoneXs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !lz_isPad : NO)
// 判断iPhoneXs Max
#define lz_iPhoneXsMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !lz_isPad : NO)
// 判断iPhone11
#define IS_IPHONE_11 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhone11 Pro
#define IS_IPHONE_11_Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define IS_IPHONE_11_Pro_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define  iPhoneXStyle (([UIScreen mainScreen].bounds.size.width == 375.f && [UIScreen mainScreen].bounds.size.height == 812.f ? YES : NO) || ([UIScreen mainScreen].bounds.size.width == 414.f && [UIScreen mainScreen].bounds.size.height == 896.f ? YES : NO))

#define  IS_PhoneXAll ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0)

/**
 底部安全间距
 */
#define lz_safeBottomMargin  (IS_PhoneXAll ? 34.f : 0.f)

/// 状态栏距离
#define lz_StateHeight (IS_PhoneXAll ? 20.f : 0.f)

/// 导航栏高度
#define lz_NavigationHeight (IS_PhoneXAll ? 64.f : 44.f)

#define YC_KTabBarHeight (CGFloat)((IS_PhoneXAll?(49.0 + 34.0):(49.0)))

#define YC_KNavHeight (CGFloat)(IS_PhoneXAll?(44+35):(44+20))


#define kScreenW                [[UIScreen mainScreen] bounds].size.width
#define kScreenH                [[UIScreen mainScreen] bounds].size.height


#define PNSUMSDKInfo @"AucNDAikkQSVC4iNBXeuu8EQZzBiyzpdKfD6Quf3CHSHtzd6bmWA9+t0kRIWXeFk3/794k6dnmQ5URVdHYmxZ0jn2mtQm1D0GYyWMwwfQHsXxl28RGn88Pi11/aoTUnmN8n51++KtF5n2J7ZWraUs+qcH6PS9pm2+HEFawxcUldldY4UcuHEUIykQCY5hhhmAX88M0asUtSNrTwd4ZQ/pF+O5TBXrq8x19CbWaNuCtqtR/W5Yf9HgU9/XjR2spoUVLPmQqTRfDU="

#define PNSCustomerId @""

#define PNSAppSecret @"dRniYn1C8D1kbZOHyGEseWuTGVTygl"
#define PNSAppKey @"LTAI4FzbB86BoJdCsEgtnXx2"


/** 色值 RGB **/
/** 色值 RGBA **/
#define RGB_A(r, g, b, a) [UIColor colorWithRed:(CGFloat)(r)/255.0f green:(CGFloat)(g)/255.0f blue:(CGFloat)(b)/255.0f alpha:(CGFloat)(a)]
#define RGB(r, g, b) RGB_A(r, g, b, 1)
#define RGB_HEX(__h__) RGB((__h__ >> 16) & 0xFF, (__h__ >> 8) & 0xFF, __h__ & 0xFF)



/**
 *  获取当前主窗口
 */
#define YYKeyWindow [UIApplication sharedApplication].keyWindow
/**
 *   NSUserDefaults
 */
#define YYUserDefaults [NSUserDefaults standardUserDefaults]

#define UIColorFromHex_Alpha(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(alphaValue)]
/**默认字体*/
#define  YYFont(font)  [UIFont systemFontOfSize:font]
/**加粗字体*/
#define  BoldFont(font)  [UIFont boldSystemFontOfSize:font]
//白色宏定义
#define WhithColor [UIColor whiteColor]
/**构建版本数*/
#define  AppBuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
/**
 *  app版本号
 */
#define AppVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/**
     和后台约定的版本号
 */
//#define VersionNum  @"v4"

///未读消息的通知
#define YCGetIMUnreadMessageNum @"YCGetIMUnreadMessageNum"

/// 直播间聊天视图的宽高
#define MsgTableViewWidth     288
//#define MsgTableViewHeight    160
#define MsgTableViewHeight    (kScreenH-(kScreenWidth/4*3 + 170)-60-lz_safeBottomMargin)


/// 首页中的定时任务请求时间
#define TeilInterval 5 * NSEC_PER_SEC

//弱引用
#define weakSelf(type)   __weak typeof(type) weak##type = type;
//强引用
#define strongSelf(type) __strong typeof(type) type = weak##type;



#ifdef DEBUG
# define TEILLog(FORMAT, ...) fprintf(stderr, "[路径：%s]:[行号：%d]\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
# define TEILLog(FORMAT, ...) nil
#endif

#ifdef DEBUG
#define NSLog(...) {NSTimeInterval time_interval = [[NSDate date]timeIntervalSince1970];\
NSString *logoInfo = [NSString stringWithFormat:__VA_ARGS__];\
printf("%f  %s\n",time_interval,[logoInfo UTF8String]); \
[[NSNotificationCenter defaultCenter] postNotificationName:@"xk_log_noti" object: [NSString stringWithFormat:@"%.2f %@\n %@\n",time_interval,[NSThread currentThread],logoInfo]];}
#else
#define NSLog(...)
#endif


#define minstr(a)    [NSString stringWithFormat:@"%@",a]


#endif /* LogHeader_h */
