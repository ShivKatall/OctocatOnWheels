//
//  RootMenuViewController.m
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/21/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "RootMenuViewController.h"
#import "ReposViewController.h"
#import "UsersViewController.h"
#import "SearchViewController.h"

@interface RootMenuViewController () <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, BurgerButtonProtocol>

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Properties
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UITapGestureRecognizer *tapToClose;

// Primitive Properties
@property (nonatomic) BOOL menuIsOpen;

@end


@implementation RootMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = NO;
    self.tapToClose = [UITapGestureRecognizer new];
    
    [self setupChildViewControllers];
    [self setupDragRecognizer];
}

-(void)setupChildViewControllers
{
    // Assigning View Controllers
    ReposViewController *repoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Repos"];
    repoViewController.title = @"My Repos";
    repoViewController.burgerDelegate = self;
    
    UsersViewController *userViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Users"];
    userViewController.title = @"Following";
    userViewController.burgerDelegate = self;
    
    SearchViewController *searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    searchViewController.title = @"Search";
    searchViewController.burgerDelegate = self;
    
    self.viewControllers = @[repoViewController, userViewController, searchViewController];
    
    
    // Assign topViewController
    self.topViewController = self.viewControllers[0];
    
    [self addChildViewController:self.topViewController];
    [self.view addSubview:self.topViewController.view];
    [self.topViewController didMoveToParentViewController:self];
}

-(void)setupDragRecognizer
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 1;
    
    panRecognizer.delegate = self;
    
    
    [self.view addGestureRecognizer:panRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)movePanel:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
    CGPoint translatedPoint = [pan translationInView:self.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        // Currently Blank
    }
    
    if (pan.state == UIGestureRecognizerStateChanged){
        if (translatedPoint.x > 0){
            self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translatedPoint.x, self.topViewController.view.center.y);
            
            [pan setTranslation:CGPointMake(0, 0) inView:self.view];
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded){
        
        if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 3) {

            [UIView animateWithDuration:.4 animations:^{
                self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * .75, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                
            } completion:^(BOOL finished) {
                
                if (finished) {
                    
                self.tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
                [self.topViewController.view addGestureRecognizer:self.tapToClose];
                    self.tableView.userInteractionEnabled = YES;
                }

            }];
            
        } else {
        
        [UIView animateWithDuration:.4 animations:^{
            
            self.topViewController.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            
            }];
        }
    }
}

-(void)closeMenu:(id)sender
{
      [UIView animateWithDuration:.5 animations:^{
          
          self.topViewController.view.frame = self.view.frame;
          
      } completion:^(BOOL finished) {
          
          [self.topViewController.view removeGestureRecognizer:self.tapToClose];
          self.menuIsOpen = NO;
          
      }];
}

-(void)switchToViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:.2 animations:^{
        
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:^(BOOL finished) {
        
        CGRect offScreen = self.topViewController.view.frame;
        
        // remove old view controller
        [self.topViewController.view removeFromSuperview];
        [self.topViewController removeFromParentViewController];
        
        // add new view controller
        self.topViewController = self.viewControllers[indexPath.row];
        [self addChildViewController:self.topViewController];
        self.topViewController.view.frame = offScreen;
        [self.view addSubview:self.topViewController.view];
        [self.topViewController didMoveToParentViewController:self];
        [self closeMenu:nil];
        
    }];
}

-(void)openMenu
{
    [UIView animateWithDuration:.4 animations:^{
        
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * .75, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self.tapToClose addTarget:self action:@selector(closeMenu:)];
            [self.topViewController.view addGestureRecognizer:self.tapToClose];
            self.menuIsOpen = YES;
            self.tableView.userInteractionEnabled = YES;
        }
    }];
}

-(void)handleBurgerPressed
{
    if (self.menuIsOpen) {
        
        [self closeMenu:nil];
        
    } else {
        
        [self openMenu];
    }
}

# pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.viewControllers[indexPath.row] title];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self switchToViewControllerAtIndexPath:indexPath];
}

@end
