//
//  NSFont+CASL.h
//  CyndiLauper
//
//  Created by Isaac Greenspan on 9/13/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 *  Add conversion from various data formats and properties for the font data and filename.
 */
@interface NSFont (CASL)

/**
 *  Create an NSFont object from a CGDataProvider.  The NSFont is created at the system font size.
 *
 *  @param dataProvider The data provider from which to create the font.
 *
 *  @return An NSFont object based on the given data provider.
 */
+ (instancetype)casl_fontFromDataProvider:(CGDataProviderRef)dataProvider;

/**
 *  Create an NSFont object from NSData.  The NSFont is created at the system font size.
 *
 *  @param data The font data.
 *
 *  @return An NSFont object based on the given data.
 */
+ (instancetype)casl_fontFromData:(NSData *)data;

/**
 *  Create an NSFont object from a URL.  The NSFont is created at the system font size.
 *
 *  @param url The URL of the font to load.
 *
 *  @return An NSFont object based on the given URL.
 */
+ (instancetype)casl_fontFromURL:(NSURL *)url;

/**
 *  Create an array of NSFont objects from NSData.  The NSFonts are created at the system font size.
 *
 *  If the NSData represents a single font, an array of one font will be returned.  If the NSData represents multiple
 *  fonts, such as TrueType Collection data, an array of all of the fonts in the file will be returned.  
 *  casl_embeddedFontData and casl_embeddedFontFileName will be set on the returned fonts.
 *
 *  @param data      The font data.
 *  @param extension The extension of the file from which the data was loaded.  This is used in setting the extension in casl_embeddedFontFileName, not in determining the format of the data.
 *
 *  @return An array of NSFont objects based on the given data.
 */
+ (NSArray<NSFont *> *)casl_fontsFromData:(NSData *)data extension:(NSString *)extension;

/**
 *  Returns a font object that is the same as the receiver but which has the specified size instead.
 *
 *  @param size The desired size (in points) of the new font object. This value must be greater than 0.0.
 *
 *  @return A font object of the specified size.
 */
- (instancetype)casl_fontWithSize:(CGFloat)size;

/**
 *  The data representation of the font.
 */
@property (nonatomic, strong) NSData *casl_embeddedFontData;

/**
 *  The filename for the font.
 */
@property (nonatomic, copy) NSString *casl_embeddedFontFileName;

@end
