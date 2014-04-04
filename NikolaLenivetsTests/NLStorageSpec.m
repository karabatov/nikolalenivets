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
    
    it (@"should properly deserialize itself and all properties", ^{
        expect([_storage respondsToSelector:@selector(populateWithDictionary:)]).to.beTruthy();
        [_storage populateWithDictionary:_testDataDict];
        
        NLNewsEntry *newsEntry = _storage.news[0];
        expect(newsEntry).to.beKindOf([NLNewsEntry class]);
        expect(newsEntry.id).toNot.beNil();
        expect(newsEntry.pubdate).to.equal(@"2014-04-03 10:28:04");
        expect(newsEntry.content).toNot.beNil();
        expect(newsEntry.title).toNot.beNil();
        
        NLEvent *event = _storage.events[0];
        expect(event).to.beKindOf([NLEvent class]);
        expect(event.id).to.equal(@1);
        expect(event.categories).toNot.beNil();
        expect(event.instagram).toNot.beNil();
        expect(event.facebook).toNot.beNil();
        expect(event.foursquare).toNot.beNil();
        expect(event.images).toNot.beNil();
        expect(event.startdate).to.equal(@"2013-08-13 08:00:00");
        expect(event.title).toNot.beNil();
        expect(event.summary).toNot.beNil();
        expect(event.content).toNot.beNil();
        expect(event.place).toNot.beNil();
        
        NLScreen *screen = _storage.screens[0];
        expect(screen).to.beKindOf([NLScreen class]);
        expect(screen.url).to.equal(@"creators");
        expect(screen.fullname).toNot.beNil();
        expect(screen.id).to.equal(@1);
        expect(screen.image).toNot.beNil();
        expect(screen.name).toNot.beNil();
        
        NLTeaser *teaser = _storage.teasers[0];
        expect(teaser.pubdate).to.equal(@"2014-04-03 10:33:13");
        expect(teaser.id).to.equal(@1);
        expect(teaser.place).toNot.beNil();
        expect(teaser.news).toNot.beNil();
        expect(teaser.order).toNot.beNil();
        expect(teaser.order).toNot.beNil();
        expect(teaser.event).toNot.beNil();
        
        NLPlace *place = _storage.places[0];
        expect(place.content).toNot.beNil();
        expect(place.foursquare).toNot.beNil();
        expect(place.instagram).toNot.beNil();
        expect(place.images).toNot.beNil();
        expect(place.id).to.equal(@1);
        expect(place.geo).to.equal(@"54.4456,35.35");
        expect(place.thumbnail).toNot.beNil();
        expect(place.categories).toNot.beNil();
    });
});

SpecEnd