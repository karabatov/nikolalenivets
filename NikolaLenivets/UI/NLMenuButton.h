//
//  NLMenuButton.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 03.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;

/**
 Main menu button with letters, a dark bar on top and background gradient on press.
 */
@interface NLMenuButton : UIControl

/**
 String type title, used to set title on the button label.
 */
@property (strong, nonatomic) NSString *title;

/**
 External counter label to set its alpha.
 */
@property (weak, nonatomic) UILabel *counter;

@end
