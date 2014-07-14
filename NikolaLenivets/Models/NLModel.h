//
//  NLModel.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 03.04.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCKeyValueObjectMapping.h"

/**
 Item status: new (added or modified in last update), unread or read.
 */
typedef enum : NSUInteger {
    NLItemStatusNew = 0,
    NLItemStatusUnread = 1,
    NLItemStatusRead = 2
} NLItemStatus;

@interface NLModel : NSObject <NSSecureCoding>

@property (strong, nonatomic) NSNumber *id;

+ (id)modelFromDictionary:(NSDictionary *)dict;

@end
