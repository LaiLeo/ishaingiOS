//
//  EditSkillStringViewController.m
//  volunteers
//
//  Created by jauyou on 2015/3/2.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import "EditSkillStringViewController.h"
#import "EditSkillStringCollectionViewCell.h"

@interface EditSkillStringViewController ()

@end

@implementation EditSkillStringViewController
{
    NSMutableArray *skills;
    NSString *skillDescription;
    NSArray *useArray;
}
@synthesize skills;
@synthesize skillDescription;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    useArray = [skillDescription componentsSeparatedByString:@","];
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
    EditSkillStringCollectionViewCell *myCell = [collectionView
                                                    dequeueReusableCellWithReuseIdentifier:@"EditSkillStringCell"
                                                    forIndexPath:indexPath];
        
    long row = [indexPath row];
    NSString *skillName = useArray[row];
    myCell.skillName.text = skillName;
    

    [myCell.enableSkill setOn:NO];
    
    if (skills != nil) {
        for (NSString *skill in skills) {
            if ([skill isEqualToString:skillName]) {
                [myCell.enableSkill setOn:YES];
            }
        }   
    }
    
    return myCell;
}


- (IBAction)doDissmiss:(id)sender {
    if (skills.count == 0) {
        [self.delegate addItemViewController:self didFinishEnteringItem:nil];
    } else if(skills.count == 1) {
        [self.delegate addItemViewController:self didFinishEnteringItem:skills[0]];
    } else {
        NSMutableString *itemToPassBack = [[NSMutableString alloc] initWithString:skills[0]];
        for (int i = 1; i < skills.count; i++) {
            [itemToPassBack appendFormat:@",%@", skills[i]];
        }
        [self.delegate addItemViewController:self didFinishEnteringItem:itemToPassBack];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeSkill:(id)sender {
    UISwitch *uiSwitch = (UISwitch *)sender;
    EditSkillStringCollectionViewCell *editSkillStringCollectionViewCell = (EditSkillStringCollectionViewCell *)uiSwitch.superview;
    EditSkillStringCollectionViewCell *Cell = (EditSkillStringCollectionViewCell *)editSkillStringCollectionViewCell.superview;
    EditSkillStringCollectionViewCell *Cells = (EditSkillStringCollectionViewCell *)Cell.superview;

    NSLog(@"%@",Cells.skillName.class);
    NSString *skillName = Cells.skillName.text;
    
    if ([uiSwitch isOn]) {
        [skills addObject:skillName];
    } else {
        int index;
        for (index = 0; index < skills.count; index++) {
            if ([skills[index] isEqualToString:skillName]) {
                [skills removeObjectAtIndex:index];
            }
        }
    }
}
@end
