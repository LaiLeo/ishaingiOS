//
//  CALayer+XibConfiguration.m
//  volunteers
//
//  Created by jauyou on 2015/1/29.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer(XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
