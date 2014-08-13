//
//  NLGalleryViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLGalleryViewController.h"
#import "NLMainMenuController.h"

@implementation NLGalleryViewController
{
    __strong NLGallery *_gallery;
    __strong NSString *_backTitle;
}

- (id)initWithGallery:(NLGallery *)gallery andTitle:(NSString *)title
{
    self = [super initWithNibName:@"NLGalleryViewController" bundle:nil];
    if (self) {
        _gallery = gallery;
        _backTitle = [title uppercaseString];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    self.galleryView.showsScrollIndicator = NO;
    self.galleryView.galleryMode = UIPhotoGalleryModeImageRemote;

    self.backTitleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:10];
    self.nameLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:10];
    self.descriptionLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:10];
    self.currentPageLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
    self.otherPageLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];
    self.totalPagesLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:9];

    UIColor *borderColor = [UIColor colorWithRed:225.0f/255.0f green:230.0f/255.0f blue:169.0f/255.0f alpha:1.0f];
    [self.nameView.layer setBorderColor:[borderColor CGColor]];
    [self.nameView.layer setBorderWidth:1.5f];

    [self.view sendSubviewToBack:self.galleryView];

    self.backTitleLabel.text = _backTitle;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateInfoForPhotoAtIndex:0];
    self.galleryView.hidden = NO;
    self.totalPagesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_gallery.images count]];
}

- (void)updateInfoForPhotoAtIndex:(NSInteger)index
{
    NLImage *image = _gallery.images[index];
    self.nameView.hidden = image.title.length == 0;
    self.descriptionLabel.hidden = image.content.length == 0;

    self.descriptionLabel.text = [image.content uppercaseString];
    self.nameLabel.text = [image.title uppercaseString];

    self.currentPageLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)(index + 1)];
}


#pragma mark - Gallery delegate & datasource

- (NSURL *)photoGallery:(UIPhotoGalleryView *)photoGallery remoteImageURLAtIndex:(NSInteger)index
{
    NLImage *image = _gallery.images[index];
    NSURL *url = [NSURL URLWithString:image.image];
    return url;
}


- (NSInteger)numberOfViewsInPhotoGallery:(UIPhotoGalleryView *)photoGallery
{
    return _gallery.images.count;
}


- (void)photoGallery:(UIPhotoGalleryView *)photoGallery didMoveToIndex:(NSInteger)index
{
    [self updateInfoForPhotoAtIndex:index];
}


- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)showMenu:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
