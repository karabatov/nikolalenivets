//
//  NLMapFilter.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 25.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLMapFilter.h"
#import "NLMapFilterCell.h"
#import "NLCategory.h"

@interface NLMapFilter ()

@property (strong, nonatomic) NSArray *categories;
@property (weak, nonatomic) NSMutableArray *selectedCat;
@property (strong, nonatomic) NSMutableArray *currentSelectedCat;

@property (strong, nonatomic) UIView *toolbarView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) NSLayoutConstraint *tableViewBottom;

@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *confirmButton;

@end

@implementation NLMapFilter

static NSString * const mapCellReuseId = @"NLMapFilterCell";

- (instancetype)initWithFrame:(CGRect)frame andCategories:(NSArray *)categories selected:(NSMutableArray *)selectedCat
{
    self = [super initWithFrame:frame];
    if (self) {
        self.categories = categories;
        self.selectedCat = selectedCat;
        self.currentSelectedCat = [NSMutableArray arrayWithArray:selectedCat];
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup
{
    [self setOpaque:NO];
    [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"NLMapFilterCell" bundle:nil] forCellReuseIdentifier:mapCellReuseId];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.toolbarView = [[UIView alloc] init];
    [self addSubview:self.toolbarView];
    [self.toolbarView setBackgroundColor:[UIColor whiteColor]];

    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.toolbarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = @{ @"table": self.tableView, @"toolbar": self.toolbarView };
    NSDictionary *metrics = @{ @"toolbarheight": @52 };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table]|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbar]|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[toolbar(toolbarheight)]|" options:kNilOptions metrics:metrics views:views]];
    // Compute table view height based on number of categories. Limit to 6.
    CGFloat tableHeight = 52 * [_categories count] + 1 * ([_categories count] - 1);
    tableHeight = MIN(tableHeight, 52 * 6 + 5 + 26);
    self.tableViewHeight = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:tableHeight];
    self.tableViewBottom = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.toolbarView attribute:NSLayoutAttributeTop multiplier:1.0f constant:[UIScreen mainScreen].applicationFrame.size.height];
    [self addConstraints:@[ self.tableViewHeight, self.tableViewBottom ]];

    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.toolbarView addSubview:self.cancelButton];
    [self.toolbarView addSubview:self.confirmButton];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.confirmButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.cancelButton setTitle:NSLocalizedString(@"ОТМЕНИТЬ", @"Map filter CANCEL") forState:UIControlStateNormal];
    [self.confirmButton setTitle:NSLocalizedString(@"ОК", @"Map filter OK") forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = self.confirmButton.titleLabel.font = [UIFont fontWithName:NLMonospacedBoldFont size:18];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cancelButton.alpha = self.confirmButton.alpha = 0.0f;
    views = @{ @"cancel": self.cancelButton, @"confirm": self.confirmButton };
    metrics = @{ @"height": @44 };
    [self.toolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancel(height)]" options:kNilOptions metrics:metrics views:views]];
    [self.toolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[confirm(height)]" options:kNilOptions metrics:metrics views:views]];
    [self.toolbarView addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.toolbarView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self.toolbarView addConstraint:[NSLayoutConstraint constraintWithItem:self.confirmButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.toolbarView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self.toolbarView addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.toolbarView attribute:NSLayoutAttributeCenterX multiplier:0.5f constant:0.0f]];
    [self.toolbarView addConstraint:[NSLayoutConstraint constraintWithItem:self.confirmButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.toolbarView attribute:NSLayoutAttributeCenterX multiplier:1.5f constant:0.0f]];
}

- (void)displayAnimated
{
    self.tableViewBottom.constant = -1;
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.cancelButton.alpha = self.confirmButton.alpha = 1.0f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)hideAnimated
{
    self.tableViewBottom.constant = [UIScreen mainScreen].applicationFrame.size.height;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.cancelButton.alpha = self.confirmButton.alpha = 0.0f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self setHidden:YES];
        }];
    }];
}

- (void)cancelButtonPressed:(UIButton *)sender
{
    [self hideAnimated];
    [self.parentMap filterWantsToDismissWithReload:NO];
}

- (void)confirmButtonPressed:(UIButton *)sender
{
    [self.selectedCat removeAllObjects];
    [self.selectedCat addObjectsFromArray:self.currentSelectedCat];
    [self hideAnimated];
    [self.parentMap filterWantsToDismissWithReload:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLMapFilterCell *cell = (NLMapFilterCell *)[tableView dequeueReusableCellWithIdentifier:mapCellReuseId forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NLMapFilterCell" owner:self options:nil] firstObject];
    }
    NLCategory *category = self.categories[indexPath.row];
    cell.titleLabel.text = [category.name uppercaseString];
    [cell setActivated:[self.currentSelectedCat containsObject:category]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLMapFilterCell *cell = (NLMapFilterCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setActivated:![cell isActivated]];
    if ([cell isActivated]) {
        [self.currentSelectedCat addObject:self.categories[indexPath.row]];
    } else {
        [self.currentSelectedCat removeObject:self.categories[indexPath.row]];
    }
    [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
