//
//  EventResultViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/2.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "AppDelegate.h"
#import "EventImageCollectionViewCell.h"
#import "EventResultViewController.h"
#import "ImageDetailViewController.h"
#import "ReplyCollectionViewCell.h"
#import "UserProfileViewController.h"
#import "WilloAPIV2.h"

@interface EventResultViewController ()

@end

@implementation EventResultViewController
{
    int eventId;
    NSMutableArray *images;
    NSMutableDictionary *event;
    NSMutableArray *replies;
    
    int movementDistance;
    UITextField *selectTextField;
    CGSize keyboardSize;
    
    NSString *imagePath;;
    UIImagePickerController *imagePicker;
}
@synthesize eventId;
@synthesize event;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"EventResultViewController::viewDidLoad");
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
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
    
    imagePath = nil;
    // 設定UIImagePickerController代理
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    images = [event valueForKey:@"images"];
    replies = [event valueForKey:@"replies"];
    
    if ([images count] == 0) {
        self.eventImagesCollectionView.hidden = true;
        self.eventDescription.text = [event valueForKey:@"description"];
    } else {
        self.eventImagesCollectionView.hidden = false;
    }
    self.eventTitle.text = [event valueForKey:@"subject"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (NSMutableDictionary *item in appDelegate.focused_event) {
        if ([[[item valueForKey:@"focused_event"] valueForKey:@"id"] intValue] == eventId) {
            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
            self.followOrNotButton.tag = 1;
            break;
        }
    }
    
    self.replyCount.text = [NSString stringWithFormat:@"%d 人回覆", [[event valueForKey:@"reply_num"] intValue]];
    
    [self.view setUserInteractionEnabled:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.replyCollectionView reloadData];
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

-(void)keyboardWillShow:(NSNotification *) notification{
    NSDictionary* info = [notification userInfo];
    // kbSize即為鍵盤尺寸 (有width, height)
    keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    //再依據不同的高度 作不同的因應
    
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement;
    
    float shouldMove = keyboardSize.height;
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

-(void)dismissKeyboard {
    [self.replyComment resignFirstResponder];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view resignFirstResponder];
}

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 1) {
        return images.count;
    } else {
        return replies.count;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView
                                 layout:(UICollectionViewLayout*)collectionViewLayout
                 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1) {
        return CGSizeMake(98.0, 98.0);
    } else {
        long row = [indexPath row];
        NSMutableDictionary *eventEntity = (NSMutableDictionary *)replies[row];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        NSLog(@"collectionView %@", [eventEntity valueForKey:@"image"]);
//        return CGSizeMake(screenWidth, 80);
//
        if ([[eventEntity valueForKey:@"image"] isKindOfClass:[NSArray class]] && [[eventEntity valueForKey:@"image"] length] != 0) {
            return CGSizeMake(screenWidth, 330);
        } else {
            return CGSizeMake(screenWidth, 80);
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1) {
        EventImageCollectionViewCell *myCell = [collectionView
                                                dequeueReusableCellWithReuseIdentifier:@"eventImageCell"
                                                forIndexPath:indexPath];
        
        long row = [indexPath row];
        NSMutableDictionary *eventEntity = (NSMutableDictionary *)images[row];
        
        myCell.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [myCell.spinner setCenter:CGPointMake(myCell.resultImage.center.x, myCell.resultImage.center.y)]; // I do this because I'm in landscape mode
        [myCell.resultImage addSubview:myCell.spinner]; // spinner is not visible until started
        
        [myCell.spinner startAnimating];
        NSString *fileName = [eventEntity valueForKey:@"image"];

        NSString *strUrl = [fileName stringByReplacingOccurrencesOfString:@"/uploads" withString:@"resources"];

        NSString *urlLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], strUrl];
