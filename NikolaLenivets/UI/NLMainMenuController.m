//
//  NLMainMenuController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 17.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLMainMenuController.h"


@implementation NLMainMenuController
{
    PaperFoldView *_paperFoldView;
}


- (id)init
{
    self = [super initWithNibName:@"NLMainMenuController" bundle:nil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _paperFoldView = [[PaperFoldView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self.view bounds].size.height)];
    [self.view addSubview:_paperFoldView];
    [_paperFoldView setLeftFoldContentView:self.menuView foldCount:1 pullFactor:0.9];
    [_paperFoldView setCenterContentView:self.childView];
    [_paperFoldView setPaperFoldState:PaperFoldStateLeftUnfolded];
}


- (IBAction)unfoldItem:(id)sender
{
    [_paperFoldView setPaperFoldState:PaperFoldStateDefault];
}

@end
