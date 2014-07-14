//
//  NLAttributedLabel.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 14.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLAttributedLabel.h"

@implementation NLAttributedLabel

- (void)layoutSubviews
{
    CGRect frame = self.frame;
    CGSize neededSize = self.layoutFrame.frame.size;

    if (!CGSizeEqualToSize(frame.size, neededSize)) {
        frame.size.height = neededSize.height;
        self.frame = frame;
        [self invalidateIntrinsicContentSize];
    }

    [super layoutSubviews];
}

@end
