//
//  NLAboutScreenController.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 17.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;

/**
 Static screen view controller for the About screen.
 */
@interface NLAboutScreenController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>

- (instancetype)initWithScreenNamed:(NSString *)screenName;

@end
