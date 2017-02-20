//
//  CKSWeatherView.m
//  CardsKitSample
//
//  Created by Nim Gat on 12/27/16.
//  Copyright © 2016 Nim Gat. All rights reserved.
//

#import "CKSWeatherView.h"

@interface CKSWeatherView ()

@property (nonatomic, strong) UILabel *locationTileLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UIStackView *contentStackView;

@end

@implementation CKSWeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:245.0/255.0 alpha:1.0];
        
        _locationTileLabel = [[UILabel alloc] init];
        _locationTileLabel.numberOfLines = 4;
        _locationTileLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _locationTileLabel.font = [UIFont systemFontOfSize:45.0 weight:UIFontWeightThin];
        
        _temperatureLabel = [[UILabel alloc] init];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel.font = [UIFont systemFontOfSize:70.0 weight:UIFontWeightSemibold];
        
        _contentStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_locationTileLabel, _temperatureLabel]];
        _contentStackView.axis = UILayoutConstraintAxisVertical;
        _contentStackView.distribution = UIStackViewDistributionEqualSpacing;
        
        [self addSubview:_contentStackView];
        
        self.layer.cornerRadius = 6.0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentStackView.frame = CGRectInset(self.bounds, 20.0, 20.0);
}

- (void)updateWithWeatherModel:(CKSWeatherDataModel *)weatherModel
{
    self.locationTileLabel.text = weatherModel.name;
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.0f ℉",weatherModel.temperature];
}


@end
