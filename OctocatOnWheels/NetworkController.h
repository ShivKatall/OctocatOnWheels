//
//  NetworkController.h
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/22/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject

@property (strong,nonatomic) NSString *token;

-(void)requestOAuthAccess;
-(void)handleOAuthCallbackWithURL:(NSURL *)url;
-(void)retrieveReposForCurrentUserWithCompletionBlock:(void(^)(NSMutableArray *userRepos))completionBlock;
-(void)retrieveReposFromSearchQuery:(NSString *)searchQuery WithCompletionBlock:(void(^)(NSMutableArray *searchRepos))completionBlock;

@end
