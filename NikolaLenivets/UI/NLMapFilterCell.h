//
//  NLMapFilterCell.h
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 25.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

@import UIKit;

@interface NLMapFilterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *checkmarkButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, getter = isActivated) BOOL activated;

@end
