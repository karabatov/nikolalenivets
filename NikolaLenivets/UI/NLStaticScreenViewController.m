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
        self.titleLabel.attributedText = [NSAttributedString kernedStringForString:[screen.fullname uppercaseString]];
        [self.webView loadHTMLString:screen.content baseURL:[NSURL URLWithString:@"http://"]];
    } else {
        self.titleLabel.text = @"";
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.titleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:18];
    [self update];
}


- (IBAction)back:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
