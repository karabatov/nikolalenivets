//
//  NLStorage.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLStorage.h"
#import "Underscore.h"
#import "AFNetworking.h"
#import "NLCategory.h"

/** Key for cached server response. */
#define CACHED_JSON @"CACHED_JSON"

/** Key for caching the model itself. */
#define CACHED_MODEL @"CACHED_MODEL"

@implementation NLStorage
{
    dispatch_queue_t _serialQ;
}

+ (NLStorage *)sharedInstance
{
    static NLStorage *_sharedStorage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:CACHED_MODEL];
        if (data) {
            _sharedStorage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } else {
            _sharedStorage = [self new];
        }
    });
    return _sharedStorage;
}


- (void)update
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Check if there are big pictures in the model. If no, redownload without crashing.
    // TODO: Remove check in next release.
    BOOL hasBigPictures = NO;
    if ([_places firstObject]) {
        NLPlace *testPlace = (NLPlace *)[_places firstObject];
        if (testPlace.picture && ![testPlace.picture isEqualToString:@""]) {
            hasBigPictures = YES;
        }
    }
    // If there's lastDownloadDate, get `/timestamp/`. Otherwise, get `/`.
    if (!_lastDownloadDate || !hasBigPictures) {
        [manager GET:BACKEND_URL
          parameters:nil
             success:^(AFHTTPRequestOperation *op, id response) {
                 [self populateWithDictionary:response];
                 _lastDownloadDate = [NSDate date];
                 [defaults setObject:response forKey:CACHED_JSON];
                 [self archive];
                 [[NSNotificationCenter defaultCenter] postNotificationName:STORAGE_DID_UPDATE object:self];
             }
             failure:^(AFHTTPRequestOperation *op, NSError *error) {
                 NSLog(@"Error: %@", error);
                 [defaults synchronize];
                 // Where does it come from if we have never loaded? Useful only if unarchive failed.
                 NSDictionary *cachedJSON = [defaults objectForKey:CACHED_JSON];
                 [self populateWithDictionary:cachedJSON];
                 [self archive];
                 [[NSNotificationCenter defaultCenter] postNotificationName:STORAGE_DID_UPDATE object:self];
             }];
    } else {
        NSTimeInterval timestamp = [_lastDownloadDate timeIntervalSince1970];
        [manager GET:[NSString stringWithFormat:@"%@%.0f/", BACKEND_URL, timestamp]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [self updateWithDictionary:responseObject];
                 _lastDownloadDate = [NSDate date];
                 [self archive];
                 [[NSNotificationCenter defaultCenter] postNotificationName:STORAGE_DID_UPDATE object:self];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
                 [[NSNotificationCenter defaultCenter] postNotificationName:STORAGE_DID_UPDATE object:self];
             }];
    }
}


