//
//  TRUFontMenuItem.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUFontMenuItem.h"

#import <CASLIncludedFont.h>
#import <NSFont+CASL.h>

#import "NSFont+TRU.h"

#import "TRULocalizedString.h"

@interface TRUFontMenuItem ()

@property (nonatomic, readonly) NSImage *fontNameImage;

@end

@implementation TRUFontMenuItem

// Property synthesized in the superclass needs to be declared dynamic here, since we overrode the @property declaration to make the type more specific.
@dynamic representedObject;

+ (NSCache *)menuItemCache
{
    static NSCache *menuItemCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuItemCache = [[NSCache alloc] init];
    });
    return menuItemCache;
}

+ (instancetype)fontMenuItemFromIncludedFont:(CASLIncludedFont *)includedFont
{
    TRUFontMenuItem *item = [self.menuItemCache objectForKey:includedFont];
    if (!item) {
        item = [[self alloc] initWithIncludedFont:includedFont];
        [self.menuItemCache setObject:item forKey:includedFont];
    }
    return [item copy];
}

- (instancetype)initWithIncludedFont:(CASLIncludedFont *)includedFont
{
    self = [super init];
    if (self) {
        self.representedObject = includedFont;
        self.title = includedFont.font.displayName;
        
        // Use an attributed title with an invisibly-small font size to hide the title (because I couldn't find a way to do it properly).
        NSAttributedString *hiddenTitle = [[NSAttributedString alloc]
                                           initWithString:includedFont.font.displayName
                                           attributes:@{
                                                        NSFontAttributeName: [NSFont systemFontOfSize:0.01f],
                                                        }];
        
        self.attributedTitle = hiddenTitle;
        self.image = self.fontNameImage;
    }
    return self;
}

- (NSImage *)fontNameImage
{
    return self.representedObject.font.tru_fontNameImageOrCreate;
}

@end
