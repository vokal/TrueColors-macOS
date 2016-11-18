//
//  Document.h
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "TRUBaseSpec.h"

/**
 *  Error domain used for errors relating to documents.
 */
FOUNDATION_EXPORT NSString *const TRUDocumentErrorDomain;

@class TRUColorSpec;
@class TRUMetricSpec;
@class TRUFontSpec;
@class TRUIncludedFontTreeObject;
@class CASLDocument;
@class CASLIncludedFont;

/**
 *  Represent a .truecolors document.
 */
@interface TRUDocument : NSDocument

/**
 *  The tree controller for colors.
 */
@property (nonatomic, strong) IBOutlet NSTreeController *colorTreeController;

/**
 *  The tree controller for metrics.
 */
@property (nonatomic, strong) IBOutlet NSTreeController *metricTreeController;

/**
 *  The tree controller for text styles (font specs).
 */
@property (nonatomic, strong) IBOutlet NSTreeController *textStylesTreeController;

/**
 *  The underlying document containing the actual data.
 */
@property (nonatomic, strong) CASLDocument *document;

/**
 *  The tree representation of the included fonts.
 */
@property (nonatomic, readonly) NSArray<TRUIncludedFontTreeObject *> *includedFontsTreeData;

/**
 *  Remove a given spec or, if it's selected, all the selected specs in that section.
 *
 *  @param sender The target spec.
 */
- (IBAction)removeSpec:(TRUBaseSpec *)sender;

/**
 *  Remove the included font encapsulated in the given tree object.
 *
 *  @param sender An included font tree object containing the font to be removed.
 */
- (IBAction)removeFont:(TRUIncludedFontTreeObject *)sender;

/**
 *  Present a sheet to allow the user to replace the included font represented by the sending menu item.
 *
 *  @param sender A menu item representing the font to be removed.
 */
- (IBAction)replaceFont:(NSMenuItem *)sender;

/**
 *  Replace all instances of a given included font in the specs with another included font.
 *
 *  @param oldIncludedFont The included font to replace
 *  @param newIncludedFont The included font replacing \c oldIncludedFont
 */
- (void)undoableReplaceIncludedFont:(CASLIncludedFont *)oldIncludedFont withIncludedFont:(CASLIncludedFont *)newIncludedFont;

/**
 *  Add font(s) from the file(s) at the given path(s) to the included fonts.
 *
 *  @param filePaths An array of paths to font files.
 */
- (void)addFontsFromPaths:(NSArray<NSString *> *)filePaths;

/**
 *  Move existing specs to a particular location.
 *
 *  @param specs      The specs to move
 *  @param parentSpec The spec under which to place the specs being moved
 *  @param index      The index at which to place the specs being moved
 *
 *  @return Whether the operation succeeded
 */
- (BOOL)moveSpecs:(NSArray<TRUBaseSpec *> *)specs
         toParent:(CASLBaseSpec *)parentSpec
          atIndex:(NSUInteger)index;

/**
 *  Create a new container from existing specs.
 *
 *  @param containerParentSpec The spec under which to create the container
 *  @param index               The index at which to create the container
 *  @param specs               The specs to move into the container
 *
 *  @return Whether the operation succeeded
 */
- (BOOL)makeNewContainerIn:(CASLBaseSpec *)containerParentSpec
                   atIndex:(NSUInteger)index
           containingSpecs:(NSArray<TRUBaseSpec *> *)specs;

/**
 *  Add actions to the undo stack as a single grouping.
 *
 *  @param localizedName The localized name of the operation
 *  @param actions       The block to execute within the grouping
 */
- (void)makeUndoWithName:(NSString *)localizedName actions:(void(^)(void))actions;

@end

