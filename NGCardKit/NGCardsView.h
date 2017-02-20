//
//  NGCardsView.h
//  NGCardKit
//
//  Created by Nim Gat on 12/25/16.
//  Copyright © 2016 - 2017 Nim Gat. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NGCardsViewDataSource, NGCardsViewDelegate;

@interface NGCardsView : UIView


@property (nonatomic, nullable, weak) id<NGCardsViewDelegate> delegate;
@property (nonatomic, nullable, weak) id<NGCardsViewDataSource> dataSource;

@property (nonatomic, readonly) NSUInteger selectedCardIndex;

@property (nonatomic, assign) BOOL allowsDeletion; // when set to YES, it will be possible to swipe up cards to delete them

@property (nonatomic, nullable, copy) NSAttributedString *deleteActionString; // default is "Delete" (system font 30.0, white)
@property (nonatomic, nullable, strong) UIImage *deleteActionImage; // image to use for the delete button. Default is nil

- (void)scrollToCardAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setVerticalOffsetProgress:(CGFloat)verticalOffsetProgress toCardAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)reloadData;

@end
