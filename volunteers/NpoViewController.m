//
//  NpoViewController.m
//  volunteers
//
//  Created by jauyou on 2015/3/18.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import "NpoDetailViewController.h"
#import "NpoViewController.h"
#import "VolunteerNpoCollectionViewCell.h"
#import "WilloAPIV2.h"

@interface NpoViewController ()

@end

@implementation NpoViewController
{
    NSString *viewControllerTitle;
    NSArray *npos;
}
@synthesize viewControllerTitle;
@synthesize npos;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (viewControllerTitle != nil) {
        self.viewTitle.title = viewControllerTitle;
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
    return npos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VolunteerNpoCollectionViewCell *myCell = [collectionView
                                              dequeueReusableCellWithReuseIdentifier:@"NpoCell"
                                              forIndexPath:indexPath];
    
    long row = [indexPath row];
    
    myCell.viewController = self;
    NSMutableDictionary *npoEntity = [(NSMutableDictionary *)npos[row] valueForKey:@"subscribed_NPO"];
    
    myCell.npoId = [[npoEntity valueForKey:@"id"] intValue];
    
    myCell.title.text = [npoEntity valueForKey:@"name"];
    
    NSString *fileNames = [npoEntity valueForKey:@"npo_icon"];

    NSString *strUrl = [fileNames stringByReplacingOccurrencesOfString:@"/uploads" withString:@"resources"];

    NSString *urlLick = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], strUrl];
    
//    NSString *urlLink = [NSString stringWithFormat:@"%@%@", [WilloAPIV2 getHostName], [npoEntity valueForKey:@"npo_icon"]];
    NSString *fileName = [[urlLick componentsSeparatedByString:@"/"] lastObject];
    NSLog(@"urlLink: %@ fileName: %@", urlLick, fileName);
    
    myCell.judgeNum.text = [NSString stringWithFormat:@"%@ 人", [npoEntity valueForKey:@"rating_user_num"]];
    myCell.followNum.text = [NSString stringWithFormat:@"%@ 人", [npoEntity valueForKey:@"subscribed_user_num"]];
    myCell.eventCount.text = [NSString stringWithFormat:@"%@ 場活動", [npoEntity valueForKey:@"event_num"]];
    myCell.joinNum.text = [NSString stringWithFormat:@"%@ 人", [npoEntity valueForKey:@"joined_user_num"]];
    
    int totalRatingScore = [[npoEntity valueForKey:@"total_rating_score" ] intValue];
    if (totalRatingScore == 5) {
        [myCell.score5 setImage:[UIImage imageNamed:@"star_2"]];
        [myCell.score4 setImage:[UIImage imageNamed:@"star_2"]];
        [myCell.score3 setImage:[UIImage imageNamed:@"star_2"]];
        [myCell.score2 setImage:[UIImage imageNamed:@"star_2"]];
        [myCell.score1 setImage:[UIImage imageNamed:@"star_2"]];
    } else if (totalRatingScore == 4) {
        [myCell.score5 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score4 setImage:[UIImage imageNamed:@"star_2"]];
        [myCell.score3 setImage:[UIImage imageNamed:@"star_2"]];
        [myCell.score2 setImage:[UIImage imageNamed:@"star_2"]];
        [myCell.score1 setImage:[UIImage imageNamed:@"star_2"]];
    } else if (totalRatingScore == 3) {
        [myCell.score5 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score4 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score3 setImage:[UIImage imageNamed:@"star_2"]];
        [myCell.score2 setImage:[UIImage imageNamed:@"star_2"]];
        [myCell.score1 setImage:[UIImage imageNamed:@"star_2"]];
    }else if (totalRatingScore == 2) {
        [myCell.score5 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score4 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score3 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score2 setImage:[UIImage imageNamed:@"star_2"]];
        [myCell.score1 setImage:[UIImage imageNamed:@"star_2"]];
    }else if (totalRatingScore == 1) {
        [myCell.score5 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score4 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score3 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score2 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score1 setImage:[UIImage imageNamed:@"star_2"]];
    } else {
        [myCell.score5 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score4 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score3 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score2 setImage:[UIImage imageNamed:@"star_0"]];
        [myCell.score1 setImage:[UIImage imageNamed:@"star_0"]];
    }
    
    myCell.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [myCell.spinner setCenter:CGPointMake(myCell.image.center.x, myCell.image.center.y)]; // I do this because I'm in landscape mode
    [myCell.image addSubview:myCell.spinner]; // spinner is not visible until started
    
    [myCell.spinner startAnimating];
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [myCell.image sd_setImageWithURL:[NSURL URLWithString:urlLick]
                    placeholderImage:[UIImage imageNamed:fileName]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if ([myCell.spinner isAnimating]) {
                                   [myCell.spinner stopAnimating];
                               }
                           }];
    return myCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueNpoToNpoDetail"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        NpoDetailViewController *destViewController = segue.destinationViewController;
        NSMutableDictionary *npo = [(NSMutableDictionary *)npos[indexPath.row] valueForKey:@"subscribed_NPO"];
        destViewController.npo = npo;
        destViewController.npoId = [[npo valueForKey:@"id"] intValue];
    }
}

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
