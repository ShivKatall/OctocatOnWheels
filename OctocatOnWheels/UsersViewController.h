//
//  UsersViewController.h
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/21/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "burgerButtonProtocol.h"

@interface UsersViewController : UIViewController

@property (nonatomic,unsafe_unretained) id <BurgerButtonProtocol> burgerDelegate;

@end
