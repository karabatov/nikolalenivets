//
//  NLStorage.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import Foundation;
#import "NLDiffIndex.h"

#import "NLNewsEntry.h"
#import "NLTeaser.h"
#import "NLScreen.h"
#import "NLEvent.h"
#import "NLPlace.h"
#import "NLEventGroup.h"
#import "NLGallery.h"

/**
 NSNotification name for notifying that there was an update to shared storage.
 */
#define STORAGE_DID_UPDATE @"STORAGE_DID_UPDATE"

/**
 Stores model state and updates when getting diff from server.
 
 Conforms to <NSCoding> for suspending to disk.
 */
@interface NLStorage : NSObject <NSSecureCoding>

/** Diff object. */
@property (strong, nonatomic, readonly) NLDiffIndex *index;

/** News array. */
@property (strong, nonatomic, readonly) NSMutableArray *news;

/** Places array. */
@property (strong, nonatomic, readonly) NSMutableArray *places;

/** Teasers array. */
@property (strong, nonatomic, readonly) NSMutableArray *teasers;

/** Event groups array. */
@property (strong, nonatomic, readonly) NSMutableArray *eventGroups;

/** Screens array. */
@property (strong, nonatomic, readonly) NSMutableArray *screens;

/** Galleries array. */
@property (strong, nonatomic, readonly) NSMutableArray *galleries;

/** Last download date */
@property (strong, nonatomic, readonly) NSDate *lastDownloadDate;

/**
 Singleton storage.
 
 @return Shared NLStorage instance.
 */
+ (NLStorage *)sharedInstance;

/**
 Get new data from backend.
 */
- (void)update;

/**
 Set initial model values from JSON dictionary.
 */
- (void)populateWithDictionary:(NSDictionary *)jsonDictionary;

@end
