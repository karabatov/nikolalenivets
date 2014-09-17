//
//  NLSearchViewController.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 12.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSearchViewController.h"
#import "NSAttributedString+Kerning.h"
#import "NLStorage.h"
#import "NLSearchTextView.h"
#import "NLSearchTableViewCell.h"
#import "NLSearchTableViewHeader.h"
#import "NLCollectionCell.h"
#import "NLFlowLayout.h"
#import "NLCategory.h"
#import "NLPlaceHeader.h"
#import "NLPlaceCell.h"
#import "NLLocationManager.h"
#import "NLSectionHeader.h"
#import <NSDate+Helper.h>
#import "NSString+Distance.h"
#import "NLSearchRotatingView.h"
#import "NLSearchNothingFoundView.h"
#import "NLDetailsViewController.h"

/**
 Enum to sort out which data source data to give to a specific collection view.
 */
typedef enum : NSUInteger {
    NLCollectionViewTypeUnknown = 0,
    NLCollectionViewTypeNews = 1,
    NLCollectionViewTypeEvents = 2,
    NLCollectionViewTypePlaces = 3,
} NLCollectionViewType;

@interface NLSearchViewController ()

/**
 Large search button from menu, disappears on start.
 */
@property (strong, nonatomic) UIImageView *searchImageView;

/**
 Back button to return to menu.
 */
@property (strong, nonatomic) UIButton *backButton;

/**
 Top space for search image.
 */
@property (strong, nonatomic) NSLayoutConstraint *searchImageTop;

/**
 Side size for search image.
 */
@property (strong, nonatomic) NSLayoutConstraint *searchImageSide;

/**
 Height constraint for the search field to make it smaller.
 */
@property (strong, nonatomic) NSLayoutConstraint *searchFieldHeight;

/**
 Keep track of height to remove the constraint when necessary.
 */
@property (nonatomic) CGFloat searchFieldStartingHeight;

/**
 Search text field.
 */
@property (strong, nonatomic) NLSearchTextView *searchField;

/**
 Search text field left margin constraint.
 */
@property (strong, nonatomic) NSLayoutConstraint *searchFieldMarginLeft;

/**
 Placeholder label.
 */
@property (strong, nonatomic) UILabel *placeholderLabel;

/**
 Wrapper table view for search results.
 */
@property (strong, nonatomic) UITableView *searchTableView;

/**
 Keeps the order and number of sections in the search results table view.
 */
@property (strong, nonatomic) NSMutableArray *searchSections;

/**
 Categories from search result places.
 */
@property (strong, nonatomic) NSArray *searchPlacesCategories;

/**
 Places matching categories.
 */
@property (strong, nonatomic) NSMutableArray *searchPlacesByCategory;

/**
 Events sorted by day.
 */
@property (strong, nonatomic) NSArray *searchEventsByDay;

@end

@implementation NLSearchViewController
{
    NLSearchTableViewCell *_sizingCellNews;
    CGFloat _sizingCellNewsHeight;
    NLSearchTableViewCell *_sizingCellEvents;
    CGFloat _sizingCellEventsHeight;
    NLSearchTableViewCell *_sizingCellPlaces;
    CGFloat _sizingCellPlacesHeight;
    CLLocation *_userLoc;
}

