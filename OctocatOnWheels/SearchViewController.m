//
//  SearchViewController.m
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/21/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "Repo.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSURLSessionDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (strong, nonatomic) NSMutableArray *searchRepos;

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) NetworkController *networkController;

@end

@implementation SearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.networkController = self.appDelegate.networkController;
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchRepos = [NSMutableArray new];
    
    [self.networkController requestOAuthAccess];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)burgerPressed:(id)sender
{
    [self.burgerDelegate handleBurgerPressed];
}

-(void)assignDownloadedRepoArrayToRepos:(NSMutableArray *)searchRepos
{
    self.searchRepos = searchRepos;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchTableView reloadData];
    });
}

# pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchRepos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    Repo *repo = self.searchRepos[indexPath.row];
    
    searchCell.textLabel.text = repo.name;
    
    return searchCell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *repo = self.searchRepos[indexPath.row];
    NSInteger repoID = [[repo objectForKey:@"id"] integerValue];
    
    NSURL *deleteURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com//search/repositories", repoID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:deleteURL];
    [request setHTTPMethod:@"DELETE"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *deleteTask = [session dataTaskWithRequest:request
                                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                      NSLog(@"Response : %@", response);
                                                      if (error) {
                                                          NSLog(@"Error Occured: %@", error.localizedDescription);
                                                      } else {
                                                          [self.searchTableView reloadData];
                                                      }
                                                  }];
    [deleteTask resume];
}


# pragma mark - UISearchBar Methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.networkController retrieveReposFromSearchQuery:searchBar.text WithCompletionBlock:^(NSMutableArray *searchRepos) {
            [self assignDownloadedRepoArrayToRepos:searchRepos];
    }];
    
    [searchBar resignFirstResponder];
}

@end
