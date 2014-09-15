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
 NSNotification name for notifying that the search is complete.
 */
#define SEARCH_COMPLETE @"SEARCH_COMPLETE"

/**
 Dictionary key name for search phrase to check if search is relevant.
 */
#define SEARCH_KEY_PHRASE @"SEARCH_KEY_PHRASE"

/**
 Stores model state and updates when getting diff from server.
 
 Conforms to <NSSecureCoding> for suspending to disk.
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

/** Categories array. */
@property (strong, nonatomic, readonly) NSArray *categories;

/** Last download date. */
@property (strong, nonatomic, readonly) NSDate *lastDownloadDate;

/** Last search phrase. */
@property (strong, nonatomic, readonly) NSString *searchPhrase;

/** Search results: news. */
@property (strong, nonatomic, readonly) NSArray *searchResultNews;

/** Search results: events. */
@property (strong, nonatomic, readonly) NSDictionary *searchResultEvents;

/** Search results: places. */
@property (strong, nonatomic, readonly) NSArray *searchResultPlaces;

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

/**
 Cache current model state to disk.
 */
- (void)archive;

/**
 Number of unread items in a given array.
 
 @param array Array to search for unread items.
 @return Number of unread items.
 */
- (NSUInteger)unreadCountInArray:(NSArray *)array;

/**
 Start text search for any words in a given phrase.
 
 @param phrase String to search for.
 */
- (void)startSearchWithPhrase:(NSString *)phrase;

@end
