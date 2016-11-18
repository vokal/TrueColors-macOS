//
//  TRUFontMenuItem.h
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CASLIncludedFont;

/**
 *  Menu item to represent a font family, displaying the name of the family in the default style of the particular font
 *  family.  Font names are rendered as images and cached.  Items have plain-text names for keyboard accessibility.
 */
@interface TRUFontMenuItem : NSMenuItem

/**
 *  The font represented by the particular menu item.
 */
@property (strong) CASLIncludedFont *representedObject;

/**
 *  Construct a font menu item based on a given font.
 *
 *  @param font The font on which the menu item should be based.
 *
 *  @return A font menu item based on the given font.
 */
+ (instancetype)fontMenuItemFromIncludedFont:(CASLIncludedFont *)includedFont;

@end
