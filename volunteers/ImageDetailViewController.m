//
//  ImageDetailViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/2.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageDetailViewController.h"

@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController
{
    UIImage *image;
    UIImageView *imageView;
}
@synthesize image;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    // Do any additional setup after loading the view.
    [self.scrollView setMinimumZoomScale:1.0];
    [self.scrollView setMaximumZoomScale:5.0];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    
    /*
     CGRect screenRect = [[UIScreen mainScreen] bounds];
     float widthScale = screenRect.size.width / image.size.width / 2;
     float heightScale = screenRect.size.height / image.size.height / 2;
     
     NSLog(@"%f,%f", image.size.width, image.size.height);
     
     float scale = (widthScale > heightScale) ? heightScale : widthScale;
     
     CGSize size = CGSizeMake(image.size.width * scale, image.size.height * scale);
     UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
     [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     
     NSLog(@"%f,%f", newImage.size.width, newImage.size.height);
     UIGraphicsEndImageContext();
     */
    
    imageView = [[UIImageView alloc] initWithImage:image];
    
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    //如果不加这句的话
    [imageView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    //那么正常拖动是可以的，但是如果zoom了 就会有问题
    
    //zoom发生后会把frame变成当前显示大小[imageview默认大小 屏幕显示大小 如是全屏则就是全屏大小] zoom变化导致frame同步改变了image的size 大小为frame大小
    
    //image 的size改变后导致self.scrollView.contentSize 变成了frame的大小  从而contentSize变小了 无法实现正常拖动。
    
    //然后根据zoom缩放比例变化。而不是根据实际图片大小。这么导致zoom后就无法拖动了[因为frame大小]
    
    self.scrollView.contentSize = imageView.frame.size;
    [self.scrollView addSubview:imageView];
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)_scrollView {
    return imageView;
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
