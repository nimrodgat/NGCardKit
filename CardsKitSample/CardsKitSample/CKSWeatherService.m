//
//  CKSWeatherService.m
//  CardsKitSample
//
//  Created by Nim Gat on 12/29/16.
//  Copyright © 2016 Nim Gat. All rights reserved.
//

#import "CKSWeatherService.h"

@implementation CKSWeatherService

// probably not the most reliable web service, but it's free and doesn't require any authentication (which makes it great for a sample app!)
static NSString *const _CKSWeatherServiceBaseURL = @"http://forecast.weather.gov/MapClick.php?FcstType=json";

+ (void)fetchObservationDataForIDs:(NSArray<NSString *> *)locationIDs completionBlock:(void (^)(NSArray<CKSWeatherDataModel *> * _Nullable))completion
{
    NSMutableArray *dataModels =  [NSMutableArray arrayWithCapacity:locationIDs.count];
    
    // (very) naive way for batching multiple requests:
    __block NSInteger pendingRequests = locationIDs.count;
    NSLock *lock = [[NSLock alloc] init];
    
    for (NSString *locationID in locationIDs) {
        NSURL *url = [NSURL URLWithString:[_CKSWeatherServiceBaseURL stringByAppendingFormat:@"&zoneid=%@",locationID]];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            CKSWeatherDataModel *model = nil;
            if (data && !error) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                model = [[CKSWeatherDataModel alloc] initWithDictionary:dictionary];
            }
            [lock lock];
            if (model) {
                [dataModels addObject:model];
            }
            pendingRequests--;
            if (pendingRequests == 0) {
                NSArray <CKSWeatherDataModel *>*sortedModels = [dataModels sortedArrayUsingComparator:^NSComparisonResult(CKSWeatherDataModel *  _Nonnull obj1, CKSWeatherDataModel *  _Nonnull obj2) {
                    return [obj1.name compare:obj2.name];
                }];
                completion(sortedModels);
            }
            [lock unlock];
        }];
        [dataTask resume];
    }
}

@end
