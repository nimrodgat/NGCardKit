//
//  CKSViewController.m
//  CardsKitSample
//
//  Created by Nim Gat on 12/26/16.
//  Copyright © 2016 Nim Gat. All rights reserved.
//

#import "CKSViewController.h"
#import "CKSViewController_Private.h"

#import "CKSGradientView.h"
#import "CKSWeatherDataModel.h"
#import "CKSWeatherView.h"
#import "CKSWeatherService.h"

#import "UIColor+Blending.h"
#import "UIColor+Temperature.h"

#import <NGCardKit/NGCardKit.h>

@interface CKSViewController () <NGCardsViewDelegate, NGCardsViewDataSource>

@property (nonatomic, strong) CKSGradientView *gradientView;
@property (nonatomic, strong) UIColor *gradientMainColor;
@property (nonatomic, strong) NGCardsView *cardsView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSMutableSet <CKSWeatherView *>*contentViews;
@property (nonatomic, strong) NSMutableArray <CKSWeatherDataModel *> *weatherModels;

@end

@implementation CKSViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _contentViews = [[NSMutableSet alloc] init];
        self.title = @"My Weather";
    }
    return self;
}


- (void)loadView
{
    self.gradientView = [[CKSGradientView alloc] init];
    self.gradientView.backgroundColor = [UIColor blackColor];
    self.gradientView.CGColors = @[(id)[UIColor grayColor].CGColor, (id)[UIColor blackColor].CGColor];
    self.view = self.gradientView;

    /// IMPORTANT:
    /// `NGCardsView` handles scrolling & content offset on its own, this will prevent UIKit from getting in the way
    self.automaticallyAdjustsScrollViewInsets = NO;
    ///
    
    self.cardsView = [[NGCardsView alloc] init];
    self.cardsView.delegate = self;
    self.cardsView.dataSource = self;
    self.cardsView.allowsDeletion = YES;
    
    [self.view addSubview:self.cardsView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.activityIndicatorView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self _fetchData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    self.cardsView.frame = bounds;
    self.activityIndicatorView.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

- (void)setWeatherModels:(NSMutableArray<CKSWeatherDataModel *> *)weatherModels
{
    _weatherModels = weatherModels;
    [self.cardsView reloadData];
    [self _updateGradientBackgroundWithSelectedCard];
}

- (void)scrollToCardAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    [self.cardsView scrollToCardAtIndex:index animated:animated];
    [self _updateGradientBackgroundWithSelectedCard];
}

#pragma mark -NGCardsViewDelegate

- (void)cardsView:(NGCardsView *)cardsView didScrollCradVerticallyAtIndex:(NSUInteger)index progress:(CGFloat)verticalScrollProgress
{
    BOOL shouldHideNavigationBar = (verticalScrollProgress > 0.1);
    if (shouldHideNavigationBar != self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:shouldHideNavigationBar animated:YES];
    }
}

- (void)cardsView:(NGCardsView *)cardsView reuseCardContentView:(UIView *)card;
{
    [self.contentViews addObject:(CKSWeatherView *)card];
}

- (void)cardsView:(NGCardsView *)cardsView deleteCardAtIndex:(NSUInteger)index
{
    [self.weatherModels removeObjectAtIndex:index];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)cardsViewDidFinishDelete:(NGCardsView *)cardsView
{
    [self _updateGradientBackgroundWithSelectedCard];
}

- (void)cardsView:(NGCardsView *)cardsView didScrollFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex progress:(CGFloat)toProgress
{
    if (fromIndex < self.weatherModels.count && toIndex < self.weatherModels.count) {
        CKSWeatherDataModel *fromModel = self.weatherModels[fromIndex];
        CKSWeatherDataModel *toModel = self.weatherModels[toIndex];
        UIColor *fromColor = [UIColor colorWithTemperature:fromModel.temperature];
        UIColor *toColor = [UIColor colorWithTemperature:toModel.temperature];
        self.gradientMainColor = [fromColor blendWithColor:toColor ratio:toProgress];
    }
}

#pragma mark - NGCardsDataSource

- (NSUInteger)numberOfItemsInCardsView:(NGCardsView *)cardsView
{
    return self.weatherModels.count;
}

- (CGSize)cardSizeInCardsView:(NGCardsView *)cardsView
{
    return CGSizeMake(240.0, 420.0);;
}

- (UIView *)cardsView:(NGCardsView *)cardsView contentViewForCardAtIndex:(NSUInteger)index
{
    CKSWeatherView *contentView = [self _dequeueContentView];
    CKSWeatherDataModel *model = self.weatherModels[index];
    [contentView updateWithWeatherModel:model];
    return contentView;
}

#pragma mark - internal 

- (void)_fetchData
{
    [self.activityIndicatorView startAnimating];
    [CKSWeatherService fetchObservationDataForIDs:@[@"NYZ072",@"TXZ192",@"WYZ013",@"AZZ006",@"AZZ028"] completionBlock:^(NSArray<CKSWeatherDataModel *> * _Nullable locationsData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.weatherModels = [locationsData mutableCopy];
            [self.activityIndicatorView stopAnimating];
        });
    }];
}

- (void)_updateGradientBackgroundWithSelectedCard
{
    NSUInteger selectedCardIndex = self.cardsView.selectedCardIndex;
    if (selectedCardIndex < self.weatherModels.count) {
        CKSWeatherDataModel *model = self.weatherModels[selectedCardIndex];
        [self setGradientMainColor:[UIColor colorWithTemperature:model.temperature] animated:YES];
    }
}

- (CKSWeatherView *)_dequeueContentView
{
    CKSWeatherView *contentView = nil;
    if (self.contentViews.count == 0) {
        contentView = [[CKSWeatherView alloc] init];
    } else {
        contentView = self.contentViews.anyObject;
        [self.contentViews removeObject:contentView];
    }
    return contentView;
}

- (void)setGradientMainColor:(UIColor *)gradientMainColor
{
    [self setGradientMainColor:gradientMainColor animated:NO];
}

- (void)setGradientMainColor:(UIColor *)gradientMainColor animated:(BOOL)animated
{
    if ([_gradientMainColor isEqual:gradientMainColor]) {
        return;
    }
    
    _gradientMainColor = gradientMainColor;
    
    UIColor *gradientColor1 = [gradientMainColor colorWithAlphaComponent:0.15];
    UIColor *gradientColor2 = gradientMainColor;
    NSArray *CGColors = @[(id)gradientColor2.CGColor, (id)gradientColor1.CGColor];
    
    [self.gradientView setCGColors:CGColors animated:animated];
}

@end
