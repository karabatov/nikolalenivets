//
//  NLBackendSpec.m
//  NikolaLenivets
//
//  Created by Semyon Novikov on 01.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import "AFNetworking.h"

static AFHTTPRequestOperationManager *manager;

SpecBegin(BackendConnectionTest)

describe(@"Backend connection", ^{
    
    beforeAll(^{
        manager = [AFHTTPRequestOperationManager manager];
    });
    
    it(@"should have backend url", ^{
        expect(BACKEND_URL).toNot.beNil();
    });
    
    
    it(@"should be able to talk to backend", ^AsyncBlock {
        [manager HEAD:BACKEND_URL
           parameters:nil
              success:^(AFHTTPRequestOperation *op) {
                  expect(op).toNot.beNil();
                  done();
              }
              failure:^(AFHTTPRequestOperation *op, NSError *error) {
                  XCTFail(@"Can't talk to backend :(");
                  done();
              }];
    });
    
    it(@"should receive not empty JSON response from backend", ^AsyncBlock {
        [manager GET:BACKEND_URL
          parameters:nil
             success:^(AFHTTPRequestOperation *op, id response) {
                 expect(response).toNot.beNil();
                 expect(response).to.beKindOf([NSDictionary class]);
                 done();
             }
             failure:^(AFHTTPRequestOperation *op, NSError *error) {
                 XCTFail(@"Received error from backend");
                 done();
             }];
    });
    
    it(@"should receive index object from backend when timestamp is specified", ^AsyncBlock {
        [manager GET:[NSString stringWithFormat:@"%@/1049181727", BACKEND_URL]
          parameters:nil
             success:^(AFHTTPRequestOperation *op, NSDictionary *response) {
                 expect(response[@"index"]).toNot.beNil();
                 expect(response[@"index"]).to.beKindOf([NSDictionary class]);
                 expect(response[@"index"][@"events"]).to.beKindOf([NSArray class]);
                 expect([response[@"index"][@"events"] count]).to.beGreaterThan(0);
                 done();
             }
             failure:^(AFHTTPRequestOperation *op, NSError *error) {
                 XCTFail(@"Received error from backend");
                 done();
             }];
    });
});

SpecEnd
