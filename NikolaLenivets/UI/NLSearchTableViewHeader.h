//
//  NLSearchTableViewHeader.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 14.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Header view for Search.
 */
@interface NLSearchTableViewHeader : UITableViewHeaderFooterView

/**
 "Virtual" property to set the attributed text for section title label.
 */
@property (strong, nonatomic) NSString *sectionTitle;

/**
 Reuse identifier for section header.
 */
+ (NSString *)reuseSectionId;

@end
