//
//  NetworkController.m
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/22/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "NetworkController.h"
#import "Repo.h"
#import "User.h"

#define GITHUB_CLIENT_ID @"1426a10e13a721ed4441"
#define GITHUB_CLIENT_SECRET @"051eb92409fed9160fb5741c4bcb6bc6543c8adc"
#define GITHUB_CALLBACK_URI @"oowauth://git_callback"
#define GITHUB_OAUTH_URL @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@" // Study and learn this line better.
#define GITHUB_API_URL @"https://api.github.com/"

@interface NetworkController ()

@property (nonatomic, strong)NSURLSession *urlSession;

@end

@implementation NetworkController

-(id)init
{
    self = [super init];
    if (self)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        self.urlSession = [NSURLSession sessionWithConfiguration:configuration];
        
        self.token = [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthtoken"];
        
        if (!self.token) {
            [self performSelector:@selector(requestOAuthAccess) withObject:nil afterDelay:.1];
        }
    }
    return self;
}

-(void)requestOAuthAccess
{
    NSString *urlString = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID,GITHUB_CALLBACK_URI,@"user,repo"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void)handleOAuthCallbackWithURL:(NSURL *)url
{
    NSLog(@"%@", url);

        // setting parameters
        NSString *code = [self getCodeFromCallbackURL:url];
        NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@", GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, code];
        NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]; //??
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long) [postData length]]; //??
    
        // setup url request
        NSMutableURLRequest *request = [NSMutableURLRequest new];
        [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"context-length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [request setHTTPBody:postData];
        
        NSURLSessionDataTask *postDataTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"error: %@", error.description);
            }
            
            NSLog(@"%@", response.description);
            
            NSString *myToken =[self convertResponseDataIntoToken:data];
            [[NSUserDefaults standardUserDefaults] setValue:myToken forKeyPath:@"oauthtoken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }];
    
    [postDataTask resume];
}

-(NSString *)convertResponseDataIntoToken:(NSData *)responseData // WTF????
{
    NSString *tokenResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSArray *tokenComponents = [tokenResponse componentsSeparatedByString:@"&"];
    NSString *accessTokenWithCode = tokenComponents[0];
    NSArray *accessTokenArray = [accessTokenWithCode componentsSeparatedByString:@"="];
    
    NSLog(@"%@", accessTokenArray);
    
    return accessTokenArray[1];
}

-(NSString *)getCodeFromCallbackURL:(NSURL *)callbackURL
{
    NSString *query = [callbackURL query];
    NSLog(@"%@", query);
    NSArray *components = [query componentsSeparatedByString:@"code="];
    
    return [components lastObject];
}

#pragma mark - ReposViewController Network Methods

-(void)retrieveReposForCurrentUserWithCompletionBlock:(void(^)(NSMutableArray *userRepos))completionBlock
{
    // Set Parameters
    NSURL *userRepoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/repos", GITHUB_API_URL]];
    NSURLSessionConfiguration *userRepoSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *userRepoSession = [NSURLSession sessionWithConfiguration:userRepoSessionConfiguration];
   
    // Set Up Request
    NSMutableURLRequest *userRepoRequest = [NSMutableURLRequest new];
    [userRepoRequest setURL:userRepoURL];
    [userRepoRequest setHTTPMethod:@"GET"];
    [userRepoRequest setValue:[NSString stringWithFormat:@"token %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    // Set Up Data Task
    NSURLSessionDataTask *userRepoDataTask = [userRepoSession dataTaskWithRequest:userRepoRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.description);
        }
        
        NSLog(@" %@",response.description);
        
        NSArray *jsonTempUserRepoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *userRepos = [NSMutableArray new];
        
        [jsonTempUserRepoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Repo *newUserRepo = [Repo new];
            newUserRepo.name = [obj objectForKey:@"name"];
            newUserRepo.url = [obj objectForKey:@"url"];
            [userRepos addObject:newUserRepo];
        }];
        
        completionBlock(userRepos);
        
    }];
    
    [userRepoDataTask resume];
}


#pragma mark - UsersViewController Network Methods

-(void)retrieveFollowedUsersForCurrentUserWithCompletionBlock:(void(^)(NSMutableArray *followedUsers))completionBlock
{
    // Set Parameters
    NSURL *followedUserURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/following",  GITHUB_API_URL]]; // find this
    NSURLSessionConfiguration *followedUserSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *followedUserSession = [NSURLSession sessionWithConfiguration:followedUserSessionConfiguration];
    
    // Set Up Request
    NSMutableURLRequest *followedUserRequest = [NSMutableURLRequest new];
    [followedUserRequest setURL:followedUserURL];
    [followedUserRequest setHTTPMethod:@"GET"];
    [followedUserRequest setValue:[NSString stringWithFormat:@"token %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    // Set Up Data Task
    NSURLSessionDataTask *followedUserDataTask = [followedUserSession dataTaskWithRequest:followedUserRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.description);
        }
        
        NSLog(@" %@",response.description);
        
        NSArray *jsonTempFollowedUserArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *followedUsers = [NSMutableArray new];
        
        [jsonTempFollowedUserArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            User *newFollowedUser = [User new];
            newFollowedUser.name = [obj objectForKey:@"login"];
            newFollowedUser.url = [obj objectForKey:@"url"];
            newFollowedUser.avatarURLString = [obj objectForKey:@"avatar_url"];
            [followedUsers addObject:newFollowedUser];
        }];
        
        completionBlock(followedUsers);
    }];
    
    [followedUserDataTask resume];
}


#pragma mark - SearchViewController Network Methods

-(void)retrieveReposFromSearchQuery:(NSString *)searchQuery WithCompletionBlock:(void(^)(NSMutableArray *searchRepos))completionBlock
{
    // Set Parameters
    NSURL *searchRepoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@search/repositories?q=%@", GITHUB_API_URL, searchQuery]];
    NSURLSessionConfiguration *searchRepoSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *searchRepoSession = [NSURLSession sessionWithConfiguration:searchRepoSessionConfiguration];
    
    // Set Up Request
    NSMutableURLRequest *searchRepoRequest = [NSMutableURLRequest new];
    [searchRepoRequest setURL:searchRepoURL];
    [searchRepoRequest setHTTPMethod:@"GET"];
    [searchRepoRequest setValue:[NSString stringWithFormat:@"token %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    // Set Up Data Task
    NSURLSessionDataTask *searchRepoDataTask = [searchRepoSession dataTaskWithRequest:searchRepoRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error.description);
        }
        
        NSLog(@"%@",response.description);
        
        NSDictionary *jsonTempSearchRepoDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *jsonTempSearchRepoArray = [jsonTempSearchRepoDictionary objectForKey:@"items"];
        
        NSMutableArray *searchRepos = [NSMutableArray new];
        
        [jsonTempSearchRepoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Repo *newSearchRepo = [Repo new];
            newSearchRepo.name = [obj objectForKey:@"name"];
            newSearchRepo.url = [obj objectForKey:@"url"];
            [searchRepos addObject:newSearchRepo];
        }];
        
        completionBlock (searchRepos);
    }];
    
    [searchRepoDataTask resume];
}

@end
