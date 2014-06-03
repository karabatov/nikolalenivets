//
//  NLGalleryViewController.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLGalleryViewController.h"


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
    self.galleryView.showsScrollIndicator = NO;
    self.galleryView.galleryMode = UIPhotoGalleryModeImageRemote;
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

@end
