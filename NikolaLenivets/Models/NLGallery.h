//
//  NLGallery.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLModel.h"


@interface NLImage : NLModel

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSNumber *iscover;
@property (strong, nonatomic) NSNumber *order;

@end


@interface NLGallery : NLModel

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *shortcut;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray *images;

- (NLImage *)cover;

@end
