//
//  NSColor+CASL.h
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 *  Add hex-string handling to NSColor.
 */
@interface NSColor (CASL)

/**
 *  Get a hex string representation of the receiver in NSCalibratedRGBColorSpace, with alpha component.
 *
 *  @return An 8-character hex string (RRGGBBAA)
 */
- (NSString *)casl_hexStringWithAlpha;

/**
 *  Generate a color from a hex string representation with alpha component.
 *
 *  @param hexString An 8-character hex string (RRGGBBAA)
 *
 *  @return A corresponding NSColor object
 */
+ (instancetype)casl_fromHexStringWithAlpha:(NSString *)hexString;

@end
