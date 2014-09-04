//
//  NLMenuButton.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 03.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLMenuButton.h"
#import "NSAttributedString+Kerning.h"

@interface NLMenuButton ()

/**
 Top black bar.
 */
@property (strong, nonatomic) UIView *topBar;

/**
 Label with the button title.
 */
@property (strong, nonatomic) UILabel *buttonTitle;

/**
 Color splash on the background, shown when the button is pressed.
 */
@property (strong, nonatomic) UIImageView *colorSplash;

@end

@implementation NLMenuButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setClipsToBounds:NO];

    UIColor *textColor = [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f];

    self.topBar = [[UIView alloc] init];
    [self.topBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.topBar setBackgroundColor:textColor];

    self.buttonTitle = [[UILabel alloc] init];
    [self.buttonTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonTitle setTextColor:textColor];

    [self addSubview:self.topBar];
    [self addSubview:self.buttonTitle];

    NSDictionary *views = @{ @"bar": self.topBar, @"title": self.buttonTitle };
    NSDictionary *metrics = @{ @"barHeight": @4, @"titleTop": @16, @"margin": @1 };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bar]|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-1)-[title]-(>=margin)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bar(barHeight)]-titleTop-[title]-(>=margin)-|" options:kNilOptions metrics:metrics views:views]];

     // TODO: Static UIImage on self.colorSplash.
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.buttonTitle.attributedText = [NSAttributedString kernedStringForString:_title withFontSize:18 kerning:2.2f andColor:[UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f]];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.alpha = 0.5f;
        if (self.counter) {
            self.counter.alpha = 0.5f;
        }
    } else {
        self.alpha = 1.f;
        if (self.colorSplash) {
            [self.colorSplash setHidden:YES];
            self.colorSplash = nil;
        }
        if (self.counter) {
            self.counter.alpha = 1.f;
        }
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.colorSplash) {
        self.colorSplash = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 113.f, 113.f)];
        [self.colorSplash setHidden:YES];
        [self.colorSplash setImage:[UIImage imageNamed:@"menu-circle-green.png"]];
        [self addSubview:self.colorSplash];
        [self sendSubviewToBack:self.colorSplash];
    }

    [self.colorSplash setCenter:[touch locationInView:self]];
    [self.colorSplash setHidden:NO];

    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint loc = [touch locationInView:self];
    if (self.colorSplash && loc.x >= 0 && loc.x <= self.frame.size.width && loc.y >= 0 && loc.y <= self.frame.size.height) {
        [self.colorSplash setCenter:loc];
    }
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.colorSplash) {
        [self.colorSplash setHidden:YES];
        self.colorSplash = nil;
    }
}

@end
