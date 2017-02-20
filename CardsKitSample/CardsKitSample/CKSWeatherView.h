//
//  CKSWeatherView.h
//  CardsKitSample
//
//  Created by Nim Gat on 12/27/16.
//  Copyright © 2016 Nim Gat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CKSWeatherDataModel.h"

@interface CKSWeatherView : UIView

- (void)updateWithWeatherModel:(CKSWeatherDataModel *)weatherModel;

@end
