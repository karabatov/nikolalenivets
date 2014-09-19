//
//  UIViewController+CustomButtons.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 19.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "UIViewController+CustomButtons.h"
#import "NSAttributedString+Kerning.h"

#define NAVBAR ((NLNavigationBar *)self.navigationController.navigationBar)
#define kNLNavBarTitleCounterSpacing 10.f

@implementation UIViewController (CustomButtons)

- (void)setupForNavBarWithStyle:(NLNavigationBarStyle)style
{
    [NAVBAR setNavigationBarStyle:style];

    CGPoint menuButtonOffset = CGPointZero;
    CGPoint titleViewOffset = CGPointZero;
    BOOL titleViewBack = NO;

    switch (style) {
        case NLNavigationBarStyleNoCounter:
            menuButtonOffset = (CGPoint){1.5, 4};
            titleViewOffset = (CGPoint){-6, 6};
            break;
        case NLNavigationBarStyleCounter:
            menuButtonOffset = (CGPoint){1.5, 16};
            titleViewOffset = (CGPoint){-6, 14};
            break;

        default:
            break;
    }

    [self.navigationItem setHidesBackButton:YES];

    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [menuButton setContentEdgeInsets:UIEdgeInsetsMake(16, 3, 16, 3)];
    [menuButton setImage:[UIImage imageNamed:@"menu_button.png"] forState:UIControlStateNormal];
    if (titleViewBack) {
        [menuButton addTarget:self action:@selector(customButtons_popToRootViewController) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [menuButton addTarget:self action:@selector(customButtons_popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *menuButtonView = [[UIView alloc] initWithFrame:menuButton.bounds];
    menuButtonView.bounds = CGRectOffset(menuButtonView.bounds, menuButtonOffset.x, menuButtonOffset.y);
    [menuButtonView addSubview:menuButton];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonView];
    self.navigationItem.leftBarButtonItem = backItem;

    UIView *titleWrapperView = nil;
    if (titleViewBack) {
        //
    } else {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.attributedText = [NSAttributedString kernedStringForString:self.title withFontSize:18 kerning:2.2f andColor:[UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f]];
        [titleLabel sizeToFit];
        if (style == NLNavigationBarStyleNoCounter) {
            titleWrapperView = [[UIView alloc] initWithFrame:titleLabel.bounds];
            [titleWrapperView addSubview:titleLabel];
        } else if (style == NLNavigationBarStyleCounter) {
            UILabel *counterLabel = [[UILabel alloc] init];
            counterLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
            counterLabel.textColor = [UIColor colorWithRed:37.0f/255.0f green:37.0f/255.0f blue:37.0f/255.0f alpha:1.0f];
            counterLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)NAVBAR.counter];
            [counterLabel sizeToFit];
            CGRect wrapFrame = CGRectMake(0, 0, MAX(titleLabel.bounds.size.width, counterLabel.bounds.size.width), titleLabel.bounds.size.height + kNLNavBarTitleCounterSpacing + counterLabel.bounds.size.height);
            titleWrapperView = [[UIView alloc] initWithFrame:wrapFrame];
            CGRect countFrame = counterLabel.bounds;
            countFrame.origin.x = wrapFrame.size.width / 2.f;
            countFrame.origin.y = titleLabel.bounds.size.height + kNLNavBarTitleCounterSpacing;
            counterLabel.frame = countFrame;
            [titleWrapperView addSubview:titleLabel];
            [titleWrapperView addSubview:counterLabel];
        }
        titleWrapperView.bounds = CGRectOffset(titleWrapperView.bounds, titleViewOffset.x, titleViewOffset.y);
    }
    self.navigationItem.titleView = titleWrapperView;
}

- (void)customButtons_popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customButtons_popToRootViewController
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
