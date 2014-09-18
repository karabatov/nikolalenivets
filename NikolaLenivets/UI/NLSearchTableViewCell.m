//
//  NLSearchTableViewCell.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 13.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLSearchTableViewCell.h"
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

        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[NLSearchTableViewCell newFlowLayout]];
        [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];

        [self.collectionView registerClass:[NLPlaceCell class] forCellWithReuseIdentifier:[NLPlaceCell reuseIdentifier]];
        [self.collectionView registerClass:[NLPlaceHeader class] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:[NLPlaceHeader reuseSectionId]];
        [self.collectionView registerClass:[NLCollectionCell class] forCellWithReuseIdentifier:[NLCollectionCell reuseIdentifier]];
        [self.collectionView registerClass:[NLSectionHeader class] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:[NLSectionHeader reuseSectionId]];

        [self.contentView addSubview:self.collectionView];

        NSDictionary *views = @{ @"cv": self.collectionView };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cv]|" options:kNilOptions metrics:nil views:views]];
    }
    return self;
}

+ (NLFlowLayout *)newFlowLayout
{
    NLFlowLayout *layout = [[NLFlowLayout alloc] init];
    layout.columnCount = 2;
    layout.headerHeight = 0.0f;
    layout.footerHeight = 0.0f;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumColumnSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    return layout;
}

+ (NSString *)reuseIdentifier
{
    return @"NLSearchTableViewCell";
}

@end
