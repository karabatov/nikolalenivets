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

/** Key for cached server response. */
#define CACHED_JSON @"CACHED_JSON"

/** Key for caching the model itself. */
#define CACHED_MODEL @"CACHED_MODEL"

@implementation NLStorage

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

    // If there's lastDownloadDate, get `/timestamp/`. Otherwise, get `/`.
    if (!_lastDownloadDate) {
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

    // For each item in each _array (existing items w/ new items)
    // 1. Search index skel array for item with same id
    // 2. If no item with same id found, delete existing item
    // 3. If item with same id found, do nothing

    _.array(_news)
    .each(^(NLNewsEntry *entry) {
        NLModel *indexItem = _.find(_index.news, ^BOOL (NLModel *item) {
            return item.id == entry.id;
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
            return item.id == entry.id;
        });
        if (!indexItem) {
            [_places removeObject:entry];
        }
    });

    _.array(_teasers)
    .each(^(NLTeaser *entry) {
        NLModel *indexItem = _.find(_index.teasers, ^BOOL (NLModel *item) {
            return item.id == entry.id;
        });
        if (!indexItem) {
            [_teasers removeObject:entry];
        }
    });

    _.array(_eventGroups)
    .each(^(NLEventGroup *group) {
        _.array(group.events)
        .each(^(NLEvent *entry) {
            NLModel *indexItem = _.find(_index.events, ^BOOL (NLModel *item) {
                return item.id == entry.id;
            });
            if (!indexItem) {
                [group.events removeObject:entry];
            }
        });
    });

    _.array(_screens)
    .each(^(NLScreen *entry) {
        NLModel *indexItem = _.find(_index.screens, ^BOOL (NLModel *item) {
            return item.id == entry.id;
        });
        if (!indexItem) {
            [_screens removeObject:entry];
        }
    });

    _.array(_galleries)
    .each(^(NLGallery *entry) {
        NLModel *indexItem = _.find(_index.galleries, ^BOOL (NLModel *item) {
            return item.id == entry.id;
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
                return item.id == entry.id;
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
                return item.id == entry.id;
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
                return item.id == entry.id;
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
                return item.id == entry.id;
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
                return item.id == entry.id;
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
                return item.id == entry.id;
            });
            if (oldGallery) {
                NSUInteger galleryIndex = _.indexOf(_galleries, oldGallery);
                [_galleries replaceObjectAtIndex:galleryIndex withObject:entry];
            } else {
                [_galleries addObject:entry];
            }
        });
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

    NSLog(@"Parsing finished");
}


- (void)archive
{
    NSData *cachedModel = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:cachedModel forKey:CACHED_MODEL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Model archived.");
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
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}


@end
