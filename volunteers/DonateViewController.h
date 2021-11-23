//
//  DonateViewController.h
//  volunteers
//
//  Created by jauyou on 2015/2/3.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonateViewController : UIViewController<UITextFieldDelegate, UISearchBarDelegate>
- (IBAction)gotoPersonInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *personButton;
@end
