//
//  NGCardsViewDataSource.h
//  NGCardKit
//
//  Created by Nim Gat on 1/8/17.
//  Copyright © 2017 Nim Gat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NGCardsView;

@protocol NGCardsViewDataSource <NSObject>

@optional

- (NSUInteger)numberOfItemsInCardsView:(NGCardsView *)cardsView;
- (CGSize)cardSizeInCardsView:(NGCardsView *)cardsView;
- (UIView *)cardsView:(NGCardsView *)cardsView contentViewForCardAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
