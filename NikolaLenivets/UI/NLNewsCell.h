//
//  NLNewsCell.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 13.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLNewsEntry.h"

#import <DTCoreText.h>

@interface NLNewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet DTAttributedLabel *previewLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

+ (CGFloat)heightForCellWithEntry:(NLNewsEntry *)entry;
- (void)populateFromNewsEntry:(NLNewsEntry *)entry;

@end
