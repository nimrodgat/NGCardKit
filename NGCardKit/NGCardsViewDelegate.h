//
//  NGCardsViewDelegate.h
//  NGCardKit
//
//  Created by Nim Gat on 1/8/17.
//  Copyright © 2017 Nim Gat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NGCardsView;

@protocol NGCardsViewDelegate <NSObject>

@optional

- (void)cardsView:(NGCardsView *)cardsView reuseCardContentView:(UIView *)card;
- (void)cardsView:(NGCardsView *)cardsView didScrollFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex progress:(CGFloat)toProgress;
- (void)cardsView:(NGCardsView *)cardsView deleteCardAtIndex:(NSUInteger)index;
- (void)cardsViewDidFinishDelete:(NGCardsView *)cards;
- (void)cardsView:(NGCardsView *)cardsView didSelectCardAtIndex:(NSUInteger)index;
- (void)cardsView:(NGCardsView *)cardsView didScrollCradVerticallyAtIndex:(NSUInteger)index progress:(CGFloat)verticalScrollProgress;
@end

NS_ASSUME_NONNULL_END