- (void)updateWithDictionary:(NSDictionary *)jsonDictionary
{
    _index = [NLDiffIndex modelFromDictionary:jsonDictionary[@"index"]];

    // For each item in each _array (existing items w/out new items)
    // 1. Search index skel array for item with same id
    // 2. If no item with same id found, delete existing item
    // 3. If item with same id found, do nothing

    _.array(_news)
        .each(^(NLNewsEntry *entry) {
            NLModel *indexItem = _.find(_index.news, ^BOOL (NLModel *item) {
                return [item.id isEqualToNumber:entry.id];
            });
            if (!indexItem) {
                [_news removeObject:entry];
            } else {
                if (entry.itemStatus == NLItemStatusNew) {
                    entry.itemStatus = NLItemStatusUnread;
                }
            }
        });

    _.array(_places)
        .each(^(NLPlace *entry) {
            NLModel *indexItem = _.find(_index.places, ^BOOL (NLModel *item) {
                return [item.id isEqualToNumber:entry.id];
            });
            if (!indexItem) {
                [_places removeObject:entry];
            } else {
                if (entry.itemStatus == NLItemStatusNew) {
                    entry.itemStatus = NLItemStatusUnread;
                }
            }
        });

    _.array(_teasers)
        .each(^(NLTeaser *entry) {
            NLModel *indexItem = _.find(_index.teasers, ^BOOL (NLModel *item) {
                return [item.id isEqualToNumber:entry.id];
            });
            if (!indexItem) {
                [_teasers removeObject:entry];
            }
        });

    _.array(_eventGroups)
        .each(^(NLEventGroup *group) {
            group.events = [NSMutableArray arrayWithArray:_.array(group.events)
                .reject(^BOOL (NLEvent *entry) {
                    NLModel *indexItem = _.find(_index.events, ^BOOL (NLModel *item) {
                        return [item.id isEqualToNumber:entry.id];
                    });
                    return indexItem ? NO : YES;
                }).unwrap];
        });

    _.array(_screens)
        .each(^(NLScreen *entry) {
            NLModel *indexItem = _.find(_index.screens, ^BOOL (NLModel *item) {
                return [item.id isEqualToNumber:entry.id];
            });
            if (!indexItem) {
                [_screens removeObject:entry];
            }
        });

    _.array(_galleries)
        .each(^(NLGallery *entry) {
            NLModel *indexItem = _.find(_index.galleries, ^BOOL (NLModel *item) {
                return [item.id isEqualToNumber:entry.id];
            });
            if (!indexItem) {
                [_galleries removeObject:entry];
            }
        });

    // For each item in each index side array (actual new items):
    // 1. Search existing array for item with same id
    // 2. If no item with same id found, add item to array
    // 3. If item with same id found, replace old item with new item

    _.array(jsonDictionary[@"news"])
        .map(^(NSDictionary *d) {
            return [NLNewsEntry modelFromDictionary:d];
        })
        .each(^(NLNewsEntry *entry) {
            NLNewsEntry *oldNews = _.find(_news, ^BOOL (NLNewsEntry *item) {
                return [item.id isEqualToNumber:entry.id];
            });
            if (oldNews) {
                NSUInteger newsIndex = _.indexOf(_news, oldNews);
                [_news replaceObjectAtIndex:newsIndex withObject:entry];
            } else {
                [_news addObject:entry];
            }
        });

    _.array(jsonDictionary[@"places"])
        .map(^(NSDictionary *d) {
            return [NLPlace modelFromDictionary:d];
        })
        .each(^(NLPlace *entry) {
            NLPlace *oldPlace = _.find(_places, ^BOOL (NLPlace *item) {
                return [item.id isEqualToNumber:entry.id];
            });
            if (oldPlace) {
                NSUInteger placeIndex = _.indexOf(_places, oldPlace);
                [_places replaceObjectAtIndex:placeIndex withObject:entry];
            } else {
                [_places addObject:entry];
            }
        });

    _.array(jsonDictionary[@"teasers"])
        .map(^(NSDictionary *d) {
            return [NLTeaser modelFromDictionary:d];
        })
        .each(^(NLTeaser *entry) {
            NLTeaser *oldTeaser = _.find(_teasers, ^BOOL (NLTeaser *item) {
                return [item.id isEqualToNumber:entry.id];
            });
            if (oldTeaser) {
                NSUInteger teaserIndex = _.indexOf(_teasers, oldTeaser);
                [_teasers replaceObjectAtIndex:teaserIndex withObject:entry];
            } else {
                [_teasers addObject:entry];
            }
        });

    _.array(jsonDictionary[@"eventgroups"])
        .map(^(NSDictionary *d) {
            return [NLEventGroup modelFromDictionary:d];
        })
        .each(^(NLEventGroup *entry) {
            NLEventGroup *oldEventGroup = _.find(_eventGroups, ^BOOL (NLEventGroup *item) {
                return [item.id isEqualToNumber:entry.id];
            });
            if (oldEventGroup) {
                NSUInteger eventGroupIndex = _.indexOf(_eventGroups, oldEventGroup);
                [_eventGroups replaceObjectAtIndex:eventGroupIndex withObject:entry];
            } else {
                [_eventGroups addObject:entry];
            }
        });

    _.array(jsonDictionary[@"screens"])
        .map(^(NSDictionary *d) {
            return [NLScreen modelFromDictionary:d];
        })
        .each(^(NLScreen *entry) {
            NLScreen *oldScreen = _.find(_screens, ^BOOL (NLScreen *item) {
                return [item.id isEqualToNumber:entry.id];
            });
            if (oldScreen) {
                NSUInteger screenIndex = _.indexOf(_screens, oldScreen);
                [_screens replaceObjectAtIndex:screenIndex withObject:entry];
            } else {
                [_screens addObject:entry];
            }
        });

    _.array(jsonDictionary[@"galleries"])
        .map(^(NSDictionary *d) {
            return [NLGallery modelFromDictionary:d];
        })
        .each(^(NLGallery *entry) {
            NLGallery *oldGallery = _.find(_galleries, ^BOOL (NLGallery *item) {
                return [item.id isEqualToNumber:entry.id];
            });
            if (oldGallery) {
                NSUInteger galleryIndex = _.indexOf(_galleries, oldGallery);
                [_galleries replaceObjectAtIndex:galleryIndex withObject:entry];
            } else {
                [_galleries addObject:entry];
            }
        });

    _categories = [self categoriesFromPlaces];

    NSLog(@"Parsing of diff finished.");
}


