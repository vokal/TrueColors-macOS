//
//  NSColor+CASL.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "NSColor+CASL.h"

static unsigned int hexComponentFromNormalized(CGFloat normalizedComponent) {
    return (unsigned int)(normalizedComponent * 255.99999999);
}

@implementation NSColor (CASL)

- (NSString *)casl_hexStringWithAlpha
{
    NSColor *rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    
    return [NSString stringWithFormat:@"#%02X%02X%02X%02X",
            hexComponentFromNormalized(rgbColor.redComponent),
            hexComponentFromNormalized(rgbColor.greenComponent),
            hexComponentFromNormalized(rgbColor.blueComponent),
            hexComponentFromNormalized(rgbColor.alphaComponent)];
}

+ (instancetype)casl_fromHexStringWithAlpha:(NSString *)hexString
{
    // Remove any non-hexadecimal characters from the ends of the input string.
    NSCharacterSet *nonHexadecimalCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"] invertedSet];
    hexString = [hexString stringByTrimmingCharactersInSet:nonHexadecimalCharacterSet];
    
    if (hexString.length != 8) {
        return nil;
    }
    
    unsigned int rgbValue = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    if (scanner.scanLocation != 8) {
        // There should be 8 hex digits.  If not, it's not valid.
        return nil;
    }
    
    CGFloat red = ((CGFloat)((rgbValue >> 24) & 0xFF) / (CGFloat)0xFF);
    CGFloat green = ((CGFloat)((rgbValue >> 16) & 0xFF) / (CGFloat)0xFF);
    CGFloat blue = ((CGFloat)((rgbValue >> 8) & 0xFF) / (CGFloat)0xFF);
    CGFloat alpha = ((CGFloat)(rgbValue & 0xFF) / (CGFloat)0xFF);
    
    return [self colorWithCalibratedRed:red
                                  green:green
                                   blue:blue
                                  alpha:alpha];
}

@end