#define kSearchSectionNews @"News"
#define kSearchSectionEvents @"Events"
#define kSearchSectionPlaces @"Places"

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSearchState:) name:SEARCH_COMPLETE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:NLUserLocationUpdated object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:247.f/255.f green:247.f/255.f blue:247.f/255.f alpha:1.f]];

    self.searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-normal.png"]];
    self.searchImageView.alpha = 0.5f;
    [self.searchImageView setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"search-button-back.png"] forState:UIControlStateNormal];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.hidden = YES;
    self.backButton.alpha = 0.f;

    self.searchField = [[NLSearchTextView alloc] init];
    [self.searchField setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.searchField.backgroundColor = [UIColor clearColor];
    [self.searchField setReturnKeyType:UIReturnKeySearch];
    [self.searchField setScrollEnabled:NO];
    [self.searchField setTintColor:[UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f]];
    self.searchField.hidden = YES;
    self.searchField.alpha = 0.f;
    self.searchField.delegate = self;
    self.searchField.typingAttributes = [self defaultSearchAttributes];

    self.placeholderLabel = [[UILabel alloc] init];
    [self.placeholderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.placeholderLabel setTextAlignment:NSTextAlignmentCenter];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLMonospacedBoldFont size:37],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:202.f/255.f green:202.f/255.f blue:202.f/255.f alpha:1.f],
                                  NSKernAttributeName: [NSNumber numberWithFloat:4.3f] };
    self.placeholderLabel.attributedText = [[NSAttributedString alloc] initWithString:@"ПОИСК" attributes:attributes];
    self.placeholderLabel.alpha = 0.f;
    self.placeholderLabel.hidden = YES;

    self.searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.searchTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.searchTableView setBackgroundColor:[UIColor clearColor]];
    [self.searchTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.searchTableView registerClass:[NLSearchTableViewCell class] forCellReuseIdentifier:[NLSearchTableViewCell reuseIdentifier]];
    [self.searchTableView registerClass:[NLSearchTableViewHeader class] forHeaderFooterViewReuseIdentifier:[NLSearchTableViewHeader reuseSectionId]];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.hidden = YES;
    self.searchTableView.alpha = 0.f;

    [self.view addSubview:self.placeholderLabel];
    [self.view addSubview:self.searchImageView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.searchField];
    [self.view addSubview:self.searchTableView];

    NSDictionary *views = @{ @"sImg": self.searchImageView, @"back": self.backButton, @"search": self.searchField, @"phl": self.placeholderLabel, @"stv": self.searchTableView };
    NSDictionary *metrics = @{ @"backSize": @44, @"backTop": @3.5, @"searchMargin": @17, @"searchV": [NSNumber numberWithFloat:-13.5f], @"phlV": [NSNumber numberWithFloat:-10.5f] };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[back(backSize)]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[stv]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[search]-searchMargin-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[back(backSize)]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-backTop-[back(backSize)]-searchV-[search][stv]|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[back]-phlV-[phl]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    CGFloat searchTop = [UIScreen mainScreen].bounds.size.height / 6.f - 17.f - 62.f;
    self.searchImageTop = [NSLayoutConstraint constraintWithItem:self.searchImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.f constant:searchTop];
    [self.view addConstraint:self.searchImageTop];
    self.searchImageSide = [NSLayoutConstraint constraintWithItem:self.searchImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:62.f];
    [self.view addConstraint:self.searchImageSide];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.searchImageView attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:2.f]];
    self.searchFieldMarginLeft = [NSLayoutConstraint constraintWithItem:self.searchField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.f constant:17.f];
    [self.view addConstraint:self.searchFieldMarginLeft];

    self.searchSections = [[NSMutableArray alloc] initWithCapacity:3];

    _sizingCellNews = [[NLSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NLSearchTableViewCell reuseIdentifier]];
    _sizingCellNews.collectionView.tag = NLCollectionViewTypeNews;
    _sizingCellNews.collectionView.delegate = self;
    _sizingCellNews.collectionView.dataSource = self;
    _sizingCellNews.frame = self.view.frame;
    _sizingCellEvents = [[NLSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NLSearchTableViewCell reuseIdentifier]];
    _sizingCellEvents.collectionView.tag = NLCollectionViewTypeEvents;
    _sizingCellEvents.collectionView.delegate = self;
    _sizingCellEvents.collectionView.dataSource = self;
    _sizingCellEvents.frame = self.view.frame;
    _sizingCellPlaces = [[NLSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NLSearchTableViewCell reuseIdentifier]];
    _sizingCellPlaces.collectionView.tag = NLCollectionViewTypePlaces;
    _sizingCellPlaces.collectionView.delegate = self;
    _sizingCellPlaces.collectionView.dataSource = self;
    _sizingCellPlaces.frame = self.view.frame;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.searchImageView.hidden) {
        self.searchImageView.tintColor = [UIColor blackColor];
        self.searchImageTop.constant = 16.f;
        self.searchImageSide.constant = 19.f;
        [UIView animateWithDuration:0.25f animations:^{
            self.searchImageView.alpha = 1.f;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.searchImageView.image = [self.searchImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            self.backButton.hidden = NO;
            self.searchField.hidden = NO;
            self.placeholderLabel.hidden = NO;
            self.searchTableView.hidden = NO;
            [UIView animateWithDuration:0.15f animations:^{
                self.backButton.alpha = 1.f;
                self.searchField.alpha = 1.f;
                self.placeholderLabel.alpha = 1.f;
                self.searchImageView.alpha = 0.5f;
                self.searchTableView.alpha = 1.f;
            } completion:^(BOOL finished) {
                self.searchImageView.hidden = YES;
                [self.searchField becomeFirstResponder];
            }];
        }];
    }
}

