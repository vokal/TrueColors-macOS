//
//  TRULocalizedString.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/22/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRULocalizedString.h"

@implementation TRULocalizedString

+ (NSString *)errorDescriptionFileFormatNotRecognized
{
    return NSLocalizedString(@"File format not recognized.",
                             @"user-facing message for when no serializer can deserialize the document at the given URL");
}

+ (NSString *)errorDescriptionNameCannotBeEmpty
{
    return NSLocalizedString(@"Name cannot be empty.",
                             @"user-facing message for when trying to set an empty name");
}

+ (NSString *)errorDescriptionNameAlreadyInUse
{
    return NSLocalizedString(@"That name is already in use.",
                             @"user-facing message for when trying to set a name that will cause a path conflict");
}

+ (NSString *)alertRemoveFontInUseMessageTextWithFont:(NSFont *)font
{
    return [NSString stringWithFormat:
            NSLocalizedString(@"The font %@ is used by one or more text styles.",
                             @"title message for the alert that a font cannot be removed because it's in use"),
            font.displayName];
}

+ (NSString *)alertRemoveFontInUseInformativeText
{
    return NSLocalizedString(@"An included font that is still being used cannot be removed.  Change any text styles using this font before removing it.",
                             @"body for the alert that a font cannot be removed because it's in use");
}

+ (NSString *)alertDragPathUniquenessFailureMessageText
{
    return NSLocalizedString(@"Moving those specs would cause a naming conflict.",
                             @"title message for the alert that the drag-move failed because it would violate path uniqueness");
}

+ (NSString *)alertDragPathUniquenessFailureInformativeTextWithParentPath:(CASLSpecPath *)parentPath
                                                                    names:(NSArray<NSString *> *)duplicateNames
{
    NSMutableArray<NSString *> *joinedPaths = [NSMutableArray arrayWithCapacity:duplicateNames.count];
    NSString *parentPathString = (parentPath.count
                                  ? [[parentPath componentsJoinedByString:@" » "] stringByAppendingString:@" » "]
                                  : @"");
    for (NSString *name in duplicateNames) {
        [joinedPaths addObject:[parentPathString stringByAppendingString:name]];
    }
    return [NSString stringWithFormat:
            NSLocalizedString(@"The following spec paths would not be unique:\n%@",
                              @"body for the alert that the drag-move failed because it would violate path uniqueness"),
            [joinedPaths componentsJoinedByString:@"\n"]];
}

+ (NSString *)appVersionWithShortVersionString:(NSString *)shortVersionString
{
    return [NSString stringWithFormat:
            NSLocalizedString(@"Version %@", @"format string for displaying the app version in the about window, with a placeholder for the short version string"),
            shortVersionString];
}

+ (NSString *)unselectableDefaultMenuItem
{
    return NSLocalizedString(@"—", @"what to use as the title of unselectable default menu items");
}

+ (NSString *)specKindNameSpec
{
    return NSLocalizedString(@"Spec", @"the name of the generic kind of spec in the lists");
}

+ (NSString *)specKindNameColor
{
    return NSLocalizedString(@"Color", @"the name of the color kind of spec");
}

+ (NSString *)specKindNameMetric
{
    return NSLocalizedString(@"Metric", @"the name of the metric kind of spec");
}

+ (NSString *)specKindNameFont
{
    return NSLocalizedString(@"Text Style", @"the name of the font kind of spec");
}

+ (NSString *)specKindNameGroup
{
    return NSLocalizedString(@"Group", @"the name for a group of specs (for the container)");
}

+ (NSString *)kindNameFonts
{
    return NSLocalizedString(@"Fonts", @"term for fonts");
}

+ (NSString *)nameForNewSpecOfKind:(NSString *)localizedSpecKindName
{
    return [NSString stringWithFormat:NSLocalizedString(@"New %@",
                                                        @"generic name for a new spec, with a placeholder for the spec kind name"),
            localizedSpecKindName];
}

+ (NSString *)undoActionNameRename:(NSString *)localizedSpecKindName
{
    return [NSString stringWithFormat:
            NSLocalizedString(@"Rename %@",
                              @"name for the action of renaming an spec, with a placeholder for the spec kind name, for undo-redo purposes"),
            localizedSpecKindName];
}

