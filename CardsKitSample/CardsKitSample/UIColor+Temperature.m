//
//  UIColor+Temperature.m
//  CardsKitSample
//
//  Created by Nim Gat on 1/2/17.
//  Copyright © 2017 Nim Gat. All rights reserved.
//

#import "UIColor+Temperature.h"

@implementation UIColor (Temperature)


+ (UIColor *)colorWithTemperature:(CGFloat)temperature
{
    // color values taken from https://openweathermap.org/map_legend
    CGFloat red = 0.0, green = 0.0, blue = 0.0;
    
    if (temperature <= -32) {
        blue = 153.0;
        
    } else if (temperature <= -25) {
        blue = 180.0;
        
    } else if (temperature <= -18) {
        blue = 223.0;
        
    } else if (temperature <= -11) {
        green = 24.0;
        blue = 254.0;
        
    } else if (temperature <= -4) {
        green = 114.0;
        blue = 254.0;
        
    } else if (temperature <= 3) {
        green = 173.0;
        blue = 254.0;
        
    } else if (temperature <= 10) {
        green = 238.0;
        blue = 254.0;
        
    } else if (temperature <= 17) {
        red = 43.0;
        green = 254.0;
        blue = 211.0;
        
    } else if (temperature <= 24) {
        red = 103.0;
        green = 254.0;
        blue = 151.0;
        
    } else if (temperature <= 32) {
        red = 155.0;
        green = 254.0;
        blue = 99.0;
        
    } else if (temperature <= 39) {
        red = 211.0;
        green = 254.0;
        blue = 43.0;
        
    } else if (temperature <= 46) {
        red = 254.0;
        green = 243.0;
        
    } else if (temperature <= 53) {
        red = 254.0;
        green = 183.0;
        
    } else if (temperature <= 68) {
        red = 254.0;
        green = 75.0;
        
    } else if (temperature <= 75) {
        red = 254.0;
        green = 23.0;
        
    } else if (temperature <= 82) {
        red = 220.0;
        
    } else if (temperature <= 90) {
        red = 173.0;
        
    } else if (temperature <= 96) {
        red = 254.0;
    } else {
        red = 255.0;
    }
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

@end
