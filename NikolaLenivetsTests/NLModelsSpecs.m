//
//  NLModelsSpecs.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSpecHelper.h"
#import "NLModel.h"

#import "NLTeaser.h"
#import "NLScreen.h"
#import "NLNewsEntry.h"
#import "NLPlace.h"
#import "NLEvent.h"
#import "NLDiffIndex.h"


NSArray *missingFields(Class klass, NSArray *fields) {
    id obj = [klass new];
    return _.array(fields).filter(^(NSString *field) {
        return (BOOL)![obj respondsToSelector:NSSelectorFromString(field)];
    })
    .unwrap;
}

SpecBegin(NLModelSpec)


describe(@"structure", ^{
    
    it(@"should have id field", ^{
        NLModel *m = [NLModel new];
        expect([m respondsToSelector:@selector(id)]).to.beTruthy();
    });
    
    it(@"should be able to deserialize itself", ^{
        NSDictionary *dummyModelDict = @{@"id": @(42)};
        NLModel *dummyModel = [NLModel modelFromDictionary:dummyModelDict];
        expect(dummyModel.id).to.equal(@42);
    });
});


describe(@"models specification", ^{
    
    it (@"should have it all", ^{
        NSArray *modelClasses = @[@"NLTeaser", @"NLNewsEntry", @"NLDiffIndex", @"NLPlace", @"NLScreen", @"NLEvent"];
        for (NSString *classString in modelClasses) {
            expect(NSClassFromString(classString)).toNot.beNil();
        };
    });
    
    it (@"should have properly structed NLDiffIndex model", ^{
        NSArray *properties = @[@"news", @"teasers", @"places", @"events", @"screens"];
        expect(missingFields([NLDiffIndex class], properties)).to.equal(@[]);
    });
    
    it (@"should have properly structed NLTeaser model", ^{
        NSArray *properties = @[@"id", @"order", @"pubdate", @"content", @"news", @"event", @"place"];
        expect(missingFields([NLTeaser class], properties)).to.equal(@[]);
    });
    
    it (@"should have properly structed NLScreen model", ^{
        NSArray *properties = @[@"id", @"name", @"fullname", @"image", @"url"];
        expect(missingFields([NLScreen class], properties)).to.equal(@[]);
    });

    it (@"should have properly structed NLPlace model", ^{
        NSArray *properties = @[@"id", @"title", @"content", @"categories", @"thumbnail",
                                @"geo", @"foursquare", @"instagram", @"images"];
        expect(missingFields([NLPlace class], properties)).to.equal(@[]);
    });
    
    it (@"should have properly structed NLNewsEntry model", ^{
        NSArray *properties = @[@"id", @"title", @"content", @"pubdate", @"images"];
        expect(missingFields([NLNewsEntry class], properties)).to.equal(@[]);
    });

    it (@"should have properly structed NLEvent model", ^{
        NSArray *properties = @[@"id", @"startdate", @"thumbnail", @"title", @"categories",
                                @"summary", @"content", @"place", @"facebook", @"foursquare",
                                @"instagram", @"images"];
        expect(missingFields([NLEvent class], properties)).to.equal(@[]);
    });
});

SpecEnd