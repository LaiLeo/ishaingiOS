//
//  EditEventTypeCollectionViewCell.h
//  volunteers
//
//  Created by jauyou on 2015/3/5.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditEventTypeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UISwitch *enableType;
@end
