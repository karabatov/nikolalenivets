//
//  NLAppDelegate.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 01.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLAppDelegate.h"
#import "AFNetworking.h"
#import "NLStorage.h"

#import "NLMainMenuController.h"

#import <Crashlytics/Crashlytics.h>

@implementation NLAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"2859bb1aae7d9b32942d1d64eebd584fa07a88af"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NLMainMenuController *main = [NLMainMenuController new];
    self.window.rootViewController = main;
    
    [[NLStorage sharedInstance] update];
    
    [self.window makeKeyAndVisible];
    return YES;
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
