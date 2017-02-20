//
//  NGCardsView.m
//  NGCardKit
//
//  Created by Nim Gat on 12/25/16.
//  Copyright © 2016 - 2017 Nim Gat. All rights reserved.
//

#import "NGCardsView.h"

#import "NGCardsCollectionViewCell.h"
#import "NGCardsCollectionViewLayout.h"
#import "NGCardsViewDataSource.h"
#import "NGCardsViewDelegate.h"


typedef struct {
    unsigned int numberOfItems:1;
    unsigned int cardSize:1;
    unsigned int cardContent:1;
} NGCardsDataSourceRespondsTo;

typedef struct {
    unsigned int didScroll:1;
    unsigned int didSelect:1;
    unsigned int didVerticalScroll:1;
    unsigned int delete:1;
    unsigned int didFinishDelete:1;
    unsigned int reuseCard:1;
} NGCardsDelegateRespondsTo;


@interface NGCardsView ()<UICollectionViewDelegate, UICollectionViewDataSource, NGCardsCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NGCardsCollectionViewLayout *cardsLayout;

@property (nonatomic, assign) NGCardsDelegateRespondsTo delegateRespondsTo;
@property (nonatomic, assign) NGCardsDataSourceRespondsTo dataSourceRespondsTo;

@property (nonatomic, assign) CGPoint lastContentOffset;

@end


@implementation NGCardsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                
        _deleteActionString = [[NSAttributedString alloc] initWithString:@"Delete" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:30.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        _lastContentOffset = CGPointZero;
        
        CGSize itemSize = [self _itemSize];
        _cardsLayout = [[NGCardsCollectionViewLayout alloc] init];
        _cardsLayout.itemSize = itemSize;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.cardsLayout];
        [_collectionView registerClass:[NGCardsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([NGCardsCollectionViewCell class])];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.clipsToBounds = NO;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(frame, self.frame)) {
        [super setFrame:frame];
        [self _updateContentInset];
    }
}

- (void)setBounds:(CGRect)bounds
{
    if (!CGRectEqualToRect(bounds, self.bounds)) {
        [super setBounds:bounds];
        [self _updateContentInset];
    }
}

- (void)setDataSource:(id<NGCardsViewDataSource>)dataSource
{
    if (self.dataSource == dataSource) {
        return;
    }
    
    _dataSource = dataSource;
    // cache the respondsToSelector values so we only need to check them once (and not on every scroll change)
    _dataSourceRespondsTo.numberOfItems = [dataSource respondsToSelector:@selector(numberOfItemsInCardsView:)];
    _dataSourceRespondsTo.cardSize = [dataSource respondsToSelector:@selector(cardSizeInCardsView:)];
    _dataSourceRespondsTo.cardContent = [dataSource respondsToSelector:@selector(cardsView:contentViewForCardAtIndex:)];
    [self _updateContentInset];
}

- (void)setDelegate:(id<NGCardsViewDelegate>)delegate
{
    if (self.delegate == delegate) {
        return;
    }
    
    _delegate = delegate;
    // cache the respondsToSelector values so we only need to check them once (and not on every scroll change)
    _delegateRespondsTo.reuseCard = [delegate respondsToSelector:@selector(cardsView:reuseCardContentView:)];
    _delegateRespondsTo.didScroll = [delegate respondsToSelector:@selector(cardsView:didScrollFromIndex:toIndex:progress:)];
    _delegateRespondsTo.delete = [delegate respondsToSelector:@selector(cardsView:deleteCardAtIndex:)];
    _delegateRespondsTo.didFinishDelete = [delegate respondsToSelector:@selector(cardsViewDidFinishDelete:)];
    _delegateRespondsTo.didSelect = [delegate respondsToSelector:@selector(cardsView:didSelectCardAtIndex:)];
    _delegateRespondsTo.didVerticalScroll = [delegate respondsToSelector:@selector(cardsView:didScrollCradVerticallyAtIndex:progress:)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = [self _collectionViewFrame];
}

- (void)scrollToCardAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index >= [self _numberOfCards]) {
        return;
    }
    [self.collectionView layoutIfNeeded];
    UICollectionViewLayoutAttributes *layoutAttributes = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    CGPoint offset = CGPointMake(layoutAttributes.center.x - CGRectGetWidth(self.collectionView.bounds)/2.0, 0.0);
    [self.collectionView setContentOffset:offset animated:animated];
}

- (void)setVerticalOffsetProgress:(CGFloat)verticalOffsetProgress toCardAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index >= [self _numberOfCards]) {
        return;
    }
    NGCardsCollectionViewCell *cell = (id)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [cell setVerticalOffsetProgress:verticalOffsetProgress animated:animated];
}

