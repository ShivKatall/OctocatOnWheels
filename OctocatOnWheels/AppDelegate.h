//
//  AppDelegate.h
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/21/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NetworkController *networkController;

@end
