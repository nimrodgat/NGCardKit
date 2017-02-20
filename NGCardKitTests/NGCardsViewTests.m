//
//  NGCardKitTests.m
//  NGCardKitTests
//
//  Created by Nim Gat on 12/25/16.
//  Copyright © 2016 - 2017 Nim Gat. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NGCardsViewMockDataSource.h"

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

#import <NGCardKit/NGCardKit.h>

@interface NGCardsViewTests : FBSnapshotTestCase

@property (nonatomic) NGCardsView *cardsView;
@property (nonatomic) NGCardsViewMockDataSource *dataSource;

@end

@implementation NGCardsViewTests

- (void)setUp {
    [super setUp];
    
    self.cardsView = [[NGCardsView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 568.0)];
    self.cardsView.backgroundColor = [UIColor blackColor];
    self.dataSource = [[NGCardsViewMockDataSource alloc] init];
    self.cardsView.dataSource = self.dataSource;
    
    self.recordMode = NO;
}

- (void)testSingleCard
{
    self.dataSource.numberOfCards = 1;
    [self.cardsView reloadData];
    FBSnapshotVerifyView(self.cardsView, nil);
    XCTAssert(self.cardsView.selectedCardIndex == 0);
}

- (void)testTwoCards
{
    self.dataSource.numberOfCards = 2;
    [self.cardsView reloadData];
    FBSnapshotVerifyView(self.cardsView, nil);
}


- (void)testHorizontalScrolling
{
    self.dataSource.numberOfCards = 10;
    [self.cardsView reloadData];
    
    [self.cardsView scrollToCardAtIndex:3 animated:NO];
    FBSnapshotVerifyView(self.cardsView, @"index-3");
    XCTAssert(self.cardsView.selectedCardIndex == 3);
    
    [self.cardsView scrollToCardAtIndex:9 animated:NO];
    FBSnapshotVerifyView(self.cardsView, @"index-9");
    XCTAssert(self.cardsView.selectedCardIndex == 9);
    
    [self.cardsView scrollToCardAtIndex:0 animated:NO];
    FBSnapshotVerifyView(self.cardsView, @"index-0");
    XCTAssert(self.cardsView.selectedCardIndex == 0);
}

- (void)testVerticalScrolling
{
    self.dataSource.numberOfCards = 3;
    self.cardsView.allowsDeletion = YES;
    [self.cardsView reloadData];
    [self.cardsView layoutIfNeeded];
    
    [self.cardsView setVerticalOffsetProgress:0.5 toCardAtIndex:0 animated:NO];
    FBSnapshotVerifyView(self.cardsView, @"0.5");
    
    [self.cardsView setVerticalOffsetProgress:0.75 toCardAtIndex:0 animated:NO];
    FBSnapshotVerifyView(self.cardsView, @"0.75");
    
    [self.cardsView setVerticalOffsetProgress:1.0 toCardAtIndex:0 animated:NO];
    FBSnapshotVerifyView(self.cardsView, @"1.0");


}




@end
