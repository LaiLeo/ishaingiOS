//
//  BarCodeScannerViewController.h
//  volunteers
//
//  Created by jauyou on 2015/2/3.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVCaptureOutput.h>
#import <CoreLocation/CoreLocation.h>

@interface BarCodeScannerViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>
@property bool isJoined;
@property NSMutableDictionary *event;
@property (weak, nonatomic) IBOutlet UIView *presentLayerView;
@property (weak, nonatomic) IBOutlet UILabel *distance;
- (IBAction)doDismiss:(id)sender;
@end