//        NSString *fileName = [[urlLick componentsSeparatedByString:@"/"] lastObject];
    
        // Here we use the new provided setImageWithURL: method to load the web image
        [myCell.resultImage sd_setImageWithURL:[NSURL URLWithString:urlLick]
                              placeholderImage:[UIImage imageNamed:fileName]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         [myCell.spinner stopAnimating];
                                     }];
        return myCell;
    } else {
        ReplyCollectionViewCell *myCell;
        long row = [indexPath row];
        NSMutableDictionary *eventEntity = (NSMutableDictionary *)replies[row];
        NSLog(@"aaa %@", [eventEntity valueForKey:@"image"] );
//        NSLog(@"aa2 %@", [[eventEntity valueForKey:@"image"] length] );
        if ([[eventEntity valueForKey:@"image"] isKindOfClass:[NSArray class]] && [[eventEntity valueForKey:@"image"] length] != 0) {
            
            NSLog(@"aaab");
            myCell = [collectionView
                      dequeueReusableCellWithReuseIdentifier:@"replyCell"
                      forIndexPath:indexPath];
            NSLog(@"aaac");
        } else {
            
            NSLog(@"aabb");
            myCell = [collectionView
                      dequeueReusableCellWithReuseIdentifier:@"replyNoImageCell"
                      forIndexPath:indexPath];
            
            NSLog(@"aabc");
        }
        NSLog(@"bbb");
        
        myCell.userIconButton.tag = row;
        
        [myCell.userSpinner startAnimating];
        NSString *fileName = [[eventEntity valueForKey:@"user_account"] valueForKey:@"icon"];

        NSString *strUrl = [fileName stringByReplacingOccurrencesOfString:@"/uploads" withString:@"resources"];

        NSString *urlLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], strUrl];
        
//        NSString *urlLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], [[eventEntity valueForKey:@"user_account"] valueForKey:@"icon"]];
//        NSString *fileName = [[urlLick componentsSeparatedByString:@"/"] lastObject];
//
        // Here we use the new provided setImageWithURL: method to load the web image
        [myCell.userIcon sd_setImageWithURL:[NSURL URLWithString:urlLick]
                           placeholderImage:[UIImage imageNamed:fileName]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      [myCell.userSpinner stopAnimating];
                                  }];
        
        myCell.userName.text = [[eventEntity valueForKey:@"user_account"] valueForKey:@"name"];
        myCell.userComment.text = [NSString stringWithFormat:@"%@\n\n", [eventEntity valueForKey:@"message"]];
        
    
        [myCell.uerImageSpinner stopAnimating];
        if ([[eventEntity valueForKey:@"image"] isKindOfClass:[NSArray class]] && [[eventEntity valueForKey:@"image"] length] != 0) {
            [myCell.uerImageSpinner startAnimating];
            
            NSString *fileName = [eventEntity valueForKey:@"image"];

            NSString *strUrl = [fileName stringByReplacingOccurrencesOfString:@"/uploads" withString:@"resources"];

            NSString *urlImageLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], strUrl];
            
//            NSString *urlImageLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getImageUrlName], [eventEntity valueForKey:@"image"]];
            NSString *fileImageName = [[urlLick componentsSeparatedByString:@"/"] lastObject];
//
            // Here we use the new provided setImageWithURL: method to load the web image
            [myCell.userImage sd_setImageWithURL:[NSURL URLWithString:urlImageLick]
                                placeholderImage:[UIImage imageNamed:fileImageName]
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           [myCell.uerImageSpinner stopAnimating];
                                       }];
        }
        return myCell;
    }
}


- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doFollowOrNot:(id)sender {
    if (self.followOrNotButton.tag == 0) {
        [self followEvent:sender];
    } else {
        [self unfollowEvent:sender];
    }
}

