//
//  NLNavigationBar.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 19.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;

typedef enum : NSUInteger {
    NLNavigationBarStyleNoCounter = 0,
    NLNavigationBarStyleCounter,
    NLNavigationBarStyleBackLightNoMenu,
    NLNavigationBarStyleBackLightMenu,
    NLNavigationBarStyleBackDark
} NLNavigationBarStyle;

/**
 Custom navigation bar for all views.
 */
@interface NLNavigationBar : UINavigationBar

/**
 Set screen-specific style of the navigation bar.
 */
@property (nonatomic) NLNavigationBarStyle navigationBarStyle;

/**
 Value of the counter below title.
 */
@property (nonatomic) NSUInteger counter;

@end
