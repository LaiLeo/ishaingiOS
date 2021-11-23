//
//  CALayer+XibConfiguration.h
//  volunteers
//
//  Created by jauyou on 2015/1/29.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer(XibConfiguration)

// This assigns a CGColor to borderColor.
@property(nonatomic, assign) UIColor* borderUIColor;

@end