//
//  DonateViewController.m
//  volunteers
//
//  Created by jauyou on 2015/2/3.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
//#import "AutoCompleteTableViewCell.h"
#import "DonateCollectionViewCell.h"
#import "DonateNpoDetailViewController.h"
#import "DonateViewController.h"
#import "UserProfileViewController.h"
#import "WilloAPIV2.h"
#import "UIView+Toast.h"

@interface DonateViewController ()
@property(nonatomic,copy)NSMutableString *onlyStr;
@end

@implementation DonateViewController
{
    NSMutableArray *donateNpos;//FIH-modify for donateNpos
    //newebpayPeriodUrl
    // Search bar
    int movementDistance;
    UITextField *selectTextField;
    CGSize keyboardSize;
    NSMutableArray *searchResults;
}
- (void)setOnlyStr:(NSMutableString *)onlyStr

{

    _onlyStr = [onlyStr mutableCopy];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.personButton.userInteractionEnabled = YES;
    self.personButton.hidden = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *expiresIn = [userDefaults stringForKey:@"expiresIn"];
//    if (expiresIn != nil) {
////        [self.view makeToast:@"正在開發中" duration:2.0 position:@"CSToastPositionCenter"];
//        self.personButton.userInteractionEnabled = NO;
//        self.personButton.hidden = YES;
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //FIH-add for 有申請數位支付捐款連結的公益社團排在前面 start
    donateNpos = appDelegate.donation_npo;//根据newebpay_url长度是否为空进行排序
    NSLog(@"infoinfoinfo: %lu", (unsigned long)donateNpos.count);

    //设置新的数据字典，并储存新的数据，
       NSMutableDictionary *dicSceneDatas = [[NSMutableDictionary alloc]init];//newebpay_url不为空
    NSMutableDictionary *newebpay = [[NSMutableDictionary alloc]init];//newebpay_url为空
//    NSMutableString *str1=[[NSMutableString alloc]init];       //遍历整个数据源，获取数据源里面的元素，并将devOrder对应数据设置为dicSceneDatas的key，并将key对应的NSDictionary设置为对应的key对应的value(NSInteger i=0; i<count; i++)
    //(NSDictionary *model in donateNpos)
       for (NSInteger i=0; i<donateNpos.count; i++) {
           NSDictionary * model = donateNpos[i];
           _onlyStr = model[@"newebpay_url"];//链接不唯一 有相同的  链接不能作为key
           NSString *stringInt = [NSString stringWithFormat:@"%ld",(long)i];
           NSString *code = model[@"code"];//9
           if (_onlyStr.length != 0) {
               [dicSceneDatas setObject:model forKey:stringInt];//有链接的字典 5 key有好几个一样的
           }else{
               [newebpay setObject:model forKey:code];//数据源会变少 4
           }

       }
    //获取dicSceneDatas所有的key
        NSArray *keyArray = [dicSceneDatas allKeys];
        NSArray *newebpayArray = [newebpay allKeys];
    
    //这里移除_dataSource所有数据并重新放置
        [donateNpos removeAllObjects];
        //遍历dicSceneDatas，里面存的是所有的数据字典
        for (int i = 0; i < dicSceneDatas.count; i++) {
            //获取sortedArray所有的key并根据i获取到对应的key
            NSString *key = [keyArray objectAtIndex:i];
            //根据排序号的key，通过key获取到对应的数据放置到最新的数据源里即可，最后_dataSource里面就是最新排好序的数据源
            [donateNpos addObject:[dicSceneDatas objectForKey:key]];//有地址的

        }
        for (int i = 0; i < newebpay.count; i++) {
            NSString *key1 = [newebpayArray objectAtIndex:i];
            [donateNpos addObject:[newebpay objectForKey:key1]];//无地址的
    }
    NSLog(@"info: %lu", (unsigned long)donateNpos.count);//有地址加无地址的且最新排序总数据源
//FIH-add for 有申請數位支付捐款連結的公益社團排在前面 end
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
    CGFloat cellHeight = screenWidth * 96 / 320;
    return CGSizeMake(screenWidth, cellHeight);
}

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return donateNpos.count;
    
    NSArray *useArray;
    if ([self.searchBar.text length] != 0) {
        useArray = searchResults;
    } else {
        useArray = donateNpos;
    }
    return useArray.count;
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *useArray;
    if ([self.searchBar.text length] != 0) {
        useArray = searchResults;
    } else {
        useArray = donateNpos;
    }
    
    DonateCollectionViewCell *myCell = [collectionView
                                        dequeueReusableCellWithReuseIdentifier:@"DonateCollectionViewCell"
                                        forIndexPath:indexPath];
        
        long row = [indexPath row];
    
        
        NSMutableDictionary *npoEntity = (NSMutableDictionary *)useArray[row];
        
    
        myCell.name.text = [npoEntity valueForKey:@"name"];
        NSLog(@"file name: %@", myCell.name.text);
        NSString *fileName = [npoEntity valueForKey:@"npo_icon"];

        NSString *strUrl = [fileName stringByReplacingOccurrencesOfString:@"/uploads" withString:@"resources"];

        NSString *urlLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], strUrl];
        
        myCell.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [myCell.spinner setCenter:CGPointMake(myCell.icon.center.x, myCell.icon.center.y)]; // I do this because I'm in landscape mode
        [myCell.icon addSubview:myCell.spinner]; // spinner is not visible until started
        
        [myCell.spinner startAnimating];
        
        // Here we use the new provided setImageWithURL: method to load the web image
        [myCell.icon sd_setImageWithURL:[NSURL URLWithString:urlLick]
                        placeholderImage:[UIImage imageNamed:fileName]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   if ([myCell.spinner isAnimating]) {
                                       [myCell.spinner stopAnimating];
                                   }
                               }];
    
        return myCell;
}

