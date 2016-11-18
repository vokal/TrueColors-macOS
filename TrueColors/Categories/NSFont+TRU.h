//
//  NSFont+TRU.h
//  TrueColors
//
//  Created by Isaac Greenspan on 9/13/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 *  Completion handler block type for creating an NSImage.
 *
 *  @param image The created image
 */
typedef void(^TRUImageCreationCompletionBlock)(NSImage *image);

/**
 *  Add mechanics for creating images of font names.
 */
@interface NSFont (TRU)

/**
 *  An image containing the receiver's display name rendered with the receiver as the font.
 *
 *  This returns the cached image, but will not create the image if it hasn't yet been cached.
 */
@property (nonatomic, readonly) NSImage *tru_fontNameImage;

/**
 *  Asynchronously load the font name image, creating it if necessary.
 *
 *  @param completion The block to invoke with the font name image.
 */
- (void)tru_loadFontNameImageWithCompletion:(TRUImageCreationCompletionBlock)completion;

/**
 *  Return the font name image, creating it synchronously if neceesary.
 *
 *  @return The font name image.
 */
- (NSImage *)tru_fontNameImageOrCreate;

@end
