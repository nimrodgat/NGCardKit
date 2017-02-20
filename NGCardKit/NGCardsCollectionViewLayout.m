//
//  NGCardsCollectionViewLayout.m
//  NGCardKit
//
//  Created by Nim Gat on 12/25/16.
//  Copyright © 2016 - 2017 Nim Gat. All rights reserved.
//

#import "NGCardsCollectionViewLayout.h"

#import "NGCardsCollectionViewLayoutAttributes.h"

static CGFloat const NGCardsLayoutFlickVelocity = 0.07;

@implementation NGCardsCollectionViewLayout


+ (Class)layoutAttributesClass
{
    return [NGCardsCollectionViewLayoutAttributes class];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.minimumInteritemSpacing = 0.0;
        self.minimumLineSpacing = 0.0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _minimumScaleValue = 0.88;
        _minimumAlphaValue = 0.35;
    }
    return self;
}

- (CGFloat)cardWidth
{
    return (self.minimumLineSpacing + self.itemSize.width);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat cardWidth = self.cardWidth;
    CGPoint currentOffset = self.collectionView.contentOffset;
    CGFloat rawPageIndex = currentOffset.x / cardWidth;
    CGFloat pageIndex = (velocity.x > 0.0) ? floor(rawPageIndex) : ceil(rawPageIndex);
    CGFloat nextPageIndex = (velocity.x > 0.0) ? ceil(rawPageIndex) : floor(rawPageIndex);
    CGPoint targetOffset = proposedContentOffset;
    
    
    BOOL lessThanAPage = ABS(1.0 + pageIndex - rawPageIndex) > 0.5;
    BOOL flicked = ABS(velocity.x) > NGCardsLayoutFlickVelocity;
    if (lessThanAPage && flicked) {
        targetOffset.x = nextPageIndex * cardWidth;
    } else {
        targetOffset.x = round(rawPageIndex) * cardWidth;
    }
    targetOffset.x -= ((self.collectionView.bounds.size.width - self.itemSize.width) / 2.0);
    
    // if the target point is in the opposite direction to the current motion, kickoff content offset animation in the next runloop (so it won't stutter)
    if ((velocity.x > 0.0 && targetOffset.x < currentOffset.x) ||
        (velocity.x < 0.0 && targetOffset.x > currentOffset.x)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView setContentOffset:targetOffset animated:YES];
        });
        return proposedContentOffset;
    }
    else {
        return targetOffset;
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *modifiedAttributes = [NSMutableArray arrayWithCapacity:layoutAttributes.count];
    for (NGCardsCollectionViewLayoutAttributes *attributes in layoutAttributes)
    {
        NGCardsCollectionViewLayoutAttributes *copiedAttributes = [attributes copy];
        [self _updateLayoutAttributes:copiedAttributes];
        [modifiedAttributes addObject:copiedAttributes];
    }
    return modifiedAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NGCardsCollectionViewLayoutAttributes *attributes = (NGCardsCollectionViewLayoutAttributes *)[super layoutAttributesForItemAtIndexPath:indexPath];
    NGCardsCollectionViewLayoutAttributes *copiedAttributes = [attributes copy];
    [self _updateLayoutAttributes:copiedAttributes];
    return copiedAttributes;
}

- (CGFloat)progressForItemAtIndex:(NSIndexPath *)indexPath
{
    if (self.deleting) {
        return 0.0;
    }
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGFloat itemOffsetX = layoutAttributes.frame.origin.x;
    CGFloat contentOffsetX = (self.collectionView.contentOffset.x + self.collectionView.contentInset.left);
    CGFloat offsetDiff = ABS(itemOffsetX - contentOffsetX);
    CGFloat progress = 1.0 - MIN((offsetDiff / self.cardWidth), 1.0);
    return progress;
}

#pragma mark - internal

- (void)_updateLayoutAttributes:(NGCardsCollectionViewLayoutAttributes *)attributes
{
    CGRect frame = attributes.frame;
    frame.origin.y = 0.0;
    attributes.frame = frame;
    
    CGFloat progress = [self progressForItemAtIndex:attributes.indexPath];
    attributes.highlightProgress = progress;
    
    attributes.alpha = (self.minimumAlphaValue + ((1.0 - self.minimumAlphaValue) * progress));
    
    CGFloat scale = self.minimumScaleValue + ((1.0 - self.minimumScaleValue) * progress);
    attributes.transform = CGAffineTransformMakeScale(scale, scale);
}


@end
