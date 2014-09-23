//
//  NLTravelTypeSectionView.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 23.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;

typedef enum : NSUInteger {
    NLTravelTypeCar = 0,
    NLTravelTypeTrain = 1,
    NLTravelTypeBus = 2,
    NLTravelTypeFestival = 3,
    NLTravelTypeHeli = 4
} NLTravelType;

/**
 Header view for the travel screen.
 */
@interface NLTravelTypeSectionView : UIView

/**
 Add tap target and action.
 */
- (void)addTarget:(id)target withAction:(SEL)action;

@end
