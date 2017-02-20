//
//  UIColor+Blending.m
//  CardsKitSample
//
//  Created by Nim Gat on 12/28/16.
//  Copyright © 2016 Nim Gat. All rights reserved.
//

#import "UIColor+Blending.h"

@implementation UIColor (Blending)

- (nonnull UIColor *)blendWithColor:(nonnull UIColor *)otherColor ratio:(CGFloat)ratio
{
    CGFloat selfRed,selfGreen, selfBlue, selfAlpha;
    CGFloat otherRed,otherGreen, otherBlue, otherAlpha;
    [self getRed:&selfRed green:&selfGreen blue:&selfBlue alpha:&selfAlpha];
    [otherColor getRed:&otherRed green:&otherGreen blue:&otherBlue alpha:&otherAlpha];
    
    CGFloat otherRatio = MAX(MIN(ratio, 1.0), 0.0);
    CGFloat selfRatio = 1.0 - otherRatio;
    
    
    CGFloat red = (selfRed * selfRatio) + (otherRed * otherRatio);
    CGFloat green = (selfGreen * selfRatio) + (otherGreen * otherRatio);
    CGFloat blue = (selfBlue * selfRatio) + (otherBlue * otherRatio);
    CGFloat alpha = (selfAlpha * selfRatio) + (otherAlpha * otherRatio);
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
