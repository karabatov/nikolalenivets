//
//  NLModelsSpecs.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSpecHelper.h"
#import "NLModel.h"

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

SpecEnd