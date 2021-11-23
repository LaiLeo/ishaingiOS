//
//  EventResultViewController.h
//  volunteers
//
//  Created by jauyou on 2015/2/2.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventResultViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property int eventId;
@property NSMutableDictionary *event;

@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;
@property (weak, nonatomic) IBOutlet UICollectionView *eventImagesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *replyCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *followOrNotButton;
@property (weak, nonatomic) IBOutlet UILabel *replyCount;
@property (weak, nonatomic) IBOutlet UIButton *chooseImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteImageButton;
@property (weak, nonatomic) IBOutlet UITextField *replyComment;
- (IBAction)doDismiss:(id)sender;
- (IBAction)doFollowOrNot:(id)sender;
- (IBAction)doShare:(id)sender;
- (IBAction)choosePicFromMedia:(id)sender;
- (IBAction)doReply:(id)sender;
- (IBAction)deleteImage:(id)sender;
@end
