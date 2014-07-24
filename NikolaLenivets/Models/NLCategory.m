//
//  NLCategory.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 22.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLCategory.h"

@implementation NLCategory

#pragma mark - Secure Coding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_name forKey:@"name"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
    }
    return self;
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}


- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        NLCategory *test = (NLCategory *)object;
        if ([self.id isEqualToNumber:test.id]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (NSUInteger)hash
{
    return [self.id integerValue];
}

@end
