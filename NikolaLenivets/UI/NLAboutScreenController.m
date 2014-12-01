//
//  NLAboutScreenController.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 17.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLAboutScreenController.h"
#import "NLStorage.h"
#import "NSAttributedString+Kerning.h"
#import "NLAboutDeveloperController.h"

#define kNLAboutNavbarHeight 52.f

@interface NLAboutScreenController ()

/** Internal name for the screen. */
@property (strong, nonatomic) NSString *screenName;

/** Screen instance. */
@property (strong, nonatomic) NLScreen *screen;

/** Floating menu button. */
@property (strong, nonatomic) UIButton *menuButton;

/** Container view for navigation bar. */
@property (strong, nonatomic) UIView *navigationView;

/** Title of the view, goes into the navigation bar. */
@property (strong, nonatomic) UILabel *titleLabel;

/** Scroll view for keeping all the content. */
@property (strong, nonatomic) UIScrollView *mainScroll;

/** Container view to go inside the scroll view. */
@property (strong, nonatomic) UIView *containerView;

/** Large photo of the park. To be switched to video later. */
@property (strong, nonatomic) UIImageView *parkPhoto;

/** Gradient that appears above the photo when scrolling. */
@property (strong, nonatomic) UIImageView *gradientView;

/** Web view to display the actual screen content. */
@property (strong, nonatomic) UIWebView *webView;

/** Height of the park photo/video. */
@property (strong, nonatomic) NSLayoutConstraint *parkPhotoHeight;

/** Height of the web view. */
@property (strong, nonatomic) NSLayoutConstraint *webViewHeight;

/** Scroll view offset to start fading the navigation bar in. */
@property (nonatomic) CGFloat startFadeOffset;

/** Button to show the "About Developer". */
@property (strong, nonatomic) UIButton *questionButton;

@end

@implementation NLAboutScreenController

