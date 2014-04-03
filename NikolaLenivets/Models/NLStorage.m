//
//  NLStorage.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLStorage.h"
#import "Underscore.h"


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


- (void)populateWithDictionary:(NSDictionary *)jsonDictionary
{
    _index = [NLDiffIndex modelFromDictionary:jsonDictionary[@"index"]];
    
    _news = _.array(jsonDictionary[@"news"]).map(^(NSDictionary *d) {
        return [NLNewsEntry modelFromDictionary:d];
    }).unwrap;
    
    _places = _.array(jsonDictionary[@"places"]).map(^(NSDictionary *d) {
        return [NLPlace modelFromDictionary:d];
    }).unwrap;

    _teasers = _.array(jsonDictionary[@"teasers"]).map(^(NSDictionary *d) {
        return [NLTeaser modelFromDictionary:d];
    }).unwrap;

    _events = _.array(jsonDictionary[@"events"]).map(^(NSDictionary *d) {
        return [NLEvent modelFromDictionary:d];
    }).unwrap;
    
    _screens = _.array(jsonDictionary[@"screens"]).map(^(NSDictionary *d) {
        return [NLScreen modelFromDictionary:d];
    }).unwrap;
}

@end
