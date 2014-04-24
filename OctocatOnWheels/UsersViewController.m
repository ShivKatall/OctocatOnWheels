//
//  UsersViewController.m
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/21/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "UsersViewController.h"
#import "AppDelegate.h"
#import "UIColor+ColorScheme.h"
#import "User.h"
#import "UserCell.h"

@interface UsersViewController () <UICollectionViewDataSource, UICollectionViewDelegate, NSURLSessionDelegate>

@property (strong, nonatomic) IBOutlet UIView *usersView;
@property (weak, nonatomic) IBOutlet UICollectionView *usersCollectionView;

@property (strong, nonatomic) NSMutableArray *followedUsers;

@property (strong, nonatomic) NSOperationQueue *imageQueue;

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) NetworkController *networkController;

@end

@implementation UsersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.usersView setBackgroundColor:[UIColor greenSeaColor]];
    [self.usersCollectionView setBackgroundColor:[UIColor greenSeaColor]];
    
    self.usersCollectionView.delegate = self;
    self.usersCollectionView.dataSource = self;
    
    self.imageQueue = [NSOperationQueue new];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.networkController = self.appDelegate.networkController;

    [self.networkController retrieveFollowedUsersForCurrentUserWithCompletionBlock:^(NSMutableArray *followedUsers) {
        [self assignDownloadedUserArrayToFollowedUsers:followedUsers];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)burgerPressed:(id)sender
{
    [self.burgerDelegate handleBurgerPressed];
}

-(void)assignDownloadedUserArrayToFollowedUsers:(NSMutableArray *)userArray
{
    self.followedUsers = userArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.usersCollectionView reloadData];
    });
}


# pragma mark - UICollectionView Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.followedUsers.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *userCell = [collectionView dequeueReusableCellWithReuseIdentifier:USER_CELL_IDENTIFIER forIndexPath:indexPath];
    NSLog(@" cellforitem");
        User *user = self.followedUsers[indexPath.item];
    
    
        if (user.avatarImage){
            userCell.userImage.image = user.avatarImage;
        } else {
            NSLog(@"we are here");
            userCell.userImage.image = [UIImage imageNamed:@"BlankFace"];
            [user downloadAvatarOnQueue:_imageQueue withCompletionBlock:^{
                
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        }
    userCell.userName.text = user.name;
    
    userCell.userName.textColor = [UIColor midnightBlueColor];
    userCell.backgroundColor = [UIColor turquoiseColor];
    
    
    return userCell;
}

@end
