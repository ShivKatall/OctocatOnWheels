//
//  User.m
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/24/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "User.h"

@interface User()

@property (nonatomic, strong) NSURL *avatarURL;

@end

@implementation User

- (instancetype)initWithJSON:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        self.name = [dictionary objectForKey:@"login"];
        self.url = [dictionary objectForKey:@"html_url"];
        self.avatarURLString = [dictionary objectForKey:@"avatar_url"];
    }
    
    return self;
}

- (void)downloadAvatarWithCompletionBlock:(void(^)())completion
{
    [self downloadAvatarOnQueue:[NSOperationQueue new] withCompletionBlock:completion];
}

- (void)downloadAvatarOnQueue:(NSOperationQueue *)queue withCompletionBlock:(void (^)())completion
{
    self.imageDownloadOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:self.avatarURL];
        _avatarImage = [UIImage imageWithData:imageData];
        [[NSOperationQueue mainQueue] addOperationWithBlock:completion];
    }];
    [queue addOperation:self.imageDownloadOperation];
}

- (void)cancelAvatarDownload
{
    if (!self.imageDownloadOperation.isExecuting) {
        [self.imageDownloadOperation cancel];
    }
}

- (NSURL *)avatarURL
{
    return [NSURL URLWithString:_avatarURLString];
}

@end