- (void)goBack:(id)sender
{
    self.searchImageView.hidden = NO;
    [UIView animateWithDuration:0.15f animations:^{
        self.backButton.alpha = 0.f;
        self.searchField.alpha = 0.f;
        self.placeholderLabel.alpha = 0.f;
        self.searchImageView.alpha = 1.0f;
        self.searchTableView.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.backButton.hidden = YES;
        self.searchImageView.image = [self.searchImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.searchImageTop.constant = [UIScreen mainScreen].bounds.size.height / 6.f - 17.f - 62.f;
        self.searchImageSide.constant = 62.f;
        self.searchTableView.hidden = YES;
        [UIView animateWithDuration:0.25f animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)updateSearchState:(NSNotification *)notification
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NLStorage *storage = [NLStorage sharedInstance];
        if (storage.searchPhrase && [storage.searchPhrase isEqualToString:self.searchField.text]) {
            [self.searchSections removeAllObjects];
            if (storage.searchResultNews && [storage.searchResultNews count] > 0) {
                [self.searchSections addObject:kSearchSectionNews];
            }
            if (storage.searchResultEvents && [storage.searchResultEvents count] > 0) {
                [self.searchSections addObject:kSearchSectionEvents];
                NSArray *eventDays = _.array(storage.searchResultEvents)
                .map(^(NLEvent *event) {
                    NSDate *eventDate = [event startDate];
                    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&eventDate interval:NULL forDate:eventDate];
                    return eventDate;
                })
                .uniq
                .unwrap;
                eventDays = [eventDays sortedArrayUsingComparator:^NSComparisonResult(NSDate *obj1, NSDate *obj2) {
                    return [obj1 compare:obj2];
                }];
                self.searchEventsByDay = _.array(eventDays)
                .map(^(NSDate *day) {
                    NSArray *eventsOnDay = _.array(storage.searchResultEvents)
                    .filter(^BOOL (NLEvent *event) {
                        NSDate *compare = [event startDate];
                        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&compare interval:NULL forDate:compare];
                        return [day isEqualToDate:compare] ? YES : NO;
                    }).unwrap;
                    return eventsOnDay;
                }).unwrap;
            }
            if (storage.searchResultPlaces && [storage.searchResultPlaces count] > 0) {
                [self.searchSections addObject:kSearchSectionPlaces];
                if (!self.searchPlacesByCategory) {
                    self.searchPlacesByCategory = [[NSMutableArray alloc] init];
                } else {
                    [self.searchPlacesByCategory removeAllObjects];
                }

                self.searchPlacesCategories = _.array(storage.searchResultPlaces)
                .map(^(NLPlace *place){
                    return place.categories;
                }).flatten.uniq.unwrap;

                for (NLCategory *category in self.searchPlacesCategories) {
                    NSArray *placesForCat = [[NSArray alloc] init];
                    placesForCat = _.array(storage.searchResultPlaces)
                    .filter(^BOOL (NLPlace *place){
                        return [category.id isEqualToNumber:((NLCategory *)[place.categories firstObject]).id];
                    }).unwrap;
                    [self.searchPlacesByCategory addObject:placesForCat];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_sizingCellNews.collectionView reloadData];
                _sizingCellNews.collectionView.collectionViewLayout = [NLSearchTableViewCell newFlowLayout];
                [_sizingCellNews setNeedsLayout];
                [_sizingCellNews layoutIfNeeded];
                _sizingCellNewsHeight = [_sizingCellNews.collectionView.collectionViewLayout collectionViewContentSize].height;
                [_sizingCellEvents.collectionView reloadData];
                _sizingCellEvents.collectionView.collectionViewLayout = [NLSearchTableViewCell newFlowLayout];
                [_sizingCellEvents setNeedsLayout];
                [_sizingCellEvents layoutIfNeeded];
                _sizingCellEventsHeight = [_sizingCellEvents.collectionView.collectionViewLayout collectionViewContentSize].height;
                [_sizingCellPlaces.collectionView reloadData];
                _sizingCellPlaces.collectionView.collectionViewLayout = [NLSearchTableViewCell newFlowLayout];
                [_sizingCellPlaces setNeedsLayout];
                [_sizingCellPlaces layoutIfNeeded];
                _sizingCellPlacesHeight = [_sizingCellPlaces.collectionView.collectionViewLayout collectionViewContentSize].height;
                [self.searchTableView reloadData];
                [UIView animateWithDuration:0.25f animations:^{
                    self.searchTableView.alpha = 1.f;
                } completion:^(BOOL finished) {
                    if ([self.searchSections count] == 0 && ![storage.searchPhrase isEqualToString:@""]) {
                        self.searchTableView.tableHeaderView = [[NLSearchNothingFoundView alloc] initWithFrame:CGRectMake(0, 0, 0, 48)];
                    } else {
                        CGRect newFrame = self.searchTableView.tableHeaderView.frame;
                        newFrame.size.height = 0;
                        NLSearchRotatingView *tableHeaderView = (NLSearchRotatingView *)self.searchTableView.tableHeaderView;
                        tableHeaderView.imageHeight.constant = 0.f;
                        [UIView animateWithDuration:0.25f animations:^{
                            tableHeaderView.frame = newFrame;
                            self.searchTableView.tableHeaderView = tableHeaderView;
                            [self.searchTableView.tableHeaderView layoutIfNeeded];
                        } completion:^(BOOL finished) {
                            self.searchTableView.tableHeaderView = nil;
                        }];
                    }
                    [self.searchTableView setUserInteractionEnabled:YES];
                }];
                NSLog(@"Search complete, reloading.");
            });
        }
    });
}

