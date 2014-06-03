//
//  NLScreen.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLModel.h"

@interface NLScreen : NLModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *fullname;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *content;

@end
