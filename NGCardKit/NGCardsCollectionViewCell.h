//
//  NGCardsCollectionViewCell.h
//  NGCardKit
//
//  Created by Nim Gat on 12/25/16.
//  Copyright © 2016 - 2017 Nim Gat. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NGCardsCollectionViewCellDelegate;

@interface NGCardsCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) CGFloat highlightProgress;

@property (nonatomic, assign) CGFloat verticalOffsetProgress;
- (void)setVerticalOffsetProgress:(CGFloat)verticalOffsetProgress animated:(BOOL)animated;

@property (nonatomic, nullable, strong) UIView *cardContentView;

@property (nonatomic, assign) BOOL allowsDeletion;
@property (nonatomic, nullable, copy) NSAttributedString *deleteActionString;
@property (nonatomic, nullable, strong) UIImage *deleteActionImage;

@property (nonatomic, nullable, weak) id<NGCardsCollectionViewCellDelegate> cardDelegate;

@end


@protocol NGCardsCollectionViewCellDelegate <NSObject>
@optional
- (void)cardCell:(nonnull NGCardsCollectionViewCell *)cell didVerticalScrollWithRatio:(CGFloat)progress;
- (void)cardCellDidDelete:(nonnull NGCardsCollectionViewCell *)cell;
- (void)cardCellPrepareForReuse:(nonnull NGCardsCollectionViewCell *)cell;
@end