- (NSDictionary *)defaultSearchAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 0.1f;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.maximumLineHeight = 39.f;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:NLMonospacedBoldFont size:37],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f],
                                  NSKernAttributeName: [NSNumber numberWithFloat:4.3f],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    return attributes;
}

- (void)locationUpdated:(NSNotification *)newLocation
{
    NSUInteger idx = NSNotFound;
    if (!_userLoc) {
        idx = [self.searchSections indexOfObject:kSearchSectionPlaces];
    }
    _userLoc = newLocation.object;
    if (idx != NSNotFound) {
        [self.searchTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForItem:0 inSection:idx] ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)restoreSearchFieldSize
{
    if (self.searchFieldHeight) {
        self.searchFieldHeight.constant = self.searchFieldStartingHeight;
        [UIView animateWithDuration:0.25f animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.view removeConstraint:self.searchFieldHeight];
            self.searchFieldHeight = nil;
        }];
    }
}

#pragma mark - UITextViewDelegate protocol

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self restoreSearchFieldSize];
    if (self.searchTableView.tableHeaderView) {
        self.searchTableView.tableHeaderView = nil;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.placeholderLabel.hidden = NO;
        [self.searchField setTintColor:[UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f]];
        self.searchFieldMarginLeft.constant = 17.f;
    } else {
        textView.text = [textView.text uppercaseString];
        self.placeholderLabel.hidden = YES;
        [self.searchField setTintColor:[UIColor colorWithRed:43.f/255.f green:191.f/255.f blue:71.f/255.f alpha:1.f]];
        self.searchFieldMarginLeft.constant = 21.5f;
    }
    [UIView animateWithDuration:0.1f animations:^{
        [self.searchField layoutIfNeeded];
    }];
    // Necessary to change caret appearance
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
        [textView becomeFirstResponder];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        UIView *headerView = [[NLSearchRotatingView alloc] initWithFrame:CGRectMake(0, 0, 0, 48)];
        [self.searchTableView setUserInteractionEnabled:NO];
        [self.searchTableView setContentOffset:CGPointZero animated:YES];
        [UIView animateWithDuration:0.25f animations:^{
            self.searchTableView.alpha = 0.5f;
            self.searchTableView.tableHeaderView = headerView;
            for (NLSearchTableViewCell *tableCell in [self.searchTableView visibleCells]) {
                for (id collCell in [tableCell.collectionView visibleCells]) {
                    if ([collCell respondsToSelector:@selector(makeImageGrayscale:)]) {
                        [collCell makeImageGrayscale:YES];
                    }
                }
            }
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [[NLStorage sharedInstance] startSearchWithPhrase:textView.text];
            });
        }];
        return NO;
    }

    return YES;
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.searchSections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NLSearchTableViewCell reuseIdentifier] forIndexPath:indexPath];
    NSString *sectionTitle = [self.searchSections objectAtIndex:indexPath.section];
    if ([sectionTitle isEqualToString:kSearchSectionNews]) {
        cell.collectionView.tag = NLCollectionViewTypeNews;
    } else if ([sectionTitle isEqualToString:kSearchSectionEvents]) {
        cell.collectionView.tag = NLCollectionViewTypeEvents;
    } else if ([sectionTitle isEqualToString:kSearchSectionPlaces]) {
        cell.collectionView.tag = NLCollectionViewTypePlaces;
    } else {
        cell.collectionView.tag = NLCollectionViewTypeUnknown;
    }
    cell.collectionView.delegate = self;
    cell.collectionView.dataSource = self;
    [cell.collectionView reloadData];
    cell.collectionView.collectionViewLayout = [NLSearchTableViewCell newFlowLayout];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 52.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 52.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = [self.searchSections objectAtIndex:indexPath.section];
    if ([sectionTitle isEqualToString:kSearchSectionNews]) {
        if ([[NLStorage sharedInstance].searchPhrase isEqualToString:self.searchField.text]) {
            NSLog(@"cached height");
            return _sizingCellNewsHeight;
        } else {
            NSLog(@"uncached height");
            [_sizingCellNews.collectionView reloadData];
            _sizingCellNews.collectionView.collectionViewLayout = [NLSearchTableViewCell newFlowLayout];
            [_sizingCellNews setNeedsLayout];
            [_sizingCellNews layoutIfNeeded];
            return [_sizingCellNews.collectionView.collectionViewLayout collectionViewContentSize].height;
        }
    } else if ([sectionTitle isEqualToString:kSearchSectionEvents]) {
        if ([[NLStorage sharedInstance].searchPhrase isEqualToString:self.searchField.text]) {
            NSLog(@"cached height");
            return _sizingCellEventsHeight;
        } else {
            NSLog(@"uncached height");
            [_sizingCellEvents.collectionView reloadData];
            _sizingCellEvents.collectionView.collectionViewLayout = [NLSearchTableViewCell newFlowLayout];
            [_sizingCellEvents setNeedsLayout];
            [_sizingCellEvents layoutIfNeeded];
            return [_sizingCellEvents.collectionView.collectionViewLayout collectionViewContentSize].height;
        }
    } else if ([sectionTitle isEqualToString:kSearchSectionPlaces]) {
        if ([[NLStorage sharedInstance].searchPhrase isEqualToString:self.searchField.text]) {
            NSLog(@"cached height");
            return _sizingCellPlacesHeight;
        } else {
            NSLog(@"uncached height");
            [_sizingCellPlaces.collectionView reloadData];
            _sizingCellPlaces.collectionView.collectionViewLayout = [NLSearchTableViewCell newFlowLayout];
            [_sizingCellPlaces setNeedsLayout];
            [_sizingCellPlaces layoutIfNeeded];
            return [_sizingCellPlaces.collectionView.collectionViewLayout collectionViewContentSize].height;
        }
    }
    return 0.f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NLSearchTableViewHeader *header = (NLSearchTableViewHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[NLSearchTableViewHeader reuseSectionId]];
    if (!header) {
        header = [[NLSearchTableViewHeader alloc] initWithReuseIdentifier:[NLSearchTableViewHeader reuseSectionId]];
    }
    NSString *sectionTitle = [self.searchSections objectAtIndex:section];
    if ([sectionTitle isEqualToString:kSearchSectionNews]) {
        header.sectionTitle = @"НОВОСТИ";
    } else if ([sectionTitle isEqualToString:kSearchSectionEvents]) {
        header.sectionTitle = @"СОБЫТИЯ";
    } else if ([sectionTitle isEqualToString:kSearchSectionPlaces]) {
        header.sectionTitle = @"МЕСТА";
    }
    return header;
}

