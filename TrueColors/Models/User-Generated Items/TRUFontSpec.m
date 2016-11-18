//
//  TRUFontSpec.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUFontSpec.h"

#import <AppKit/AppKit.h>
#import <CASLIncludedFont.h>

#import "TRUColorSpec.h"
#import "TRUMetricSpec.h"
#import "TRUFontMenuItem.h"

#import "TRULocalizedString.h"

@implementation TRUFontSpec

// Properties synthesized in the superclass need to be declared dynamic here, since we overrode the @property declaration to make the type more specific.
@dynamic colorSpec;
@dynamic size;

+ (NSString *)localizedSpecKindName
{
    return TRULocalizedString.specKindNameFont;
}

- (CGSize)sampleSize
{
    if (!self.font) {
        return CGSizeZero;
    }
    return [self.name sizeWithAttributes:@{ NSFontAttributeName: self.font }];
}

- (id)valueForUndefinedKey:(NSString *__unused)key
{
    // Since the custom menu pop-up button may look for values for keys on TRUFontSpec based on bindings, let's be safe
    // and return nil when we don't have that key, rather than crashing.
    return nil;
}

- (BOOL)isComplete
{
    return self.fontFace && self.size && self.colorSpec;
}

+ (NSSet *)keyPathsForValuesAffectingIsComplete
{
    return [NSSet setWithArray:@[
                                 VOKKeyForSelf(font),
                                 VOKPathFromKeys(
                                                 VOKKeyForSelf(colorSpec),
                                                 VOKKeyForInstanceOf(CASLColorSpec, color),
                                                 ),
                                 ]];
}

- (NSSet *)recursiveFontFaces
{
    NSMutableSet *fontFaces = [NSMutableSet set];
    for (NSSet *subFontFaces in [self.subSpecs valueForKeyPath:VOKKeyForSelf(recursiveFontFaces)]) {
        [fontFaces addObjectsFromArray:subFontFaces.allObjects];
    }
    if (self.fontFace) {
        [fontFaces addObject:self.fontFace.font];
    }
    return [fontFaces copy];
}

#pragma mark - Overridden setters for undo/redo

- (void)setFontFace:(CASLIncludedFont *)fontFace
{
    [self setFontFace:fontFace undoable:YES];
}

- (void)setFontFace:(CASLIncludedFont *)fontFace undoable:(BOOL)undoable
{
    if (self.fontFace != fontFace) {
        if (undoable) {
            [self.managedObjectContext.undoManager setActionName:TRULocalizedString.undoActionNameSetFontFace];
        }
        [self willChangeValueForKey:VOKKeyForSelf(fontFace)];
        [self setPrimitiveFontFace:fontFace];
        [self didChangeValueForKey:VOKKeyForSelf(fontFace)];
    }
}

- (void)setColorSpec:(TRUColorSpec *)color
{
    if (self.colorSpec != color) {
        [self.managedObjectContext.undoManager setActionName:TRULocalizedString.undoActionNameSetFontColor];
        [self willChangeValueForKey:VOKKeyForSelf(colorSpec)];
        [self setPrimitiveColorSpec:color];
        [self didChangeValueForKey:VOKKeyForSelf(colorSpec)];
    }
}

- (void)setSize:(TRUMetricSpec *)size
{
    if (self.size != size) {
        [self.managedObjectContext.undoManager setActionName:TRULocalizedString.undoActionNameSetFontSize];
        [self willChangeValueForKey:VOKKeyForSelf(size)];
        [self setPrimitiveSize:size];
        [self didChangeValueForKey:VOKKeyForSelf(size)];
    }
}

- (NSArray<TRUFontSpec *> *)specsUsingFont:(NSFont *)font
{
    if (!self.hasSubSpecs) {
        return [font isEqual:self.fontFace] ? @[ self, ] : @[];
    }
    NSMutableArray<TRUFontSpec *> *specsUsingFont = [NSMutableArray array];
    for (TRUFontSpec *fontSpec in self.subSpecs) {
        [specsUsingFont addObjectsFromArray:[fontSpec specsUsingFont:font]];
    }
    return [specsUsingFont copy];
}

@end
