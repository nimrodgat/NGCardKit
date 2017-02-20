//
//  NGCardsViewMockDataSource.m
//  NGCardKit
//
//  Created by Nim Gat on 1/22/17.
//  Copyright © 2017 Nim Gat. All rights reserved.
//

#import "NGCardsViewMockDataSource.h"

@implementation NGCardsViewMockDataSource

- (NSUInteger)numberOfItemsInCardsView:(NGCardsView *)cardsView
{
    return self.numberOfCards;
}

- (CGSize)cardSizeInCardsView:(NGCardsView *)cardsView
{
    return CGSizeMake(150, 300);
}

- (UIView *)cardsView:(NGCardsView *)cardsView contentViewForCardAtIndex:(NSUInteger)index
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:75.0];
    label.text = [@(index) stringValue];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = (index % 2 == 0)? [UIColor blueColor] : [UIColor magentaColor];
    return label;    
}

@end
