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

@interface ReposViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSURLSessionDelegate, NetworkControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *reposTableView;

@property (strong, nonatomic) NSMutableArray *arrayOfRepos;

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) NetworkController *networkController;

@end

@implementation ReposViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.networkController = self.appDelegate.networkController;
    
    [self.networkController retrieveReposForCurrentUser];
    
    self.networkController.delegate = self;
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

-(void)reposDoneDownloading:(NSMutableArray *)repoArray
{
    self.arrayOfRepos = repoArray;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.reposTableView reloadData];
    }];
}

# pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfRepos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *repoCell = [tableView dequeueReusableCellWithIdentifier:@"RepoCell" forIndexPath:indexPath];
    
    Repo *repo = self.arrayOfRepos[indexPath.row];
    
    repoCell.textLabel.text = repo.name;
    
    return repoCell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