/**
 How far back the table view can scroll before search field size stops changing.
 */
#define kNLSearchFieldMaxOffset 20.f

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffset = 0.f;
    [self.searchField resignFirstResponder];
    CGFloat offsetY = scrollView.contentOffset.y;

    if (!self.searchFieldHeight) {
        self.searchFieldStartingHeight = self.searchField.frame.size.height;
        self.searchFieldHeight = [NSLayoutConstraint constraintWithItem:self.searchField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:self.searchFieldStartingHeight];
        [self.view addConstraint:self.searchFieldHeight];
    } else {
        if (offsetY >= 0 && offsetY > lastOffset) {
            self.searchFieldHeight.constant = MAX(self.searchFieldStartingHeight - kNLSearchFieldMaxOffset, self.searchFieldHeight.constant - (offsetY - lastOffset));
        } else if (offsetY >= 0 && offsetY <= kNLSearchFieldMaxOffset) {
            self.searchFieldHeight.constant = self.searchFieldStartingHeight - MIN(offsetY, kNLSearchFieldMaxOffset);
        } else if (offsetY < 0) {
            self.searchFieldHeight.constant = self.searchFieldStartingHeight;
        }
    }
    lastOffset = offsetY;
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (collectionView.tag) {
        case NLCollectionViewTypeNews:
        {
            NLCollectionCell *cell = (NLCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[NLCollectionCell reuseIdentifier] forIndexPath:indexPath];
            NLNewsEntry *entry = [[NLStorage sharedInstance].searchResultNews objectAtIndex:indexPath.item];
            [cell populateFromNewsEntry:entry];
            cell.counterLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)([[NLStorage sharedInstance].searchResultNews count] - indexPath.item)];
            return cell;
            break;
        }
        case NLCollectionViewTypePlaces:
        {
            NLPlaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NLPlaceCell reuseIdentifier] forIndexPath:indexPath];
            if (indexPath.section < [self.searchPlacesCategories count]) {
                NLPlace *place = self.searchPlacesByCategory[indexPath.section][indexPath.item];
                [cell populateWithPlace:place];
                if (_userLoc) {
                    CLLocationDistance distance = [place distanceFromLocation:_userLoc];
                    cell.distanceLabel.text = [[NSString stringFromDistance:distance] uppercaseString];
                }
            }
            return cell;
            break;
        }
        case NLCollectionViewTypeEvents:
        {
            NLCollectionCell *cell = (NLCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[NLCollectionCell reuseIdentifier] forIndexPath:indexPath];
            NLEvent *event = self.searchEventsByDay[indexPath.section][indexPath.item];
            [cell populateFromEvent:event];
            cell.counterLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)([self.searchEventsByDay[indexPath.section] count] - indexPath.item)];
            return cell;
            break;
        }

        default:
            return nil;
            break;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (collectionView.tag) {
        case NLCollectionViewTypeNews:
            return [[NLStorage sharedInstance].searchResultNews count];
            break;
        case NLCollectionViewTypePlaces:
            return [self.searchPlacesByCategory[section] count];
            break;
        case NLCollectionViewTypeEvents:
            return [self.searchEventsByDay[section] count];
            break;

        default:
            return 0;
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    switch (collectionView.tag) {
        case NLCollectionViewTypePlaces:
        {
            if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
                NLPlaceHeader *sectionView = (NLPlaceHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:[NLPlaceHeader reuseSectionId] forIndexPath:indexPath];
                if (!sectionView) {
                    sectionView = [[NLPlaceHeader alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 46.0f)];
                }
                sectionView.objectCountLabel.text = [NSString stringWithFormat:@"%02ld", (unsigned long)[self.searchPlacesByCategory[indexPath.section] count]];
                sectionView.categoryNameLabel.text = [((NLCategory *)(self.searchPlacesCategories[indexPath.section])).name uppercaseString];
                return sectionView;
            }
            break;
        }
        case NLCollectionViewTypeEvents:
        {
            NLSectionHeader *sectionView = (NLSectionHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:[NLSectionHeader reuseSectionId] forIndexPath:indexPath];
            if (!sectionView) {
                sectionView = [[NLSectionHeader alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 46.0f)];
            }
            sectionView.dayOrderLabel.hidden = YES;
            NLEvent *event = [self.searchEventsByDay[indexPath.section] firstObject];
            sectionView.dateLabel.text = [[[event startDate] stringWithFormat:DefaultDateFormat] uppercaseString];
            return sectionView;
            break;
        }

        default:
            return nil;
            break;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    switch (collectionView.tag) {
        case NLCollectionViewTypeNews:
            return 1;
            break;
        case NLCollectionViewTypePlaces:
            return [self.searchPlacesCategories count];
            break;
        case NLCollectionViewTypeEvents:
            return [self.searchEventsByDay count];
            break;

        default:
            return 0;
            break;
    }
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    switch (collectionView.tag) {
        case NLCollectionViewTypePlaces:
            return 46.f;
            break;
        case NLCollectionViewTypeEvents:
            return 46.f;
            break;

        default:
            return 0.f;
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2.0f;
    switch (collectionView.tag) {
        case NLCollectionViewTypeNews:
        {
            NLNewsEntry *entry = [[NLStorage sharedInstance].searchResultNews objectAtIndex:indexPath.item];
            return CGSizeMake(width, [NLCollectionCell heightForCellWithEntry:entry]);
            break;
        }
        case NLCollectionViewTypePlaces:
        {
            return CGSizeMake(width, 194.f);
            break;
        }
        case NLCollectionViewTypeEvents:
        {
            NLEvent *event = self.searchEventsByDay[indexPath.section][indexPath.item];
            CGFloat height = [NLCollectionCell heightForCellWithEvent:event];
            return CGSizeMake(width, height);
            break;
        }

        default:
            return CGSizeZero;
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.title = @"ПОИСК";
    NLDetailsViewController *details = nil;
    switch (collectionView.tag) {
        case NLCollectionViewTypeNews:
        {
            NLNewsEntry *entry = [NLStorage sharedInstance].searchResultNews[indexPath.item];
            details = [[NLDetailsViewController alloc] initWithEntry:entry];
            break;
        }
        case NLCollectionViewTypeEvents:
        {
            NLEvent *event = self.searchEventsByDay[indexPath.section][indexPath.item];
            details = [[NLDetailsViewController alloc] initWithEvent:event withOrderInGroup:indexPath.section + 1];
            break;
        }
        case NLCollectionViewTypePlaces:
        {
            NLPlace *place = self.searchPlacesByCategory[indexPath.section][indexPath.item];
            details = [[NLDetailsViewController alloc] initWithPlace:place currentLocation:_userLoc];
            break;
        }

        default:
            break;
    }
    if (details) {
        [self.navigationController pushViewController:details animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
        });
    }
}

@end
