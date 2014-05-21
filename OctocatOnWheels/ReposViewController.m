//
//  ReposViewController.m
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/21/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "ReposViewController.h"
#import "AppDelegate.h"
#import "Repo.h"
#import "UIColor+ColorScheme.h"

@interface ReposViewController () <UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate>


@property (strong, nonatomic) IBOutlet UIView *reposView;
@property (weak, nonatomic) IBOutlet UITableView *reposTableView;

@property (strong, nonatomic) NSMutableArray *repos;

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) NetworkController *networkController;

@end

@implementation ReposViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.reposView setBackgroundColor:[UIColor belizeHoleColor]];
    [self.reposTableView setBackgroundColor:[UIColor belizeHoleColor]];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.networkController = self.appDelegate.networkController;
    
//    [self.networkController retrieveReposForCurrentUserWithCompletionBlock:^(NSMutableArray *repos) {
//        
//        [self assignDownloadedRepoArrayToRepos:repos];
//    }];
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

-(void)assignDownloadedRepoArrayToRepos:(NSMutableArray *)repoArray
{
    self.repos = repoArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.reposTableView reloadData];
    });
}

# pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *userRepoCell = [tableView dequeueReusableCellWithIdentifier:@"RepoCell" forIndexPath:indexPath];
    
    Repo *repo = self.repos[indexPath.row];
    
    userRepoCell.textLabel.text = repo.name;
    userRepoCell.textLabel.textColor = [UIColor midnightBlueColor];
    userRepoCell.backgroundColor = [UIColor peterRiverColor];
    
    return userRepoCell;
}

@end
