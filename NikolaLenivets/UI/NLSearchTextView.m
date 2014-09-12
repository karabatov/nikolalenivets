//
//  NLSearchTextView.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 12.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSearchTextView.h"

@implementation NLSearchTextView

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.origin.x -= 0.5;
    originalRect.origin.y += 11.f;
    originalRect.size.width = 3.f;
    originalRect.size.height = 23.5f;
    return originalRect;
}

@end
