//
//  NLFlowLayout.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 15.07.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLFlowLayout.h"

@interface NLFlowLayout ()

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIDynamicItemBehavior *dynamic;

@end

@implementation NLFlowLayout

- (void) prepareLayout {
	[super prepareLayout];
}

- (CGSize) collectionViewContentSize {
	CGSize size = [super collectionViewContentSize];

	return size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
	if (self.animator) {
		return [self.animator itemsInRect:rect];
	}

	self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    self.dynamic = [[UIDynamicItemBehavior alloc] init];
    self.dynamic.elasticity = 0.0f;
    self.dynamic.friction = 1.0f;
    self.dynamic.density = 0.5f;
    self.dynamic.resistance = 0.1f;
    self.dynamic.allowsRotation = NO;
    [self.animator addBehavior:self.dynamic];

	CGSize contentSize = [self collectionViewContentSize];
	CGRect size = (CGRect) { .size = contentSize };
	NSArray *items = [super layoutAttributesForElementsInRect:size];

	[items enumerateObjectsUsingBlock:^(id<UIDynamicItem> obj, NSUInteger idx, BOOL *stop) {
		UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc] initWithItem:obj attachedToAnchor:[obj center]];
        behavior.length = 1.0f;
		behavior.damping = 0.5f;
		behavior.frequency = 1.9f;
		[self.animator addBehavior:behavior];
        [self.dynamic addItem:obj];
	}];

	return items;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.animator layoutAttributesForCellAtIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [self.animator layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;

    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];

    [self.animator.behaviors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIAttachmentBehavior class]]) {
            UIAttachmentBehavior *springBehavior = (UIAttachmentBehavior *)obj;
            CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehavior.anchorPoint.y);
            CGFloat xDistanceFromTouch = fabsf(touchLocation.x - springBehavior.anchorPoint.x);
            CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;

            UICollectionViewLayoutAttributes *item = springBehavior.items.firstObject;
            CGPoint center = item.center;
            if (delta < 0) {
                center.y += MAX(delta, delta*scrollResistance);
            }
            else {
                center.y += MIN(delta, delta*scrollResistance);
            }
            item.center = center;

            [self.animator updateItemUsingCurrentState:item];
        }
    }];

    return NO;
}

@end
