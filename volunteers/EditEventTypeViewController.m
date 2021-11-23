//
//  EditEventTypeViewController.m
//  volunteers
//
//  Created by jauyou on 2015/3/5.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import "EditEventTypeViewController.h"
#import "EditEventTypeCollectionViewCell.h"

@interface EditEventTypeViewController ()

@end

@implementation EditEventTypeViewController
{
    NSMutableArray *typeEnableList;
    NSString *skillDescription;
    NSArray *useArray;
}
@synthesize typeEnableList;
@synthesize useArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    return CGSizeMake(screenWidth, 50.0);
}

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return useArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditEventTypeCollectionViewCell *myCell = [collectionView
                                                 dequeueReusableCellWithReuseIdentifier:@"EditEventTypeCollectionViewCell"
                                                 forIndexPath:indexPath];
    
    long row = [indexPath row];
    NSString *typeName = useArray[row];
    myCell.typeName.text = typeName;
    
    
    [myCell.enableType setOn:NO];
    
    if (typeEnableList != nil) {
        for (NSString *type in typeEnableList) {
            if ([type isEqualToString:typeName]) {
                [myCell.enableType setOn:YES];
            }
        }
    }
    
    return myCell;
}


- (IBAction)doDissmiss:(id)sender {
    [self.delegate setTypeViewController:self didFinishEnteringItem:typeEnableList];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeEnable:(id)sender {
    
    UISwitch *uiSwitch = (UISwitch *)sender;
    
//    NSLog(@"changeEnable %@", NSStringFromClass([uiSwitch.superview class]));
//    NSLog(@"changeEnable %@", NSStringFromClass([uiSwitch.superview.superview class]));
//    NSLog(@"changeEnable %@", NSStringFromClass([uiSwitch.superview.superview.superview class]));
    
    UIView *tmp = uiSwitch.superview;
    for (int i = 0;i < 5; i++){
        if([NSStringFromClass([tmp class])  isEqual: @"EditEventTypeCollectionViewCell"]){
            break;
        }
        tmp = tmp.superview;
    }
    
    EditEventTypeCollectionViewCell *editEventTypeCollectionViewCell = (EditEventTypeCollectionViewCell *)tmp;
    NSString *typeName = editEventTypeCollectionViewCell.typeName.text;
    
    if ([uiSwitch isOn]) {
        [typeEnableList addObject:typeName];
    } else {
        int index;
        for (index = 0; index < typeEnableList.count; index++) {
            if ([typeEnableList[index] isEqualToString:typeName]) {
                [typeEnableList removeObjectAtIndex:index];
            }
        }
    }
}

@end
//