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
}

- (id)initWithGallery:(NLGallery *)gallery
{
    self = [super initWithNibName:@"NLGalleryViewController" bundle:nil];
    if (self) {
        _gallery = gallery;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.galleryView.showsScrollIndicator = NO;
    self.galleryView.galleryMode = UIPhotoGalleryModeImageRemote;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateInfoForPhotoAtIndex:0];
    self.galleryView.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.galleryView.hidden = YES;
}

- (void)updateInfoForPhotoAtIndex:(NSInteger)index
{
    NLImage *image = _gallery.images[index];
    self.nameView.hidden = image.title.length == 0;
    self.descriptionLabel.hidden = image.content.length == 0;

    self.descriptionLabel.text = image.content;
    self.nameLabel.text = image.title;
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
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (IBAction)showMenu:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOW object:nil];
}


@end
