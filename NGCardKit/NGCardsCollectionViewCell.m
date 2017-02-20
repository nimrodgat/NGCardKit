//
//  NGCardsCollectionViewCell.m
//  NGCardKit
//
//  Created by Nim Gat on 12/25/16.
//  Copyright © 2016 - 2017 Nim Gat. All rights reserved.
//

#import "NGCardsCollectionViewCell.h"

#import "NGCardsCollectionViewLayoutAttributes.h"

typedef struct {
    unsigned int prepareForReuse:1;
    unsigned int didDelete:1;
    unsigned int didScroll:1;
    
} NGCardCellDelegateRespondsTo;


CGFloat const NGCardsCollectionViewCellRatioDeletePossible = 1.28;
CGFloat const NGCardsCollectionViewCellRatioDeleteAction = 2.35;

@interface NGCardsCollectionViewCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *verticalScrollView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) NGCardCellDelegateRespondsTo delegateRespondsTo;
@property (nonatomic, assign) BOOL deleting;

@end

@implementation NGCardsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _verticalScrollView = [[UIScrollView alloc] init];
        _verticalScrollView.showsVerticalScrollIndicator = NO;
        _verticalScrollView.clipsToBounds = NO;
        _verticalScrollView.delegate = self;
        _verticalScrollView.userInteractionEnabled = NO;
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];        
        [_deleteButton addTarget:self action:@selector(_deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.alpha = 0.0;
        _deleteButton.layer.zPosition = -1; // let the button appear behind the `cardContentView`
        
        [[self contentView] addSubview:_verticalScrollView];
        [[self contentView] addSubview:_deleteButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect contentViewBounds = self.contentView.bounds;
    if (!CGRectEqualToRect(contentViewBounds, self.verticalScrollView.frame)) {
        self.verticalScrollView.frame = contentViewBounds;
        [self _updateScrollViewContentSize];
    }
    self.cardContentView.frame = self.verticalScrollView.bounds;
    self.deleteButton.center = CGPointMake(CGRectGetMidX(contentViewBounds), CGRectGetHeight(contentViewBounds) - CGRectGetHeight(self.deleteButton.bounds));
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.deleting = NO;
    [self.verticalScrollView setContentOffset:CGPointZero animated:NO];
    if (self.delegateRespondsTo.prepareForReuse) {
        [self.cardDelegate cardCellPrepareForReuse:self];
    }
    [self.deleteButton setTransform:CGAffineTransformIdentity];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.alpha = layoutAttributes.alpha;
    self.transform = layoutAttributes.transform;
    if ([layoutAttributes isKindOfClass:[NGCardsCollectionViewLayoutAttributes class]])
    {
        self.highlightProgress = ((NGCardsCollectionViewLayoutAttributes *)layoutAttributes).highlightProgress;
    }
}

- (void)setAllowsDeletion:(BOOL)allowsDeletion
{
    self.verticalScrollView.scrollEnabled = allowsDeletion;
}

- (BOOL)allowsDeletion
{
    return self.verticalScrollView.isScrollEnabled;
}

- (void)setCardContentView:(UIView *)cardContentView
{
    if (_cardContentView != cardContentView) {
        [_cardContentView removeFromSuperview];
        _cardContentView = cardContentView;
        _cardContentView.frame = self.verticalScrollView.bounds;
        [self.verticalScrollView addSubview:_cardContentView];
        [self _updateScrollViewContentSize];
    }
}

- (void)setDeleteActionString:(NSAttributedString *)deleteActionString
{
    if (![self.deleteActionString isEqual:deleteActionString]) {
        [self.deleteButton setAttributedTitle:deleteActionString forState:UIControlStateNormal];
        [self.deleteButton sizeToFit];
        [self setNeedsLayout];
    }
}

- (NSAttributedString *)deleteActionString
{
    return [self.deleteButton attributedTitleForState:UIControlStateNormal];
}

- (UIImage *)deleteActionImage
{
    return [self.deleteButton imageForState:UIControlStateNormal];
}

- (void)setDeleteActionImage:(UIImage *)deleteActionImage
{
    if (self.deleteActionImage != deleteActionImage) {
        [self.deleteButton setImage:deleteActionImage forState:UIControlStateNormal];
        [self.deleteButton sizeToFit];
        [self setNeedsLayout];
    }    
}

- (void)setHighlightProgress:(CGFloat)highlightProgress
{
    if (self.highlightProgress != highlightProgress) {
        _highlightProgress = highlightProgress;
        self.verticalScrollView.userInteractionEnabled = (highlightProgress >= 0.99);
    }
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self _updateScrollViewContentSize];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.deleting) {
        return;
    }
    CGFloat boundsHeight = self.verticalScrollView.bounds.size.height;
    CGFloat possibleHeight = (boundsHeight * NGCardsCollectionViewCellRatioDeletePossible) - boundsHeight;
    
    if (targetContentOffset->y > boundsHeight) {
       [self _animateDeleteCardAndChangeOffset:NO];
    } else {
        targetContentOffset->y = (targetContentOffset->y < (possibleHeight / 2.0))? 0.0 : possibleHeight;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat ratio = [self verticalOffsetProgress];
    
    if (!self.deleting) {
        [self.deleteButton setAlpha:ratio];
        self.deleteButton.transform = CGAffineTransformMakeScale(ratio, ratio);
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= [self.verticalScrollView bounds].size.height) {
        if (self.delegateRespondsTo.didScroll) {
            [self.cardDelegate cardCell:self didVerticalScrollWithRatio:ratio];
        }
    }
}



#pragma mark - Private

- (void)setCardDelegate:(id<NGCardsCollectionViewCellDelegate>)cardDelegate
{
    // cache the respondsToSelector values so we only need to check them once (and not on every scroll change)
    _delegateRespondsTo.didScroll = [cardDelegate respondsToSelector:@selector(cardCell:didVerticalScrollWithRatio:)];
    _delegateRespondsTo.didDelete = [cardDelegate respondsToSelector:@selector(cardCellDidDelete:)];
    _delegateRespondsTo.prepareForReuse = [cardDelegate respondsToSelector:@selector(cardCellPrepareForReuse:)];
    _cardDelegate = cardDelegate;
}

- (void)setVerticalOffsetProgress:(CGFloat)verticalOffsetProgress
{
    [self setVerticalOffsetProgress:verticalOffsetProgress animated:NO];
}

- (void)setVerticalOffsetProgress:(CGFloat)verticalOffsetProgress animated:(BOOL)animated
{
    CGFloat boundsHeight = CGRectGetHeight(self.verticalScrollView.bounds);
    CGFloat possibleHeight = (boundsHeight * NGCardsCollectionViewCellRatioDeletePossible) - boundsHeight;
    CGFloat offsetY = verticalOffsetProgress * possibleHeight;
    [self.verticalScrollView setContentOffset:CGPointMake(0.0, offsetY) animated:animated];
    [self _updateScrollViewContentSize];
}

- (CGFloat)verticalOffsetProgress
{
    CGFloat verticalOffsetProgress = 0.0;
    CGPoint offset = self.verticalScrollView.contentOffset;
    CGFloat boundsHeight = CGRectGetHeight(self.verticalScrollView.bounds);
    CGFloat possibleHeight = (boundsHeight * NGCardsCollectionViewCellRatioDeletePossible) - boundsHeight;
    if (possibleHeight > 0) {
        verticalOffsetProgress = MAX(0.0, MIN(1.0,offset.y/possibleHeight));
    }
    return verticalOffsetProgress;
}

#pragma mark - Internal

- (void)_deleteAction:(UIControl *)sender
{
    [self _animateDeleteCardAndChangeOffset:YES];
}

- (void)_updateScrollViewContentSize
{
    if (self.deleting) {
        return;
    }
    CGRect bounds = self.verticalScrollView.bounds;
    CGFloat topOffset = self.verticalScrollView.contentOffset.y;
    CGFloat height = CGRectGetHeight(bounds);
    CGFloat phaseOneOffset = floor(height * NGCardsCollectionViewCellRatioDeletePossible) - height;
    CGFloat contentScaleFactor = (topOffset >= phaseOneOffset)? NGCardsCollectionViewCellRatioDeleteAction : NGCardsCollectionViewCellRatioDeletePossible;
    CGSize size = CGSizeMake(CGRectGetWidth(bounds), (height * contentScaleFactor));
    self.verticalScrollView.contentSize = size;
}

- (void)_animateDeleteCardAndChangeOffset:(BOOL)shouldChangeOffset
{
    self.deleting = YES;
    [UIView animateWithDuration:0.35 animations:^{
        if (shouldChangeOffset) {
            CGFloat targetOffsetY =  2.0 * self.verticalScrollView.contentSize.height;
            [self.verticalScrollView setContentOffset:CGPointMake(0.0, targetOffsetY) animated:NO];
        }
        self.deleteButton.alpha = 0.0;
        self.deleteButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        if (self.delegateRespondsTo.didDelete) {
            [self.cardDelegate cardCellDidDelete:self];
        }
    }];
}

@end
