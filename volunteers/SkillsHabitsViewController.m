//
//  SkillsHabitsViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/4.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import "SkillsHabitsViewController.h"
#import "SkillHabitCollectionViewCell.h"

@interface SkillsHabitsViewController ()

@end

@implementation SkillsHabitsViewController
{
    bool isSkill;
//    (void (^ __nullable)()) *listener;
    void (^ __nullable listener)(NSArray*, NSArray*);
    NSString *skillHabitString;
    NSArray *skillHabitArray;
    NSArray *allItems;
    NSMutableArray * childViews;
    NSMutableArray * _selectedItems;
    
//    bool selectable;
//    int maxSelectableItem;
    int selectedItemNumber;
    
}
@synthesize isSkill;
@synthesize title;
@synthesize skillHabitString;
@synthesize listener;
@synthesize allItems;
@synthesize selectable;
@synthesize maxSelectableItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (isSkill) {
//        self.viewControllerTitle.title = @"專長";
//    } else {
//        self.viewControllerTitle.title = @"喜好";
//    }
    
    self.viewControllerTitle.title = title;
    skillHabitArray = [skillHabitString componentsSeparatedByString:@","];
    NSLog(@"array = %@", allItems);
    if(selectable == NO){
        allItems = skillHabitArray;
    }
    childViews = [[NSMutableArray alloc] initWithCapacity:allItems.count];
    _selectedItems = [[NSMutableArray alloc] initWithCapacity:allItems.count];
   
    for(int i=0; i < allItems.count; i++){
        [_selectedItems addObject:[NSNumber numberWithBool:NO]];
    }
    
    for(NSString * selectedItem in skillHabitArray){
        NSString* trimed = [selectedItem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSUInteger index = [allItems indexOfObject:trimed];
        NSLog(@"testing %@", trimed);
        if(index == NSNotFound){
            NSLog(@"warn: not found");
            continue;
        }
        selectedItemNumber++;
        [_selectedItems replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
    }


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

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return allItems.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout*)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    long row = [indexPath row];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.text = allItems[row];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat fixedWidth = screenWidth - 20;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    float width = newSize.width + 20;
    newFrame.size = CGSizeMake(fmaxf(width, fixedWidth), newSize.height);
    
    return CGSizeMake(width, newSize.height);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SkillHabitCollectionViewCell *myCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"skillHabitCell" forIndexPath:indexPath];
    long row = [indexPath row];
    myCell.skillHabitString.text = allItems[row];
    
    UITapGestureRecognizer* tapRegcognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [myCell addGestureRecognizer:tapRegcognizer];
    [myCell setUserInteractionEnabled:YES];
//    [childViews addObject:myCell];
    [childViews insertObject:myCell atIndex:row];
//    [childViews replaceObjectAtIndex:row withObject:myCell];
    [self refreshView:(int)indexPath.row];
    return myCell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectxItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"item: %d", indexPath.row);
//
//}

- (void)singleTap:(UIGestureRecognizer *)recognizer {
    NSLog(@"singleTap: %@", NSStringFromCGPoint([recognizer locationInView:[recognizer.view superview]]));
//    UICollectionView * collectionView = recognizer.view.subviews;
    
    SkillHabitCollectionViewCell* cell = (SkillHabitCollectionViewCell*)recognizer.view;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSLog(@"view: %@ indexPath: %ld", recognizer.view, indexPath.row);
    BOOL value = ![[_selectedItems objectAtIndex: indexPath.row] boolValue];
    if(selectedItemNumber >= maxSelectableItem && value == YES){
        return;
    }
    
    [_selectedItems replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
    if(value == YES){
        selectedItemNumber++;
    }else{
        selectedItemNumber--;
    }
    [self refreshView:(int)indexPath.row];
    
}

- (void)refreshAllView {
    for(int i=0; i<childViews.count; i++){
        [self refreshView:i];
    }
}

- (void)refreshView:(int) i {
    if([childViews objectAtIndex:i] == NULL){
        return;
    }
    SkillHabitCollectionViewCell * cell = [childViews objectAtIndex:i];
    if([[_selectedItems objectAtIndex: i] boolValue] == YES && selectable != false){
        UIColor * color = [[UIColor alloc] initWithRed:229.0/255 green:86.0/255 blue:7.0/255 alpha:1.0];
        cell.skillHabitString.textColor = color;
    }else{
        UIColor * color = UIColor.blackColor;
        cell.skillHabitString.textColor = color;
    }
    
}

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if(self->listener != NULL){
            listener(allItems, _selectedItems);
        }
        
    }];
}
@end
