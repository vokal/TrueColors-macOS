//
//  TRUIncludedFontTreeObject.m
//  TrueColors
//
//  Created by Isaac Greenspan on 9/13/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUIncludedFontTreeObject.h"

#import <CASLIncludedFont.h>

#import "NSFont+TRU.h"

#import "TRUDocument.h"
#import "TRULocalizedString.h"

@implementation TRUIncludedFontTreeObject

- (NSArray *)members
{
    if (!_members) {
        _members = @[];
    }
    return _members;
}

- (NSString *)localizedName
{
    if (self.font) {
        return self.font.displayName;
    }
    return self.familyName;
}

- (NSImage *)nameImage
{
    NSImage *nameImage = self.font.tru_fontNameImage;
    if (!nameImage) {
        typeof(self) __weak weakSelf = self;
        [self.font tru_loadFontNameImageWithCompletion:^(NSImage *__unused image) {
            [weakSelf willChangeValueForKey:VOKKeyForSelf(nameImage)];
            [weakSelf didChangeValueForKey:VOKKeyForSelf(nameImage)];
        }];
    }
    return nameImage;
}

- (NSString *)inUseIndicator
{
    return (self.isInUse ? @"◉" : @"◎");
}

+ (NSSet *)keyPathsForValuesAffectingInUseIndicator
{
    return [NSSet setWithObject:VOKKeyForSelf(inUse)];
}

- (NSString *)inUseToolTipText
{
    return (self.isInUse
            ? TRULocalizedString.toolTipFontIsInUse
            : TRULocalizedString.toolTipFontIsNotInUse);
}

+ (NSSet *)keyPathsForValuesAffectingInUseToolTipText
{
    return [NSSet setWithObject:VOKKeyForSelf(inUse)];
}

- (void)remove
{
    [NSApp sendAction:@selector(removeFont:)
                   to:nil
                 from:self];
}

- (BOOL)isInUse
{
    return self.includedFont.fontSpecs.count > 0;
}

+ (NSSet *)keyPathsForValuesAffectingInUse
{
    return [NSSet setWithObject:VOKPathFromKeys(
                                                VOKKeyForSelf(includedFont),
                                                VOKKeyForInstanceOf(CASLIncludedFont, fontSpecs),
                                                )];
}

@end
