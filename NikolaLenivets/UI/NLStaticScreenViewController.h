//
//  NLStaticScreenViewController.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 29.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLStaticScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (id)initWithScreenNamed:(NSString *)screenName;

@end
