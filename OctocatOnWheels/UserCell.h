//
//  UserCell.h
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/24/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserCell : UICollectionViewCell

#define USER_CELL_IDENTIFIER @"UserCell"

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;


@end