- (void)populateWithDictionary:(NSDictionary *)jsonDictionary
{
    _index = [NLDiffIndex modelFromDictionary:jsonDictionary[@"index"]];
    
    _news = [NSMutableArray arrayWithArray:_.arrayMap(jsonDictionary[@"news"], ^(NSDictionary *d) {
        return [NLNewsEntry modelFromDictionary:d];
    })];
    
    _places = [NSMutableArray arrayWithArray:_.arrayMap(jsonDictionary[@"places"], ^(NSDictionary *d) {
        return [NLPlace modelFromDictionary:d];
    })];

    _teasers = [NSMutableArray arrayWithArray:_.arrayMap(jsonDictionary[@"teasers"], ^(NSDictionary *d) {
        return [NLTeaser modelFromDictionary:d];
    })];

    _eventGroups = [NSMutableArray arrayWithArray:_.arrayMap(jsonDictionary[@"eventgroups"], ^(NSDictionary *d) {
        return [NLEventGroup modelFromDictionary:d];
    })];
    
    _screens = [NSMutableArray arrayWithArray:_.arrayMap(jsonDictionary[@"screens"], ^(NSDictionary *d) {
        return [NLScreen modelFromDictionary:d];
    })];

    _galleries = [NSMutableArray arrayWithArray:_.arrayMap(jsonDictionary[@"galleries"], ^(NSDictionary *d) {
        return [NLGallery modelFromDictionary:d];
    })];

    _categories = [self categoriesFromPlaces];

    NSLog(@"Parsing finished.");
}


- (void)archive
{
    NSData *cachedModel = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:cachedModel forKey:CACHED_MODEL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Model archived.");
}


- (NSUInteger)unreadCountInArray:(NSArray *)array
{
    NSUInteger count = 0;
    NLItemStatus status = NLItemStatusRead;
    for (id item in array) {
        if ([item class] == [NLNewsEntry class]) {
            status = ((NLNewsEntry *)item).itemStatus;
            if (status == NLItemStatusNew || status == NLItemStatusUnread) {
                count++;
            }
        } else if ([item class] == [NLEventGroup class]) {
            for (NLEvent *event in ((NLEventGroup *)item).events) {
                if (event.itemStatus == NLItemStatusNew || event.itemStatus == NLItemStatusUnread) {
                    count++;
                }
            }
        } else if ([item class] == [NLPlace class]) {
            status = ((NLPlace *)item).itemStatus;
            if (status == NLItemStatusNew || status == NLItemStatusUnread) {
                count++;
            }
        } else if ([item class] == [NLEvent class]) {
            status = ((NLEvent *)item).itemStatus;
            if (status == NLItemStatusNew || status == NLItemStatusUnread) {
                count++;
            }
        }
    }
    return count;
}


