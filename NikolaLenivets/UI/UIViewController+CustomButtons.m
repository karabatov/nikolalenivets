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
#define kNLNavBarTitleCounterSpacing 6.5f
#define kNLNavBarTitleBackBtnSpacing 5.5f

@implementation UIViewController (CustomButtons)

- (void)setupForNavBarWithStyle:(NLNavigationBarStyle)style
{
    [NAVBAR setNavigationBarStyle:style];

    CGPoint menuButtonOffset = CGPointZero;
    CGPoint titleViewOffset = CGPointZero;
    BOOL titleViewBack = NO;
    BOOL showsMenu = YES;

    switch (style) {
        case NLNavigationBarStyleNoCounter:
            menuButtonOffset = (CGPoint){1.5, 4};
            titleViewOffset = (CGPoint){0, 6};
            break;
        case NLNavigationBarStyleCounter:
            menuButtonOffset = (CGPoint){2, 16};
            titleViewOffset = (CGPoint){-1.5, 9.5};
            break;
        case NLNavigationBarStyleBackLightMenu:
            menuButtonOffset = (CGPoint){2, 16};
            titleViewOffset = (CGPoint){0, 6};
            titleViewBack = YES;
            break;
        case NLNavigationBarStyleBackLightNoMenu:
            menuButtonOffset = (CGPoint){2, 16};
            titleViewOffset = (CGPoint){0, 6};
            titleViewBack = YES;
            showsMenu = NO;
            break;

        default:
            break;
    }

    [self.navigationItem setHidesBackButton:YES];

    if (showsMenu) {
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
    }

    UIView *titleWrapperView = nil;
    UILabel *titleLabel = [[UILabel alloc] init];
    if (titleViewBack) {
        titleLabel.attributedText = [NSAttributedString kernedStringForString:self.title withFontSize:12 kerning:1.1f andColor:[UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f]];
        [titleLabel sizeToFit];
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [backImage setImage:[UIImage imageNamed:@"button-back-black.png"]];
        CGRect wrapFrame = CGRectMake(0, 0, MAX(titleLabel.bounds.size.width, backImage.bounds.size.width), backImage.bounds.size.height + kNLNavBarTitleBackBtnSpacing + titleLabel.bounds.size.height);
        titleWrapperView = [[UIView alloc] initWithFrame:wrapFrame];
        CGRect backBtnFrame = backImage.bounds;
        backBtnFrame.origin.x = wrapFrame.size.width / 2.f - backImage.bounds.size.width / 2.f;
        backImage.frame = backBtnFrame;
        CGRect titleFrame = titleLabel.bounds;
        titleFrame.origin.x = wrapFrame.size.width / 2.f - titleLabel.bounds.size.width / 2.f + 1.f;
        titleFrame.origin.y = backImage.bounds.size.height + kNLNavBarTitleBackBtnSpacing;
        titleLabel.frame = titleFrame;
        [titleWrapperView addSubview:backImage];
        [titleWrapperView addSubview:titleLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customButtons_popViewController)];
        [titleWrapperView addGestureRecognizer:tap];
    } else {
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
            countFrame.origin.x = wrapFrame.size.width / 2.f - countFrame.size.width / 2.f - 1.5f;
            countFrame.origin.y = titleLabel.bounds.size.height + kNLNavBarTitleCounterSpacing;
            counterLabel.frame = countFrame;
            [titleWrapperView addSubview:titleLabel];
            [titleWrapperView addSubview:counterLabel];
        }
    }
    titleWrapperView.bounds = CGRectOffset(titleWrapperView.bounds, titleViewOffset.x, titleViewOffset.y);
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
