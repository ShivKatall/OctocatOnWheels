//
//  SearchViewController.m
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/21/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSURLSessionDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOfRepos;

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) NetworkController *networkController;

@end

@implementation SearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.networkController = self.appDelegate.networkController;
    
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.arrayOfRepos = [NSMutableArray new];
//    
//    [self.networkController requestOAuthAccess];
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *repo = _arrayOfRepos[indexPath.row];
//    NSInteger repoID = [[repo objectForKey:@"id"] integerValue];
//    
//    NSURL *deleteURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com//search/repositories, repoID]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:deleteURL];
//    [request setHTTPMethod:@"DELETE"];
//    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    NSURLSessionDataTask *deleteTask = [session dataTaskWithRequest:request
//                                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                      NSLog(@"Response : %@", response);
//                                                      if (error) {
//                                                          NSLog(@"Error Occured: %@", error.localizedDescription);
//                                                      } else {
//                                                          [self.tableView reloadData];
//                                                      }
//                                                  }];
//    [deleteTask resume];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)burgerPressed:(id)sender
{
    [self.burgerDelegate handleBurgerPressed];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfRepos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    NSDictionary *repoDictionary = self.arrayOfRepos[indexPath.row];
    
    searchCell.textLabel.text = repoDictionary[@"name"];
    
    return searchCell;
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
