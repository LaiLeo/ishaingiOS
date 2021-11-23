//
//  WebViewController.h
//  volunteers
//
//  Created by NJUser on 2021/10/11.
//  Copyright © 2021 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSString *linkUrl;
@property(nonatomic,strong)UIImageView *baseNavView;
@property(nonatomic,strong)UIButton *baseBackItem;

@end

NS_ASSUME_NONNULL_END