- (void)reloadData {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    donateNpos = [NSMutableArray arrayWithArray:[appDelegate donation_npo]];
    
    [self.collectionView reloadData];
}


- (IBAction)gotoPersonInfo:(id)sender {
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    if (token != nil) {
        // goto PersonDetail
        [self performSegueWithIdentifier:@"segueDonateToUserProfile" sender:self];
    } else {
        // goto Login
        [self performSegueWithIdentifier:@"segueDonateToLogin" sender:self];
    }
}


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
//    [self.replyComment resignFirstResponder];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performFilteringBySearchText:searchBar.text];
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0) {
        searchResults = nil;
        
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    } else {
        

//        autoCompleteArray = [[NSMutableArray alloc] init];
//        if (isVolunteerEvent) {
//            int count = 0;
//            for (NSMutableDictionary *item in volunteerEvents) {
//                if([[item valueForKey:@"subject"] hasPrefix:searchText])
//                {
//                    count++;
//                    [autoCompleteArray addObject:[item valueForKey:@"subject"]];
//                }
//                else if([[NSString stringWithFormat:@"%@%@", [item valueForKey:@"address_city"], [item valueForKey:@"address"]] hasPrefix:searchText])
//                {
//                    [autoCompleteArray addObject:[NSString stringWithFormat:@"%@%@", [item valueForKey:@"address_city"], [item valueForKey:@"address"]]];
//                    count++;
//                    /*if (count == 3) {
//                     break;
//                     }*/
//                }
//            }
//            if (count != 0) {
//                self.autoCompleteTableView.hidden = false;
//            } else {
//                self.autoCompleteTableView.hidden = true;
//            }
//            [self.autoCompleteTableView reloadData];
//        } else {
//            int count = 0;
//            if (count != 0) {
//                self.autoCompleteTableView.hidden = false;
//            } else {
//                self.autoCompleteTableView.hidden = true;
//            }
//            [self.autoCompleteTableView reloadData];
//        }
    }
}


- (void)performFilteringBySearchText:(NSString *)searchText
{
    searchResults = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *item in donateNpos) {
        if([[item valueForKey:@"name"] rangeOfString:searchText].location != NSNotFound)
        {
            [searchResults addObject:item];
        }
    }
    [self.collectionView reloadData];

    
//
//    if (isVolunteerEvent) {
//        for (NSMutableDictionary *item in volunteerEvents) {
//            if([[item valueForKey:@"subject"] rangeOfString:searchText].location != NSNotFound)
//            {
//                [searchResults addObject:item];
//            }
//            else if([[NSString stringWithFormat:@"%@%@", [item valueForKey:@"address_city"], [item valueForKey:@"address"]] rangeOfString:searchText].location != NSNotFound)
//            {
//                [searchResults addObject:item];
//            }
//        }
//        [self.volunteerEventCollectionView reloadData];
//    } else {
//        for (NSMutableDictionary *item in volunteerNpos) {
//            if([[item valueForKey:@"name"] rangeOfString:searchText].location != NSNotFound)
//            {
//                [searchResults addObject:item];
//            }
//        }
//        [self.volunteerNpoCollectionView reloadData];
//    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueDonateToDonateNpoDetail"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        DonateNpoDetailViewController *destViewController = segue.destinationViewController;
        
        NSArray *useArray;
        if ([self.searchBar.text length] != 0) {
            useArray = searchResults;
        } else {
            useArray = donateNpos;
        }
        
        NSMutableDictionary *donateNpo = useArray[indexPath.row];
        destViewController.donateNpo = donateNpo;
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    } else if ([segue.identifier isEqualToString:@"segueDonateToUserProfile"]) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        UserProfileViewController *destViewController = segue.destinationViewController;
        destViewController.profile = appDelegate.user;
        destViewController.isEditable = true;
    }
}
@end
