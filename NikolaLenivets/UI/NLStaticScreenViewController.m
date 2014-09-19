//
//  NLStaticScreenViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLStaticScreenViewController.h"
#import "NLStorage.h"
#import "NLScreen.h"
#import "NLMainMenuController.h"
#import "NSAttributedString+Kerning.h"
#import "UIViewController+CustomButtons.h"


@implementation NLStaticScreenViewController
{
    __strong NLScreen *_screen;
    __strong NSString *_screenName;
}


- (id)initWithScreenNamed:(NSString *)screenName
{
    self = [super initWithNibName:@"NLStaticScreenViewController" bundle:nil];
    if (self) {
        _screenName = screenName;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:STORAGE_DID_UPDATE object:nil];
    }
    return self;
}


- (void)update
{
    NLScreen *screen = _.array([[NLStorage sharedInstance] screens]).find(^(NLScreen *s) {
        return [s.name isEqualToString:_screenName];
    });

    if (screen != nil) {
        [self.webView loadHTMLString:screen.content baseURL:[NSURL URLWithString:@"http://"]];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self update];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setupForNavBarWithStyle:NLNavigationBarStyleNoCounter];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)back:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