- (instancetype)initWithScreenNamed:(NSString *)screenName
{
    self = [super init];
    if (self) {
        self.screenName = screenName;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:STORAGE_DID_UPDATE object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)update
{
    NLScreen *screen = _.array([[NLStorage sharedInstance] screens]).find(^(NLScreen *s) {
        return [s.name isEqualToString:_screenName];
    });

    if (screen != nil) {
        self.titleLabel.attributedText = [NSAttributedString kernedStringForString:[screen.fullname uppercaseString] withFontSize:18 kerning:2.2f andColor:[UIColor colorWithRed:126.0f/255.0f green:126.0f/255.0f blue:126.0f/255.0f alpha:1.0f]];
        NSString *HTMLFormat = @"<html><head><style type=\"text/css\">* { margin:0 !important; padding:0 !important; -webkit-hyphens:auto !important; hyphens:auto !important; font-family:MonoCondensedCBold !important; font-size:16pt !important; line-height:30px !important; text-transform:uppercase !important; letter-spacing:0.04em } p { color:#252525 !important; } a { color:#252525 !important; background-color:#caf8d5 !important; text-decoration:none !important; }</style></head><body>%@</body></html>";
        [self.webView loadHTMLString:[NSString stringWithFormat:HTMLFormat, screen.content] baseURL:[NSURL URLWithString:@"http://"]];
    } else {
        self.titleLabel.text = @"";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.menuButton setImage:[UIImage imageNamed:@"menu_button.png"] forState:UIControlStateNormal];
    [self.menuButton setContentEdgeInsets:UIEdgeInsetsMake(16, 3, 16, 3)];
    [self.menuButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

    self.questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.questionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.questionButton setImage:[UIImage imageNamed:@"about-question.png"] forState:UIControlStateNormal];
    [self.questionButton setContentEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.questionButton addTarget:self action:@selector(openAboutDeveloperScreen) forControlEvents:UIControlEventTouchUpInside];

    UIView *dash0 = [[UIView alloc] init];
    [dash0 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash0 setBackgroundColor:[UIColor colorWithRed:172.f/255.f green:172.f/255.f blue:172.f/255.f alpha:1.f]];

    self.navigationView = [[UIView alloc] init];
    [self.navigationView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.navigationView setBackgroundColor:[UIColor colorWithRed:246.f/255.f green:246.f/255.f blue:246.f/255.f alpha:1.f]];
    self.navigationView.alpha = 0.f;

    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.mainScroll = [[UIScrollView alloc] init];
    [self.mainScroll setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.mainScroll.delegate = self;
    self.mainScroll.bounces = NO;

    self.containerView = [[UIView alloc] init];
    [self.containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.containerView setBackgroundColor:[UIColor whiteColor]];

    self.parkPhoto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about-image.jpg"]];
    [self.parkPhoto setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.parkPhoto setContentMode:UIViewContentModeScaleAspectFill];
    [self.parkPhoto setClipsToBounds:YES];

    self.gradientView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradient-green.png"]];
    [self.gradientView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.gradientView.alpha = 0.f;

    self.webView = [[UIWebView alloc] init];
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    [self.webView setDataDetectorTypes:UIDataDetectorTypeLink];

    [self.containerView addSubview:self.webView];
    [self.containerView addSubview:self.parkPhoto];
    [self.containerView addSubview:self.gradientView];

    [self.navigationView addSubview:self.titleLabel];
    [self.navigationView addSubview:dash0];

    [self.mainScroll addSubview:self.containerView];

    [self.view addSubview:self.mainScroll];
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.menuButton];
    [self.view addSubview:self.questionButton];

    NSDictionary *views = @{ @"menu": self.menuButton,
                             @"question": self.questionButton,
                             @"navi": self.navigationView,
                             @"title": self.titleLabel,
                             @"scroll": self.mainScroll,
                             @"wrap": self.containerView,
                             @"image": self.parkPhoto,
                             @"gradient": self.gradientView,
                             @"web": self.webView,
                             @"dash0": dash0 };
    NSDictionary *metrics = @{ @"navV": [NSNumber numberWithFloat:kNLAboutNavbarHeight] };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[menu(44)]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[menu(44)]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[question(44)]-1-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[question(44)]-(>=1)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navi]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash0]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=1)-[dash0(0.5)]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navi(navV)]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scroll]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[wrap]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[wrap]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[image]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[gradient]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[gradient(131)]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[web]-13-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[image]-8-[web]|" options:kNilOptions metrics:metrics views:views]];
    self.parkPhotoHeight = [NSLayoutConstraint constraintWithItem:self.parkPhoto attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:[UIScreen mainScreen].bounds.size.height - 48.5f];
    [self.view addConstraint:self.parkPhotoHeight];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:[UIScreen mainScreen].bounds.size.width]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gradientView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.parkPhoto attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f]];
    self.webViewHeight = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:0];
    [self.view addConstraint:self.webViewHeight];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.navigationView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:7.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.navigationView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-2.f]];

    self.startFadeOffset = self.parkPhotoHeight.constant - kNLAboutNavbarHeight;

    [self update];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openAboutDeveloperScreen
{
    NLAboutDeveloperController *aboutDev = [[NLAboutDeveloperController alloc] init];
    [self.navigationController pushViewController:aboutDev animated:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat jsHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    self.webViewHeight.constant = jsHeight;
    [self.view layoutIfNeeded];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= self.startFadeOffset) {
        self.navigationView.alpha = MIN(offsetY - self.startFadeOffset, kNLAboutNavbarHeight) / kNLAboutNavbarHeight;
    } else {
        self.navigationView.alpha = 0.f;
    }
    self.parkPhoto.alpha = 1.f - self.navigationView.alpha;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.15f animations:^{
        self.gradientView.alpha = 0.65f;
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [UIView animateWithDuration:0.25f animations:^{
        self.gradientView.alpha = 0.0f;
    }];
}

@end