+ (NSString *)undoActionNameMove:(NSString *)localizedSpecKindName
{
    return [NSString stringWithFormat:
            NSLocalizedString(@"Move %@",
                              @"name for the action of moving an spec, with a placeholder for the spec kind name, for undo-redo purposes"),
            localizedSpecKindName];
}

+ (NSString *)undoActionNameAdd:(NSString *)localizedSpecKindName
{
    return [NSString stringWithFormat:
            NSLocalizedString(@"Add %@",
                              @"name for the action of adding a spec, with a placeholder for the spec kind name, for undo-redo purposes"),
            localizedSpecKindName];
}

+ (NSString *)undoActionNameAddNew:(NSString *)localizedSpecKindName
{
    return [NSString stringWithFormat:
            NSLocalizedString(@"Add New %@",
                              @"name for the action of adding a new spec, with a placeholder for the spec kind name, for undo-redo purposes"),
            localizedSpecKindName];
}

+ (NSString *)undoActionNameDuplicate:(NSString *)localizedSpecKindName
{
    return [NSString stringWithFormat:
            NSLocalizedString(@"Duplicate %@",
                              @"name for the action of duplicating a spec, with a placeholder for the spec kind name, for undo-redo purposes"),
            localizedSpecKindName];
}

+ (NSString *)undoActionNameDelete:(NSString *)localizedSpecKindName
{
    return [NSString stringWithFormat:
            NSLocalizedString(@"Delete %@",
                              @"name for the action of deleting an spec, with a placeholder for the spec kind name, for undo-redo purposes"),
            localizedSpecKindName];
}

+ (NSString *)undoActionNamePickColor
{
    return NSLocalizedString(@"Set Color",
                             @"name for the action of setting a color, for undo-redo purposes");
}

+ (NSString *)undoActionNameSetMetricValue
{
    return NSLocalizedString(@"Change Metric Value",
                             @"name for the action of setting a metric value, for undo-redo purposes");
}

+ (NSString *)undoActionNameSetFontFace
{
    return NSLocalizedString(@"Change Font Face",
                             @"name for the action of setting a font face, for undo-redo purposes");
}

+ (NSString *)undoActionNameSetFontStyle
{
    return NSLocalizedString(@"Change Font Style",
                             @"name for the action of setting a font style, for undo-redo purposes");
}

+ (NSString *)undoActionNameSetFontSize
{
    return NSLocalizedString(@"Change Font Size",
                             @"name for the action of setting a font size, for undo-redo purposes");
}

+ (NSString *)undoActionNameSetFontColor
{
    return NSLocalizedString(@"Change Font Color",
                             @"name for the action of setting a font color, for undo-redo purposes");
}

+ (NSString *)undoActionNameReplaceFont:(NSString *)localizedOldFontName withFont:(NSString *)localizedNewFontName
{
    return [NSString stringWithFormat:
            NSLocalizedString(@"Replace %@ with %@",
                              @"name for the action of replacing one font with another, with placeholders for the old and new font names, for undo-redo purposes"),
            localizedOldFontName, localizedNewFontName];
}

+ (NSString *)menuItemTitleRemove
{
    return NSLocalizedString(@"Remove", @"title for a menu item to remove something");
}

+ (NSString *)menuItemTitleReplace
{
    return NSLocalizedString(@"Replace…", @"title for a menu item to replace something");
}

+ (NSString *)preferencesTitle
{
    return NSLocalizedString(@"Preferences",
                             @"title for the preferences window controller");
}

+ (NSString *)preferencesUpdating
{
    return NSLocalizedString(@"Updating",
                             @"title for the Updating preferences pane");
}

+ (NSString *)toolTipFontIsInUse
{
    return NSLocalizedString(@"This font is used in one or more text styles",
                             @"tool tip to show over the included-font in-use indicator");
}

+ (NSString *)toolTipFontIsNotInUse
{
    return NSLocalizedString(@"This font is not used in any text styles",
                             @"tool tip to show over the included-font not-in-use indicator");
}

@end
