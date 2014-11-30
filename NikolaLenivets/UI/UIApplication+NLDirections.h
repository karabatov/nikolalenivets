//
//  UIApplication+NLDirections.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 30.11.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (NLDirections)

- (void)openDirectionsWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
