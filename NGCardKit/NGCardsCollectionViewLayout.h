//
//  NGCardsCollectionViewLayout.h
//  NGCardKit
//
//  Created by Nim Gat on 12/25/16.
//  Copyright © 2016 - 2017 Nim Gat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGCardsCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat minimumAlphaValue;
@property (nonatomic, assign) CGFloat minimumScaleValue;
@property (nonatomic, readonly) CGFloat cardWidth;
@property (nonatomic, assign, getter=isDeleting) BOOL deleting;

- (CGFloat)progressForItemAtIndex:(nonnull NSIndexPath *)indexPath;

@end
