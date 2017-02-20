//
//  CKSGradientView.m
//  CardsKitSample
//
//  Created by Nim Gat on 12/28/16.
//  Copyright © 2016 Nim Gat. All rights reserved.
//

#import "CKSGradientView.h"

@interface CKSGradientView ()

@property (nonatomic, readonly) CAGradientLayer *gradientLayer;

@end

@implementation CKSGradientView

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer
{
    return (CAGradientLayer *)self.layer;
}

- (void)setCGColors:(NSArray *)CGColors
{
    [self setCGColors:CGColors animated:NO];
}

- (void)setCGColors:(NSArray *)CGColors animated:(BOOL)animated
{
    [self.gradientLayer removeAllAnimations];
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(colors))];
        animation.fromValue = self.gradientLayer.colors;
        animation.toValue = CGColors;
        animation.duration = 0.2;
        
        self.gradientLayer.colors = CGColors;
        [self.gradientLayer addAnimation:animation forKey:@"gradient-colors"];
    } else {
        self.gradientLayer.colors = CGColors;
    }
}

- (NSArray *)CGColors
{
    return self.gradientLayer.colors;
}

@end
