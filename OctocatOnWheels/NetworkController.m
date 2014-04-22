//
//  NetworkController.m
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/22/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "NetworkController.h"
#import "Repo.h"

#define GITHUB_CLIENT_ID @"1426a10e13a721ed4441"
#define GITHUB_CLIENT_SECRET @"051eb92409fed9160fb5741c4bcb6bc6543c8adc"
#define GITHUB_CALLBACK_URI @"oowauth://git_callback"
#define GITHUB_OAUTH_URL @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@" // Study and learn this line better.
#define GITHUB_API_URL @"https://api.github.com/"

@implementation NetworkController

-(id)init
{
    self = [super init];
    if (self)
    {
        self.token = [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthtoken"];
        
        if (!self.token)
        {
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
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
        // setup url request
        NSMutableURLRequest *request = [NSMutableURLRequest new];
        [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"context-length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [request setHTTPBody:postData];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
    NSArray *access_token_array = [accessTokenWithCode componentsSeparatedByString:@"="]; // Why did we name our instance weird?
    
    NSLog(@"%@", access_token_array);
    
    return access_token_array[1];
}

-(NSString *)getCodeFromCallbackURL:(NSURL *)callbackURL
{
    NSString *query = [callbackURL query];
    NSLog(@"%@", query);
    NSArray *components = [query componentsSeparatedByString:@"code="];
    
    return [components lastObject];
}

-(void)retrieveReposForCurrentUser
{
    // Set Parameters
    NSURL *userRepoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/repos", GITHUB_API_URL]];
    NSURLSessionConfiguration *UserRepoSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *userRepoSession = [NSURLSession sessionWithConfiguration:UserRepoSessionConfiguration];
   
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
        
        NSArray *jsonTempArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *userRepos = [NSMutableArray new];
        
        for (NSDictionary *repoDictionary in jsonTempArray) {
            Repo *newRepo = [Repo new];
            newRepo.name = [repoDictionary objectForKey:@"name"];
            newRepo.url = [repoDictionary objectForKey:@"url"];
            [userRepos addObject:newRepo];
        }
        
        [self.delegate reposDoneDownloading:userRepos];
        
    }];
    
    [userRepoDataTask resume];
}

@end
