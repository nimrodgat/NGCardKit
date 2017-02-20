//
//  NGCardsViewMockDataSource.h
//  NGCardKit
//
//  Created by Nim Gat on 1/22/17.
//  Copyright © 2017 Nim Gat. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <NGCardKit/NGCardKit.h>

@interface NGCardsViewMockDataSource : NSObject <NGCardsViewDataSource>

@property (nonatomic, assign) NSUInteger numberOfCards;

@end