- (IBAction)doShare:(id)sender {
    NSString *data = [NSString stringWithFormat:@"%@event/%d/\n%@\n%@", [WilloAPIV2 getHostName], eventId, [event valueForKey:@"subject"], [event valueForKey:@"description"]];
    
    NSString *photo_link = [[WilloAPIV2 getUploadDir] stringByAppendingString:[event valueForKey:@"thumb_path"]];
    
    UIImage *image;
    if ([photo_link length] != 0) {
        NSArray *fileTypeArray = [photo_link componentsSeparatedByString:@"."];
        NSString *fileType = fileTypeArray[[fileTypeArray count] - 1];
        NSString *fileName = [NSString stringWithFormat:@"Caches/PK_%d.%@", eventId, fileType];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
        
        // log dir
        // For error information
        NSError *error;
        
        // Create file manager
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        // Show contents of Documents directory
        NSLog(@"Documents directory: %@",
              [fileMgr contentsOfDirectoryAtPath:[paths objectAtIndex:0] error:&error]);
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
        if (fileExists) {
            // set image
            image = [UIImage imageWithContentsOfFile:path];
        } else {
            // set default image
            image = [UIImage imageNamed:@"event_default.png"];
        }
    } else {
        // set default image
        image = [UIImage imageNamed:@"event_default.png"];
        
    }
    
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:data, image, nil] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[ UIActivityTypeMessage ,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
    
}

- (void)followEvent:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    [WilloAPIV2 focusById:[NSString stringWithFormat:@"%d", self.eventId] viewController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            self.followOrNotButton.tag = 1;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
            [WilloAPIV2 getDump:nil];
        }
        sender.userInteractionEnabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);
        if (operation.response.statusCode == 400) {
            self.followOrNotButton.tag = 1;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        }
        sender.userInteractionEnabled = YES;
    }];
}

- (void)unfollowEvent:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    
    [WilloAPIV2 unfocusById:[NSString stringWithFormat:@"%d", self.eventId] viewController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            self.followOrNotButton.tag = 0;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
            [WilloAPIV2 getDump:nil];
        }
        sender.userInteractionEnabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%ld:%@", (long)operation.response.statusCode, operation.responseString);
        NSLog(@"Error: %@", error);
        if (operation.response.statusCode == 400) {
            self.followOrNotButton.tag = 0;
            [self.followOrNotButton setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
        }
        sender.userInteractionEnabled = YES;
    }];
}

