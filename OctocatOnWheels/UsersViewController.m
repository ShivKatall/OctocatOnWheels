//
//  UsersViewController.m
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/21/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "UsersViewController.h"

@interface UsersViewController ()

@end

@implementation UsersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
