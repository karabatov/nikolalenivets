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

#define CACHED_JSON @"CACHED_JSON"

@implementation NLStorage

+ (NLStorage *)sharedInstance
{
    static NLStorage *_sharedStorage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStorage = [self new];
    });
    return _sharedStorage;
}

- (void)update
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:BACKEND_URL
      parameters:nil
         success:^(AFHTTPRequestOperation *op, id response) {
             [self populateWithDictionary:response];
             [[NSUserDefaults standardUserDefaults] setObject:response forKey:CACHED_JSON];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [[NSNotificationCenter defaultCenter] postNotificationName:STORAGE_DID_UPDATE object:self];
         }
         failure:^(AFHTTPRequestOperation *op, NSError *error) {
             NSLog(@"Error: %@", error);
             [[NSUserDefaults standardUserDefaults] synchronize];
             NSDictionary *cachedJSON = [[NSUserDefaults standardUserDefaults] objectForKey:CACHED_JSON];
             [self populateWithDictionary:cachedJSON];
             [[NSNotificationCenter defaultCenter] postNotificationName:STORAGE_DID_UPDATE object:self];
         }];
}


- (void)populateWithDictionary:(NSDictionary *)jsonDictionary
{
    _index = [NLDiffIndex modelFromDictionary:jsonDictionary[@"index"]];
    
    _news = _.arrayMap(jsonDictionary[@"news"], ^(NSDictionary *d) {
        return [NLNewsEntry modelFromDictionary:d];
    });
    
    _places = _.arrayMap(jsonDictionary[@"places"], ^(NSDictionary *d) {
        return [NLPlace modelFromDictionary:d];
    });

    _teasers = _.arrayMap(jsonDictionary[@"teasers"], ^(NSDictionary *d) {
        return [NLTeaser modelFromDictionary:d];
    });

    _eventGroups = _.arrayMap(jsonDictionary[@"eventgroups"], ^(NSDictionary *d) {
        return [NLEventGroup modelFromDictionary:d];
    });
    
    _screens = _.arrayMap(jsonDictionary[@"screens"], ^(NSDictionary *d) {
        return [NLScreen modelFromDictionary:d];
    });
}

@end
