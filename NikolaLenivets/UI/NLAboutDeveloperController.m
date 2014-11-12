//
//  NLAboutDeveloperController.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 10.11.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLAboutDeveloperController.h"
#import "UIViewController+CustomButtons.h"
#import "NSAttributedString+Kerning.h"

@interface NLAboutDeveloperController ()

/** View title. */
@property (strong, nonatomic) UILabel *gmTitle;

/** Main text. */
@property (strong, nonatomic) UILabel *mainText;

/** Golova Media logo. */
@property (strong, nonatomic) UIImageView *gmLogo;

/** Version and support address label. */
@property (strong, nonatomic) UILabel *versionLabel;

@end

@implementation NLAboutDeveloperController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    UIColor *textColor = [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f];

    self.gmTitle = [[UILabel alloc] init];
    [self.gmTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.gmTitle setNumberOfLines:1];
    [self.gmTitle setAttributedText:[NSAttributedString kernedStringForString:@"Golova Media" withFontName:NLMonospacedBoldFont fontSize:16.f kerning:.2f andColor:textColor]];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 0.6f;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 0.f;
    NSMutableAttributedString *mainStr = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString kernedStringForString:@"Создаем интерес к\u00a0вашему делу, превращаем аудиторию в\u00a0ваших клиентов. С\u00a0помощью сайтов, приложений, спецпроектов и\u00a0медиа.\n\nНаши стратегии, идеи и\u00a0технологии. Ваши большие\u00a0цели." withFontName:NLSerifFont fontSize:17 kerning:.2f andColor:textColor]];
    [mainStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:(NSRange){0, [mainStr length]}];
    self.mainText = [[UILabel alloc] init];
    [self.mainText setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.mainText setNumberOfLines:0];
    [self.mainText setLineBreakMode:NSLineBreakByWordWrapping];
    [self.mainText setAttributedText:mainStr];

    self.gmLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"golova-media.png"]];
    [self.gmLogo setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.gmLogo setContentMode:UIViewContentModeCenter];
    [self.gmLogo setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gmLogoTapped:)];
    [self.gmLogo addGestureRecognizer:tap];

    NSString *versionText = [NSString stringWithFormat:@"Nikola Lenivets iOS App ver. %@\nТехническая поддержка — nl@glv.cc", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    self.versionLabel = [[UILabel alloc] init];
    [self.versionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.versionLabel setNumberOfLines:0];
    [self.versionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.versionLabel setAttributedText:[NSAttributedString kernedStringForString:versionText withFontName:NLMonospacedBoldFont fontSize:12.f kerning:.2f andColor:textColor]];
    [self.versionLabel setUserInteractionEnabled:YES];

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(versionLabelTapped:)];
    [self.versionLabel addGestureRecognizer:tap2];

    [self.view addSubview:self.gmTitle];
    [self.view addSubview:self.mainText];
    [self.view addSubview:self.gmLogo];
    [self.view addSubview:self.versionLabel];

    NSDictionary *views = @{ @"title": self.gmTitle, @"text":self.mainText, @"logo": self.gmLogo, @"version": self.versionLabel };
    NSDictionary *metrics = @{ @"marginTop": @80, @"marginH": @16, @"marginV": @23, @"imgMargin": @46, @"imgH": @172.5, @"imgV": @70 };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-marginH-[title]-(>=marginH)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-marginH-[text]-(>=marginH)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[logo(imgH)]-(>=1)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-marginH-[version]-(>=marginH)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-marginTop-[title]-marginV-[text]-imgMargin-[logo(imgV)]-(>=marginV)-[version]-marginV-|" options:kNilOptions metrics:metrics views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gmLogo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
}

- (void)versionLabelTapped:(UITapGestureRecognizer *)gesture
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:nl@glv.cc"]];
}

- (void)gmLogoTapped:(UITapGestureRecognizer *)gesture
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://golovamedia.ru"]];
}

@end
