//
//  BarCodeScannerViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/3.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVMetadataObject.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "BarCodeScannerViewController.h"
#import "WilloAPIV2.h"
#import "LoginServer.h"
#import "UIView+Toast.h"
#import "UserProfileData.h"


@interface BarCodeScannerViewController ()
@property(nonatomic,copy) NSString  *userId;
@end

@implementation BarCodeScannerViewController
{
    AVCaptureSession *mCaptureSession;
    NSMutableString *mCode;
    AVCaptureVideoPreviewLayer *previewLayer;
    bool isJoined;

    CLLocationManager *locationManager;
    CLLocation *myLocation;
    
    NSMutableDictionary *event;
}
@synthesize isJoined;
@synthesize event;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *data = [UserProfileData myProfile];
    self.userId = [data valueForKey:@"id"];
    [self startStandardUpdates];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([mCaptureSession isRunning] == NO)
        [mCaptureSession startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([mCaptureSession isRunning])
        [mCaptureSession stopRunning];
}

- (void)viewDidAppear:(BOOL)animated {
    
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

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 1
    if (mCode == nil) {
        mCode = [[NSMutableString alloc] initWithString:@""];
    }
    
    // 2
    [mCode setString:@""];
    
    // 3
    for (AVMetadataObject *metadataObject in metadataObjects) {
        AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)metadataObject;
        
        // 4
        if([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            [mCode appendFormat:@"%@ (QR)", readableObject.stringValue];
        } else if ([metadataObject.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
            [mCode appendFormat:@"%@ (EAN 13)", readableObject.stringValue];
        }
    }
    
    // 5
    if (![mCode isEqualToString:@""]) {
        [mCaptureSession stopRunning];
        [self joinEvent:mCode];
    }
}

- (void)joinEvent:(NSString *)mQRCodeString
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    if (token == nil) {
        return;
    }
    
    NSArray *firstSplit = [mQRCodeString componentsSeparatedByString:@" "];
    
    NSString* uuid = [firstSplit.firstObject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (isJoined) {
        // 签退3510d3ece2994963933b736f1b126edd
        [[LoginServer shareInstance]PostLeaveEventWithUuid:uuid userId:self.userId success:^(NSDictionary * _Nonnull dic) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"簽退"
                                                                            message:@"恭喜您，完成此次志工活動，請給予活動評分和留言"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                            alert.tag = 1;
                            [alert show];
            
        } failure:^(NSError * _Nonnull error) {
                            // 沒報到或 id 不合法
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"簽退"
                                                                            message:@"未報到或是掃描 QRCode 不正確"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                            alert.tag = 2;
                            [alert show];
            
        }];
        
//        [WilloAPIV2 joinEventWithUuid:uuid viewController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if (operation.response.statusCode == 200) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"簽退"
//                                                                message:@"恭喜您，完成此次志工活動，請給予活動評分和留言"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                alert.tag = 1;
//                [alert show];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
//            NSLog(@"Error: %@", error);
//
//            if (operation.response.statusCode == 400) {
//                // 沒報到或 id 不合法
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"簽退"
//                                                                message:@"未報到或是掃描 QRCode 不正確"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                alert.tag = 2;
//                [alert show];
//            }
//        }];
    } else {
//        [WilloAPIV2 leaveEventWithUuid:uuid viewController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if (operation.response.statusCode == 200) {
//                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"報到"
//                                                                message:@"您已完成報到，活動加油！"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                alert.tag = 1;
//                [alert show];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
//            NSLog(@"Error: %@", error);
//            
//            if (operation.response.statusCode == 400) {
//                // 沒報名或 id 不合法
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"報到"
//                                                                message:@"未報名或是掃描 QRCode 不正確"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                alert.tag = 2;
//                [alert show];
//            }
//        }];
    //签到
        
        [[LoginServer shareInstance]PostJoinEventWithUuid:uuid userId:self.userId success:^(NSDictionary * _Nonnull dic) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"報到"
                                                                            message:@"您已完成報到，活動加油"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                    alert.tag = 4;
                    [alert show];
                } failure:^(NSError * _Nonnull error) {
                                    // 沒報名或 id 不合法
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"報到"
                                                            message:@"未報名或是掃描 QRCode 不正確"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                    alert.tag = 2;
                    [alert show];
                }];
       
    }
}


- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (locationManager  == nil)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 1000; // meters
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    } else {
        [locationManager startUpdatingLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        myLocation = [locations lastObject];
        
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[[event valueForKey:@"lat"] floatValue] longitude:[[event valueForKey:@"lng"] floatValue]];
        CLLocationDistance distance = [loc distanceFromLocation:myLocation];
        if (distance / 1000 > 1) {
            self.distance.text = [NSString stringWithFormat:@"距%.f公里", distance / 1000];
        } else {
            self.distance.text = [NSString stringWithFormat:@"距%.f公尺", distance];
        }
        
        if (distance < 1000 || isJoined) {
            // Do any additional setup after loading the view.
            // 1
            mCaptureSession = [[AVCaptureSession alloc] init];
            
            // 2
            AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            NSError *error = nil;
            
            // 3
            AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
            
            if ([mCaptureSession canAddInput:videoInput]) {
                [mCaptureSession addInput:videoInput];
            } else {
                NSLog(@"Could not add video input: %@", [error localizedDescription]);
            }
            
            // 4
            AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
            
            if ([mCaptureSession canAddOutput:metadataOutput]) {
                [mCaptureSession addOutput:metadataOutput];
                
                // 5
                [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
                [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code]];
            } else {
                NSLog(@"Could not add metadata output.");
            }
            
            // 6
            previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:mCaptureSession];
            previewLayer.frame = CGRectMake(0, 0, _presentLayerView.frame.size.width, _presentLayerView.frame.size.height);
            [_presentLayerView.layer addSublayer:previewLayer];
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            // 7
            [mCaptureSession startRunning];
        } else {
            // Do any additional setup after loading the view.
            // 1
//            mCaptureSession = [[AVCaptureSession alloc] init];
//
//            // 2
//            AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//            NSError *error = nil;
//
//            // 3
//            AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
//
//            if ([mCaptureSession canAddInput:videoInput]) {
//                [mCaptureSession addInput:videoInput];
//            } else {
//                NSLog(@"Could not add video input: %@", [error localizedDescription]);
//            }
//
//            // 4
//            AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
//
//            if ([mCaptureSession canAddOutput:metadataOutput]) {
//                [mCaptureSession addOutput:metadataOutput];
//
//                // 5
//                [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//                [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code]];
//            } else {
//                NSLog(@"Could not add metadata output.");
//            }
//
//            // 6
//            previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:mCaptureSession];
//            previewLayer.frame = CGRectMake(0, 0, _presentLayerView.frame.size.width, _presentLayerView.frame.size.height);
//            [_presentLayerView.layer addSublayer:previewLayer];
//            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            // 7
//            [mCaptureSession startRunning];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"距離過遠"
                                                            message:@"無法簽到"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"無法找到您的位置"
                                                    message:@"是否前往設定 [位置] 打開權限"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"好", nil];
    alert.tag = 3;
    [alert show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            [WilloAPIV2 getDump:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *questionnaireUrl = [userDefaults stringForKey:@"questionnaireUrl"];
            NSString *encodeUrl = [questionnaireUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodeUrl]];
        }
    } else if (alertView.tag == 2) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            [mCaptureSession startRunning];
        }
    } else if (alertView.tag == 3 && buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }else if (alertView.tag == 4 && buttonIndex == 0) {
        [WilloAPIV2 getDump:nil];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}

@end
