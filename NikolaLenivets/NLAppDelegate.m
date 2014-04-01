//
//  NLAppDelegate.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 01.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLAppDelegate.h"
#import "AFNetworking.h"

@implementation NLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self fetchData];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)fetchData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:BACKEND_URL
      parameters:nil
         success:^(AFHTTPRequestOperation *op, id response) {
             NSLog(@"Response: %@", response);
         }
         failure:^(AFHTTPRequestOperation *op, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}


- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
