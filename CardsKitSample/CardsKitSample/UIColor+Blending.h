//
//  UIColor+Blending.h
//  CardsKitSample
//
//  Created by Nim Gat on 12/28/16.
//  Copyright © 2016 Nim Gat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Blending)

- (nonnull UIColor *)blendWithColor:(nonnull UIColor *)color ratio:(CGFloat)ratio;

@end
