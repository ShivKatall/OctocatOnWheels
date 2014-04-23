//
//  NetworkController.h
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/22/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkControllerDelegate <NSObject>

-(void)assignDownloadedRepoArrayToRepos:(NSMutableArray *)repoArray;

@end

@interface NetworkController : NSObject

@property (nonatomic, weak) id <NetworkControllerDelegate> delegate;

@property (strong,nonatomic) NSString *token;

-(void)requestOAuthAccess;
-(void)handleOAuthCallbackWithURL:(NSURL *)url;
-(void)retrieveReposForCurrentUser;


@end
