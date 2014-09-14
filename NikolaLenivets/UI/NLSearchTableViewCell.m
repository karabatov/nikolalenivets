//
//  NLSearchTableViewCell.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 13.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSearchTableViewCell.h"
#import "NLFlowLayout.h"
#import "NLPlaceCell.h"
#import "NLPlaceHeader.h"
#import "NLCollectionCell.h"
#import "NLSectionHeader.h"

@implementation NLSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        NLFlowLayout *layout = [[NLFlowLayout alloc] init];
        layout.columnCount = 2;
        layout.headerHeight = 0.0f;
        layout.footerHeight = 0.0f;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumColumnSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];

        [self.collectionView registerNib:[UINib nibWithNibName:@"NLPlaceCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[NLPlaceCell reuseIdentifier]];
        [self.collectionView registerClass:[NLPlaceHeader class] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:[NLPlaceHeader reuseSectionId]];
        [self.collectionView registerNib:[UINib nibWithNibName:@"NLCollectionCellView" bundle:nil] forCellWithReuseIdentifier:[NLCollectionCell reuseIdentifier]];
        [self.collectionView registerClass:[NLSectionHeader class] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:[NLSectionHeader reuseSectionId]];

        [self.contentView addSubview:self.collectionView];

        NSDictionary *views = @{ @"cv": self.collectionView };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cv]|" options:kNilOptions metrics:nil views:views]];
    }
    return self;
}

- (void)prepareForReuse
{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

+ (NSString *)reuseIdentifier
{
    return @"NLSearchTableViewCell";
}

@end
