//
//  NLNewsCell.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 13.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLNewsEntry.h"
#import "NLEvent.h"

#import <DTCoreText.h>
#import <AsyncImageView.h>

@interface NLNewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet DTAttributedLabel *previewLabel;
@property (weak, nonatomic) IBOutlet AsyncImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *unreadIndicator;

+ (CGFloat)heightForCellWithEntry:(NLNewsEntry *)entry;
+ (CGFloat)heightForCellWithEvent:(NLEvent *)event;

- (void)populateFromNewsEntry:(NLNewsEntry *)entry;
- (void)populateFromEvent:(NLEvent *)event;

@end
