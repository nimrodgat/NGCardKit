//
//  CKSWeatherDataModel.h
//  CardsKitSample
//
//  Created by Nim Gat on 12/27/16.
//  Copyright © 2016 Nim Gat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CKSWeatherDataModel : NSObject


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) CGFloat temperature;



@end
