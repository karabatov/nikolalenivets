//
//  NLNavigationBar.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 19.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLNavigationBar.h"
#import "NSAttributedString+Kerning.h"

/** Largest navbar size. */
#define kNLNavBarHeightExtended 64.f
/** Smallest navbar size. */
#define kNLNavBarHeightCompressed 52.f

@implementation NLNavigationBar

- (CGSize)sizeThatFits:(CGSize)size
{
    switch (self.navigationBarStyle) {
        case NLNavigationBarStyleNoCounter:
            return CGSizeMake(self.superview.frame.size.width, kNLNavBarHeightCompressed);
        default:
            return CGSizeMake(self.superview.frame.size.width, kNLNavBarHeightExtended);
            break;
    }
    
}

- (void)setNavigationBarStyle:(NLNavigationBarStyle)navigationBarStyle
{
    _navigationBarStyle = navigationBarStyle;
    [self setBackgroundColor:[UIColor colorWithRed:246.f/255.f green:246.f/255.f blue:246.f/255.f alpha:1.f]];
}

@end
