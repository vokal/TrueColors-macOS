//
//  NSFont+TRU.m
//  TrueColors
//
//  Created by Isaac Greenspan on 9/13/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "NSFont+TRU.h"

@implementation NSFont (TRU)

- (NSOperationQueue *)tru_imageGeneratingOperationQueue
{
    static NSOperationQueue *imageGeneratingOperationQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageGeneratingOperationQueue = [[NSOperationQueue alloc] init];
    });
    return imageGeneratingOperationQueue;
}

- (NSCache *)tru_fontNameImageCache
{
    static NSCache *fontNameImageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontNameImageCache = [[NSCache alloc] init];
    });
    return fontNameImageCache;
}

- (NSImage *)tru_fontNameImage
{
    return [self.tru_fontNameImageCache objectForKey:self.fontName];
}

- (NSImage *)tru_fontNameImageOrCreate
{
    NSCache *imageCache = self.tru_fontNameImageCache;
    NSImage *fontNameImage = [imageCache objectForKey:self.fontName];
    if (!fontNameImage) {
        // Image file is not in cache, so built it and save it to the cache.
        NSAttributedString *attributedFontName = [[NSAttributedString alloc]
                                                  initWithString:self.displayName
                                                  attributes:@{
                                                               NSFontAttributeName: self,
                                                               }];
        NSSize fontNameSize = attributedFontName.size;
        fontNameImage = [[NSImage alloc] initWithSize:NSMakeSize(floorf(fmaxf(fontNameSize.width, 30.0f)),
                                                                 floorf(fmaxf(fontNameSize.height, 10.0f)))];
        
        [fontNameImage lockFocus];
        [attributedFontName drawAtPoint:NSZeroPoint];
        [fontNameImage unlockFocus];
        
        [imageCache setObject:fontNameImage forKey:self.fontName];
    }
    return fontNameImage;
}

- (void)tru_loadFontNameImageWithCompletion:(TRUImageCreationCompletionBlock)completion
{
    NSParameterAssert(completion);
    NSFont *font = [self copy];
    [self.tru_imageGeneratingOperationQueue addOperationWithBlock:^{
        NSImage *fontNameImage = [font tru_fontNameImageOrCreate];
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            completion(fontNameImage);
        }];
    }];
}

@end
