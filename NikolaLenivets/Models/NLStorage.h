//
//  NLStorage.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLDiffIndex.h"

#import "NLNewsEntry.h"
#import "NLTeaser.h"
#import "NLScreen.h"
#import "NLEvent.h"
#import "NLPlace.h"
#import "NLEventGroup.h"

#define STORAGE_DID_UPDATE @"STORAGE_DID_UPDATE"

@interface NLStorage : NSObject

/** Diff object */
@property (strong, nonatomic, readonly) NLDiffIndex *index;

@property (strong, nonatomic, readonly) NSArray *news;
@property (strong, nonatomic, readonly) NSArray *places;
@property (strong, nonatomic, readonly) NSArray *teasers;
@property (strong, nonatomic, readonly) NSArray *eventGroups;
@property (strong, nonatomic, readonly) NSArray *screens;

+ (NLStorage *)sharedInstance;
- (void)update;
- (void)populateWithDictionary:(NSDictionary *)jsonDictionary;

@end
