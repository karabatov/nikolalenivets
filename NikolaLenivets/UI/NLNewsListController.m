//
//  NLNewsListController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 24.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLNewsListController.h"
#import "NLMainMenuController.h"


@implementation NLNewsListController

- (id)init
{
    self = [super initWithNibName:@"NLNewsListController" bundle:nil];
    if (self) {
    }
    return self;
}


- (IBAction)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOW object:nil];
}

@end