- (IBAction)choosePicFromMedia:(id)sender {
    //設定MediaType類型(不做此設定會自動忽略圖庫中的所有影片)
    
    // NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    // imagePicker.mediaTypes = mediaTypes;
    
    //設定開啓圖庫的類型(預設圖庫/全部/新拍攝)
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //以動畫方式顯示圖庫
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)doReply:(id)sender {
    [self.replyComment resignFirstResponder];

    if (imagePath == nil && [self.replyComment.text length] == 0) {
        return;
    }
    
    ((UIButton *)sender).userInteractionEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[event valueForKey:@"id"] forKey:@"event"];
    
    //if ([self.replyComment.text length] != 0) {
        [parameters setObject:self.replyComment.text forKey:@"message"];
    //}

    [WilloAPIV2 replyWithParameters:parameters viewController:self constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imagePath != nil) {
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
            [formData appendPartWithFileData:data name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WilloAPIV2 getDump:^(){
            
            self.replyComment.text = @"";
            [self.chooseImage setImage:[UIImage imageNamed:@"select_photo"] forState:UIControlStateNormal];
            imagePath = nil;
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            for (NSMutableDictionary *item in appDelegate.event) {
                if ([[item valueForKey:@"id"] intValue] == eventId) {
                    event = item;
                    break;
                }
            }
            
            images = [event valueForKey:@"images"];
            replies = [event valueForKey:@"replies"];
            
            if ([images count] == 0) {
                self.eventImagesCollectionView.hidden = true;
                self.eventDescription.text = [event valueForKey:@"description"];
            } else {
                self.eventImagesCollectionView.hidden = false;
            }
            self.eventTitle.text = [event valueForKey:@"subject"];
            
            for (NSMutableDictionary *item in appDelegate.focused_event) {
                if ([[[item valueForKey:@"focused_event"] valueForKey:@"id"] intValue] == eventId) {
                    [self.followOrNotButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
                    self.followOrNotButton.tag = 1;
                    break;
                }
            }
            
            self.replyCount.text = [NSString stringWithFormat:@"%d 人回覆", [[event valueForKey:@"reply_num"] intValue]];
            
            [self.replyCollectionView reloadData];
            ((UIButton *)sender).userInteractionEnabled = YES;
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ((UIButton *)sender).userInteractionEnabled = YES;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)deleteImage:(id)sender {
    imagePath = nil;
    self.deleteImageButton.hidden = true;
    [self.chooseImage setImage:[UIImage imageNamed:@"select_photo"] forState:UIControlStateNormal];
}

//UIImagePickerController內建函式
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //取得使用的檔案格式
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        //取得圖片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *resizedImage = [self resizeImageToSize:600 sourceImage:image];
        [self.chooseImage setImage:resizedImage forState:UIControlStateNormal];
        //obtaining saving path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        imagePath = [documentsDirectory stringByAppendingPathComponent:@"photo.jpg"];
        [self saveImage:resizedImage withFileName:@"photo" ofType:@"jpg" inDirectory:documentsDirectory];
        
        self.deleteImageButton.hidden = false;
        
        /*
         //extracting image from the picker and saving it
         NSData *webData = UIImagePNGRepresentation(image);
         [webData writeToFile:imagePath atomically:YES];
         */
    }
    /*
     if ([mediaType isEqualToString:@"public.movie"]) {
     
     //取得影片位置
     // videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
     }
     */
    
    
    //已動畫方式返回先前畫面
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)resizeImageToSize:(int)targetSize sourceImage:(UIImage *)source
{
    float width = source.size.width;
    float height = source.size.height;
    
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth;
    CGFloat scaledHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (width > targetSize || height > targetSize) {
        
        CGFloat widthFactor = targetSize / width;
        CGFloat heightFactor = targetSize / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // make image center aligned
        
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (scaledHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (scaledWidth - scaledWidth) * 0.5;
        }
        CGSize resize;
        resize.width = scaledWidth;
        resize.height = scaledHeight;
        UIGraphicsBeginImageContext(resize);
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width  = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        [source drawInRect:thumbnailRect];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if(newImage == nil)
            NSLog(@"could not scale image");
        
        return newImage ;
        
    } else {
        return source;
    }
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueEventResultToImageDetail"]) {
        ImageDetailViewController *destViewController = segue.destinationViewController;
        EventImageCollectionViewCell *cell = (EventImageCollectionViewCell *)((UIButton *)sender).superview;
        destViewController.image = cell.resultImage.image;
    } else if ([segue.identifier isEqualToString:@"segueEventResultReplyToImageDetail"]) {
        ImageDetailViewController *destViewController = segue.destinationViewController;
        ReplyCollectionViewCell *cell = (ReplyCollectionViewCell *)((UIButton *)sender).superview.superview;
        destViewController.image = cell.userImage.image;
    } else if ([segue.identifier isEqualToString:@"segueEventResultToUserProfile"]) {
        UserProfileViewController *destViewController = segue.destinationViewController;
        long row = ((UIButton *)sender).tag;
        NSMutableDictionary *eventEntity = (NSMutableDictionary *)replies[row];
        destViewController.profile = [eventEntity valueForKey:@"user_account"];
        destViewController.isEditable = false;
    } else if ([segue.identifier isEqualToString:@"segueEventResultNoImageToUserProfile"]) {
        UserProfileViewController *destViewController = segue.destinationViewController;
        long row = ((UIButton *)sender).tag;
        NSMutableDictionary *eventEntity = (NSMutableDictionary *)replies[row];
        destViewController.profile = [eventEntity valueForKey:@"user_account"];
        destViewController.isEditable = false;
    }
}
@end
