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

/** Navigation bar view. */
@property (strong, nonatomic) UIView *navBarView;

/** Title of the view in the navigation bar. */
@property (strong, nonatomic) UILabel *navTitleLabel;

/** Menu button. */
@property (strong, nonatomic) UIButton *menuButton;

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"РАЗРАБОТЧИК";

    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.navBarView = [[UIView alloc] init];
    [self.navBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.navBarView setBackgroundColor:[UIColor colorWithRed:246.f/255.f green:246.f/255.f blue:246.f/255.f alpha:1.f]];

    UIView *dash0 = [[UIView alloc] init];
    [dash0 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash0 setBackgroundColor:[UIColor colorWithRed:172.f/255.f green:172.f/255.f blue:172.f/255.f alpha:1.f]];

    self.navTitleLabel = [[UILabel alloc] init];
    [self.navTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.navTitleLabel.attributedText = [NSAttributedString kernedStringForString:[self.title uppercaseString] withFontSize:18 kerning:2.2f andColor:[UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f]];

    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.menuButton setImage:[UIImage imageNamed:@"menu_button.png"] forState:UIControlStateNormal];
    [self.menuButton setContentEdgeInsets:UIEdgeInsetsMake(16, 3, 16, 3)];
    [self.menuButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

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

    NSString *versionText = [NSString stringWithFormat:@"Nikola Lenivets iOS App ver. %@\nТехническая поддержка — support@golovamedia.ru", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    self.versionLabel = [[UILabel alloc] init];
    [self.versionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.versionLabel setNumberOfLines:0];
    [self.versionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.versionLabel setAttributedText:[NSAttributedString kernedStringForString:versionText withFontName:NLMonospacedBoldFont fontSize:12.f kerning:.2f andColor:textColor]];
    [self.versionLabel setUserInteractionEnabled:YES];

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(versionLabelTapped:)];
    [self.versionLabel addGestureRecognizer:tap2];

    [self.navBarView addSubview:dash0];
    [self.navBarView addSubview:self.navTitleLabel];
    [self.navBarView addSubview:self.menuButton];

    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.gmTitle];
    [self.view addSubview:self.mainText];
    [self.view addSubview:self.gmLogo];
    [self.view addSubview:self.versionLabel];

    NSDictionary *views = @{ @"navB": self.navBarView,
                             @"navT": self.navTitleLabel,
                             @"dash0": dash0,
                             @"menuBtn": self.menuButton,
                             @"title": self.gmTitle,
                             @"text": self.mainText,
                             @"logo": self.gmLogo,
                             @"version": self.versionLabel };
    NSDictionary *metrics = @{ @"navV": @52, @"dashV": @0.5, @"marginH": @16, @"marginV": @23, @"imgMargin": @46, @"imgH": @172.5, @"imgV": @70 };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navB]|" options:kNilOptions metrics:metrics views:views]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[menuBtn(44)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash0]|" options:kNilOptions metrics:nil views:views]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[menuBtn(44)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=1)-[dash0(dashV)]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-marginH-[title]-(>=marginH)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-marginH-[text]-(>=marginH)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[logo(imgH)]-(>=1)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-marginH-[version]-(>=marginH)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navB(navV)]-marginV-[title]-marginV-[text]-imgMargin-[logo(imgV)]-(>=marginV)-[version]-marginV-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gmLogo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self.navBarView addConstraint:[NSLayoutConstraint constraintWithItem:self.navTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.navBarView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-2.f]];
    [self.navBarView addConstraint:[NSLayoutConstraint constraintWithItem:self.navTitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.navBarView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:7.f]];

}

- (void)versionLabelTapped:(UITapGestureRecognizer *)gesture
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@golovamedia.ru"]];
}

- (void)gmLogoTapped:(UITapGestureRecognizer *)gesture
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://golovamedia.ru"]];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
