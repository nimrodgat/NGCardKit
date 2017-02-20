//
//  CKSViewController_Private.h
//  CardsKitSample
//
//  Created by Nim Gat on 1/22/17.
//  Copyright © 2017 Nim Gat. All rights reserved.
//

#import "CKSViewController.h"

#import "CKSWeatherDataModel.h"

@interface CKSViewController (Private)

- (void)setWeatherModels:(NSMutableArray<CKSWeatherDataModel *> *)weatherModels;
- (void)scrollToCardAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end
