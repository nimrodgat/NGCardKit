//
//  CardsKitSampleTests.m
//  CardsKitSampleTests
//
//  Created by Nim Gat on 1/22/17.
//  Copyright © 2017 Nim Gat. All rights reserved.
//

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

#import "CKSViewController_Private.h"

@interface CardsKitSampleTests : FBSnapshotTestCase

@property (nonatomic) CKSViewController *viewController;
@property (nonatomic) NSMutableArray *models;

@end

@implementation CardsKitSampleTests

- (void)setUp
{
    [super setUp];
    
    self.viewController = [[CKSViewController alloc] init];
    self.viewController.view.frame = CGRectMake(0.0, 0.0, 320, 568.0);
    
    CKSWeatherDataModel *brooklyn = [self _newModelWithName:@"Brooklyn, NY" temperature:15.0];
    CKSWeatherDataModel *sanFrancisco = [self _newModelWithName:@"San Francisco, CA" temperature:45.0];
    CKSWeatherDataModel *telAviv = [self _newModelWithName:@"Tel Aviv, IL" temperature:65.0];
    
    self.models = [@[brooklyn, sanFrancisco, telAviv] mutableCopy];

    self.recordMode = NO;
}

- (void)testSingleCard
{
    [self.viewController setWeatherModels:[@[[self.models firstObject]] mutableCopy]];
    FBSnapshotVerifyView(self.viewController.view, nil);
}

- (void)testTwoCards
{
    [self.viewController setWeatherModels:[[self.models subarrayWithRange:NSMakeRange(0, 2)] mutableCopy]];
    FBSnapshotVerifyView(self.viewController.view, nil);
}

- (void)testThreeCards
{
    [self.viewController setWeatherModels:self.models];
    [self.viewController.view layoutIfNeeded];
    [self.viewController scrollToCardAtIndex:2 animated:NO];
    FBSnapshotVerifyView(self.viewController.view, nil);
    
    [self.viewController scrollToCardAtIndex:1 animated:NO];
    FBSnapshotVerifyView(self.viewController.view, @"middle-card");
}

- (CKSWeatherDataModel *)_newModelWithName:(NSString *)name temperature:(CGFloat)temperature
{
    CKSWeatherDataModel *model = [[CKSWeatherDataModel alloc] init];
    [model setValue:name forKey:NSStringFromSelector(@selector(name))];
    [model setValue:@(temperature) forKey:NSStringFromSelector(@selector(temperature))];
    
    return model;
}


@end
