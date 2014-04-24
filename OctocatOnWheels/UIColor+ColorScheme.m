//
//  UIColor+ColorScheme.m
//  OctocatOnWheels
//
//  Created by Cole Bratcher on 4/24/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "UIColor+ColorScheme.h"

#define RGB_TO_UICOLOR(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation UIColor (ColorScheme)

// Text Colors
+ (UIColor *)midnightBlueColor
{
    return RGB_TO_UICOLOR(44, 62, 80);
}

// Repos Colors
+ (UIColor *)belizeHoleColor
{
    return RGB_TO_UICOLOR(41, 128, 185);
}

+ (UIColor *)peterRiverColor;
{
    return RGB_TO_UICOLOR(52, 152, 219);
}

// Users Colors
+ (UIColor *)greenSeaColor
{
    return RGB_TO_UICOLOR(22, 160, 133);
}

+ (UIColor *)turquoiseColor;
{
    return RGB_TO_UICOLOR(26, 188, 156);
}


// Search Colors
+ (UIColor *)nephritisColor
{
    return RGB_TO_UICOLOR(39, 174, 96);
}

+ (UIColor *)emeraldColor;
{
    return RGB_TO_UICOLOR(46, 204, 113);
}


@end
