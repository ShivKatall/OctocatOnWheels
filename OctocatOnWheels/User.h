//
//  User.h
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/24/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "Repo.h"

@interface User : Repo

@property (nonatomic, strong) NSString *avatarURLString;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) NSBlockOperation *imageDownloadOperation;

- (instancetype)initWithJSON:(NSDictionary *)dictionary;
- (void)downloadAvatarWithCompletionBlock:(void(^)())completion;
- (void)downloadAvatarOnQueue:(NSOperationQueue *)queue withCompletionBlock:(void(^)())completion;
- (void)cancelAvatarDownload;

@end
