//
//  TRUColorSpec.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUColorSpec.h"

#import "TRULocalizedString.h"

@implementation TRUColorSpec

+ (NSString *)localizedSpecKindName
{
    return TRULocalizedString.specKindNameColor;
}

- (BOOL)isComplete
{
    return !!self.color;  // !! to boolify.
}

+ (NSSet *)keyPathsForValuesAffectingIsComplete
{
    return [NSSet setWithArray:@[
                                 VOKKeyForSelf(color),
                                 ]];
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setPrimitiveColor:NSColor.blackColor];
}

#pragma mark - Overridden setters for undo/redo

- (void)setColor:(NSColor *)color
{
    if (self.color != color) {
        [self.managedObjectContext.undoManager setActionName:TRULocalizedString.undoActionNamePickColor];
        [self willChangeValueForKey:VOKKeyForSelf(color)];
        [self setPrimitiveColor:color];
        [self didChangeValueForKey:VOKKeyForSelf(color)];
    }
}

@end