- (NSUInteger)selectedCardIndex
{
    return [self _rawPageIndex];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self _numberOfCards];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NGCardsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NGCardsCollectionViewCell class]) forIndexPath:indexPath];
    if (self.dataSourceRespondsTo.cardContent) {
        cell.cardContentView = [self.dataSource cardsView:self contentViewForCardAtIndex:indexPath.item];         
    }
    cell.cardDelegate = self;
    cell.allowsDeletion = (self.allowsDeletion && self.delegateRespondsTo.delete);
    cell.deleteActionString = self.deleteActionString;
    cell.deleteActionImage = self.deleteActionImage;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if (self.delegateRespondsTo.didSelect) {
        [self.delegate cardsView:self didSelectCardAtIndex:indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NGCardsCollectionViewCell *cardCell = (NGCardsCollectionViewCell *)cell;
    [cardCell setVerticalOffsetProgress:0.0 animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.delegateRespondsTo.didSelect) {
        [self.delegate cardsView:self didSelectCardAtIndex:(NSInteger)[self _rawPageIndex]];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.delegateRespondsTo.didScroll)
    {
        NSUInteger page = (NSUInteger)[self _rawPageIndex];
        [self.delegate cardsView:self didScrollFromIndex:page toIndex:page progress:1.0];
    }
    for (NGCardsCollectionViewCell *cell in [self.collectionView visibleCells]) {
        [cell setVerticalOffsetProgress:0.0 animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (CGSizeEqualToSize(CGSizeZero, self.collectionView.contentSize)) {
        return;
    }
    [self _updateCellsTransformAndAlpha];
    [self _notifyDelegateAboutScrollChange];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    for (NGCardsCollectionViewCell *cell in [self.collectionView visibleCells]) {
        [cell setVerticalOffsetProgress:0.0 animated:YES];
    }
}


#pragma mark - NGCardsCollectionViewCellDelegate

- (void)cardCell:(NGCardsCollectionViewCell *)cell didVerticalScrollWithRatio:(CGFloat)progress
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath) {
        if (self.delegateRespondsTo.didVerticalScroll) {
            [self.delegate cardsView:self didScrollCradVerticallyAtIndex:[indexPath item] progress:progress];
        }
    }
}

- (void)cardCellDidDelete:(NGCardsCollectionViewCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (!self.delegateRespondsTo.delete || indexPath == nil) {
        // the delegate MUST update the data model before deletion, otherwise the collection view will be very SAD!
        return;
    }
    [self.delegate cardsView:self deleteCardAtIndex:[indexPath item]];
    self.cardsLayout.deleting = YES;
    [self.cardsLayout invalidateLayout];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        self.cardsLayout.deleting = NO;
        [UIView animateWithDuration:(finished? 0.2 : 0.0) animations:^{
            [self _updateCellsTransformAndAlpha];
        }];
        if (self.delegateRespondsTo.didFinishDelete) {
            [self.delegate cardsViewDidFinishDelete:self];
        }
    }];
}

- (void)cardCellPrepareForReuse:(NGCardsCollectionViewCell *)cell
{
    UIView *contentCard = cell.cardContentView;
    cell.cardContentView = nil;
    if (contentCard && self.delegateRespondsTo.reuseCard) {
        [self.delegate cardsView:self reuseCardContentView:contentCard];
    }
}


#pragma mark - Internal 

- (CGSize)_itemSize
{
    CGSize size = CGSizeMake(1, 1);
    if (self.dataSourceRespondsTo.cardSize)
    {
        size = [self.dataSource cardSizeInCardsView:self];
    }
    return size;
}

- (CGRect)_collectionViewFrame
{
    CGRect bounds = self.bounds;
    CGSize itemSize = [self _itemSize];
    CGFloat topPadding = (CGRectGetHeight(bounds) -  itemSize.height) / 2.0;
    
    CGRect collectionViewFrame = bounds;
    collectionViewFrame.origin.y = topPadding;
    collectionViewFrame.size.height = itemSize.height;
    return CGRectIntegral(collectionViewFrame);
}

- (void)_notifyDelegateAboutScrollChange
{
    NSUInteger numberOfCards = [self _numberOfCards];
    if (numberOfCards == 0) {
        return;
    }
    CGFloat offsetXDiff = self.collectionView.contentOffset.x - self.lastContentOffset.x;
    self.lastContentOffset = self.collectionView.contentOffset;
    
    if (self.delegateRespondsTo.didScroll) {
        BOOL pagingForward = offsetXDiff > 0;
        NSUInteger numberOfCards = [self _numberOfCards];
        NSUInteger currentPage = pagingForward? floor([self _rawPageIndex]) : ceil([self _rawPageIndex]);
        NSUInteger nextPage = currentPage;
        if ( offsetXDiff > 0 ) {
            nextPage = MIN(numberOfCards - 1, (currentPage + 1));
        } else if ( offsetXDiff < 0 ) {
            nextPage = MAX(0, currentPage - 1);
        }
        
        CGFloat progress = [self.cardsLayout progressForItemAtIndex:[NSIndexPath indexPathForItem:nextPage inSection:0]];
        if (progress > 0.0) {
            [self.delegate cardsView:self didScrollFromIndex:currentPage toIndex:nextPage progress:progress];
            
            NGCardsCollectionViewCell *previousCell = (id)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0]];
            CGFloat updatedVerticalProgress = (1.0 - progress);
            if (currentPage != nextPage && updatedVerticalProgress < [previousCell verticalOffsetProgress]) {
                [previousCell setVerticalOffsetProgress:updatedVerticalProgress animated:NO];
            }
        }
    }
}

- (NSUInteger)_numberOfCards
{
    NSUInteger numberOfItems = 0;
    if (_dataSourceRespondsTo.numberOfItems) {
        numberOfItems = [self.dataSource numberOfItemsInCardsView:self];
    }
    return numberOfItems;
}


- (CGFloat)_rawPageIndex
{
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    CGFloat page = (self.collectionView.contentOffset.x + contentInset.left) / self.cardsLayout.cardWidth;
    return page;
}

- (void)_updateCellsTransformAndAlpha
{
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        UICollectionViewLayoutAttributes *attributes = [self.cardsLayout layoutAttributesForItemAtIndexPath:indexPath];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        [cell applyLayoutAttributes:attributes];
    }
}

- (void)_updateContentInset
{
    CGSize itemSize = [self _itemSize];
    [self.cardsLayout setItemSize:itemSize];
    
    CGFloat inset = ceil((self.bounds.size.width - itemSize.width) / 2.0);
    [self.collectionView setContentInset:UIEdgeInsetsMake(0.0, inset, 0.0, inset)];
    self.lastContentOffset = [self.collectionView contentOffset];
    [self.cardsLayout invalidateLayout];
    [self setNeedsLayout];
}

@end
