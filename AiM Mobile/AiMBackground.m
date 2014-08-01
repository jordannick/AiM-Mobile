//
//  AiMBackground.m
//  AiM Mobile
//
//  Created by norredm on 7/24/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMBackground.h"

@implementation AiMBackground

//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.85 alpha:1.0];
    UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.7 alpha:1.0];
    UIColor *colorFour = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.4 alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.02];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.99];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

//Blue gradient background
+ (CAGradientLayer*) blueGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(187/255.0) green:(242/255.0) blue:(250/255.0) alpha:1.0];
//    UIColor *colorTwo = [UIColor colorWithRed:(100/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(176/255.0) green:(217/255.0) blue:(223/255.0) alpha:.8];

    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

+ (CAGradientLayer*) lightBlueGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(228/255.0) green:(252/255.0) blue:(255/255.0) alpha:1.0];
    //    UIColor *colorTwo = [UIColor colorWithRed:(100/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(228/255.0) green:(242/255.0) blue:(245/255.0) alpha:1.0];
    
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

@end