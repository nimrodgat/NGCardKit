//
//  CKSGradientView.h
//  CardsKitSample
//
//  Created by Nim Gat on 12/28/16.
//  Copyright © 2016 Nim Gat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKSGradientView : UIView

@property (nonatomic, copy) NSArray *CGColors;
- (void)setCGColors:(NSArray *)CGColors animated:(BOOL)animated;

@end
