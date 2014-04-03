//
//  NLStorageSpec.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSpecHelper.h"
#import "NLStorage.h"

SpecBegin(StorageSpec)

describe(@"Storage", ^{
    
    static NLStorage *_storage;
    static NSDictionary *_testDataDict;
    
    beforeAll(^{
        _storage = [NLStorage sharedInstance];
        NSString *testDataPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test-data" ofType:@"json"];
        NSError *error = nil;
        NSData *testData = [NSData dataWithContentsOfFile:testDataPath];
        _testDataDict = [NSJSONSerialization JSONObjectWithData:testData options:NSJSONReadingAllowFragments error:&error];
    });
    
    it(@"should be. Just be", ^{
        expect(NSClassFromString(@"NLStorage")).toNot.beNil();
    });
    
    it(@"should be singleton", ^{
        NLStorage *storage = [NLStorage sharedInstance];
        expect(storage).toNot.beNil();
        
        NLStorage *anotherOneStorage = [NLStorage sharedInstance];
        expect(anotherOneStorage).to.beIdenticalTo(storage);
    });
    
    it(@"should have same structure as backend-given JSON object", ^{
        expect([_storage respondsToSelector:@selector(index)]).to.beTruthy();
        expect([_storage respondsToSelector:@selector(places)]).to.beTruthy();
        expect([_storage respondsToSelector:@selector(teasers)]).to.beTruthy();
        expect([_storage respondsToSelector:@selector(screens)]).to.beTruthy();
        expect([_storage respondsToSelector:@selector(news)]).to.beTruthy();
        expect([_storage respondsToSelector:@selector(events)]).to.beTruthy();
    });
    
    it(@"should be able to fill himself with meaningful data from given JSON", ^{
        expect([_storage respondsToSelector:@selector(populateWithDictionary:)]).to.beTruthy();
        [_storage populateWithDictionary:_testDataDict];
        expect(_storage.events.count).to.beGreaterThan(0);
        expect(_storage.news.count).to.beGreaterThan(0);
        expect(_storage.teasers.count).to.beGreaterThan(0);
        expect(_storage.places.count).to.beGreaterThan(0);
        expect(_storage.screens.count).to.beGreaterThan(0);
    });
});

SpecEnd