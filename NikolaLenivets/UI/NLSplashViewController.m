//
//  NLSplashViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 25.06.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSplashViewController.h"
#import "NLLocationManager.h"
#import "NLStorage.h"


@implementation NLSplashViewController

- (id)init
{
    self = [super initWithNibName:@"NLSplashViewController" bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReceived) name:STORAGE_DID_UPDATE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headingUpdated:) name:NLUserHeadingUpdated object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [[AppDelegate window] frame];
}


- (void)dataReceived
{
    [AppDelegate dismissSplash];
}


- (void)headingUpdated:(NSNotification *)notification
{
    self.compass.transform = [[NLLocationManager sharedInstance] compassTransform];
}

@end