- (NSArray *)categoriesFromPlaces
{
    NSArray *categories = _.array(_places)
        .map(^(NLPlace *place){
            return place.categories;
        })
        .flatten
        .uniq
        .unwrap;

    return categories;
}


- (void)startSearchWithPhrase:(NSString *)phrase
{
    if (phrase) {
        NSArray *searchTerms = [phrase componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (!_serialQ) {
            _serialQ = dispatch_queue_create("com.nikolalenivets.NLStorage_serialQ", DISPATCH_QUEUE_SERIAL);
        }
        dispatch_async(_serialQ, ^{
            NSArray *searchedNews = _.array(_news).filter(^BOOL (NLNewsEntry *entry) {
                for (NSString *substr in searchTerms) {
                    if ([entry.title rangeOfString:substr options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        return YES;
                    }
                    if ([entry.content rangeOfString:substr options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        return YES;
                    }
                }
                return NO;
            }).unwrap;
            NSArray *searchedPlaces = _.array(_places).filter(^BOOL (NLPlace *place) {
                for (NSString *substr in searchTerms) {
                    if ([place.title rangeOfString:substr options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        return YES;
                    }
                    if ([place.content rangeOfString:substr options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        return YES;
                    }
                }
                return NO;
            }).unwrap;
            NSMutableArray *searchedEvents = [[NSMutableArray alloc] init];
            _.array(_eventGroups).each(^(NLEventGroup *eventGroup) {
                [searchedEvents addObjectsFromArray:_.array(eventGroup.events).filter(^BOOL (NLEvent *event) {
                for (NSString *substr in searchTerms) {
                    if ([event.title rangeOfString:substr options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        return YES;
                    }
                    if ([event.content rangeOfString:substr options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        return YES;
                    }
                }
                return NO;
            }).unwrap];
            });
            _searchPhrase = phrase;
            _searchResultNews = searchedNews;
            _searchResultPlaces = searchedPlaces;
            _searchResultEvents = [NSArray arrayWithArray:searchedEvents];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_COMPLETE object:nil];
            });
        });
    }
}


#pragma mark - Secure Coding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_lastDownloadDate forKey:@"lastDownloadDate"];
    [coder encodeObject:_index forKey:@"index"];
    [coder encodeObject:_news forKey:@"news"];
    [coder encodeObject:_places forKey:@"places"];
    [coder encodeObject:_teasers forKey:@"teasers"];
    [coder encodeObject:_eventGroups forKey:@"eventGroups"];
    [coder encodeObject:_screens forKey:@"screens"];
    [coder encodeObject:_galleries forKey:@"galleries"];
    [coder encodeObject:_categories forKey:@"categories"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _lastDownloadDate = [coder decodeObjectOfClass:[NSDate class] forKey:@"lastDownloadDate"];
        _index = [coder decodeObjectOfClass:[NLDiffIndex class] forKey:@"index"];
        _news = [coder decodeObjectOfClass:[NSMutableArray class] forKey:@"news"];
        _places = [coder decodeObjectOfClass:[NSMutableArray class] forKey:@"places"];
        _teasers = [coder decodeObjectOfClass:[NSMutableArray class] forKey:@"teasers"];
        _eventGroups = [coder decodeObjectOfClass:[NSMutableArray class] forKey:@"eventGroups"];
        _screens = [coder decodeObjectOfClass:[NSMutableArray class] forKey:@"screens"];
        _galleries = [coder decodeObjectOfClass:[NSMutableArray class] forKey:@"galleries"];
        _categories = [coder decodeObjectOfClass:[NSMutableArray class] forKey:@"categories"];
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}


@end
