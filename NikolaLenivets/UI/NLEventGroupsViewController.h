//
//  NLEventsViewController.h
//  NikolaLenivets
//
//  Created by Semyon Novikov on 17.05.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLEventGroupsViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemsCountLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *prevItemButton;
@property (weak, nonatomic) IBOutlet UIButton *nextItemButton;
@property (weak, nonatomic) IBOutlet UILabel *currentPageLabel;
@property (weak, nonatomic) IBOutlet UILabel *overallPagesCountLabel;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDatesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateDashLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDatesLabel;
@property (weak, nonatomic) IBOutlet UIView *pagerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBarHeight;

- (IBAction)openEventsList:(id)sender;

@end
