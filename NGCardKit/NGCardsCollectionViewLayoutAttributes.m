//
//  NGCardsCollectionViewLayoutAttributes.m
//  NGCardKit
//
//  Created by Nim Gat on 12/26/16.
//  Copyright © 2016 - 2017 Nim Gat. All rights reserved.
//

#import "NGCardsCollectionViewLayoutAttributes.h"

@implementation NGCardsCollectionViewLayoutAttributes

- (id)copyWithZone:(NSZone *)zone
{
    NGCardsCollectionViewLayoutAttributes *layoutAttributes = [super copyWithZone:zone];
    layoutAttributes.highlightProgress = self.highlightProgress;
    return layoutAttributes;
}

- (BOOL)isEqual:(id)object
{
    if (object == nil || ![object isKindOfClass:[self class]])
    {
        return NO;
    }
    
    NGCardsCollectionViewLayoutAttributes *layoutAttributes = (NGCardsCollectionViewLayoutAttributes *)object;
    BOOL isEqual =  ([super isEqual:object] && layoutAttributes.highlightProgress == self.highlightProgress);
    return isEqual;
}

- (NSUInteger)hash
{
    return [super hash] ^ (int)self.highlightProgress;
}

@end
