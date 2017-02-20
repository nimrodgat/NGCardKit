//
//  CKSWeatherService.h
//  CardsKitSample
//
//  Created by Nim Gat on 12/29/16.
//  Copyright © 2016 Nim Gat. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CKSWeatherDataModel.h"

@interface CKSWeatherService : NSObject

+ (void)fetchObservationDataForIDs:( NSArray<NSString *>* _Nonnull )locationIDs completionBlock:(void (^ __nullable)( NSArray<CKSWeatherDataModel *>* _Nullable  locationsData))completion;

@end
