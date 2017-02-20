//
//  CKSWeatherDataModel.m
//  CardsKitSample
//
//  Created by Nim Gat on 12/27/16.
//  Copyright © 2016 Nim Gat. All rights reserved.
//

#import "CKSWeatherDataModel.h"

@implementation CKSWeatherDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        NSDictionary *observationDictionary = dictionary[@"currentobservation"];
        if ([observationDictionary isKindOfClass:[NSDictionary class]]) {
            NSString *name = observationDictionary[@"name"];
            if ([name isKindOfClass:[NSString class]]) {
                _name = [name copy];
            }
            
            NSString *tempValue = observationDictionary[@"Temp"];
            if ([tempValue isKindOfClass:[NSString class]]) {
                _temperature = tempValue.floatValue;                
            }
        }
    }
    return self;
}

@end
