//
//  TRULocalizedString.h
//  TrueColors
//
//  Created by Isaac Greenspan on 6/22/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CASLBaseSpec.h>

// TODO: document
@interface TRULocalizedString : NSObject

+ (NSString *)errorDescriptionFileFormatNotRecognized;
+ (NSString *)errorDescriptionNameCannotBeEmpty;
+ (NSString *)errorDescriptionNameAlreadyInUse;

+ (NSString *)alertRemoveFontInUseMessageTextWithFont:(NSFont *)font;
+ (NSString *)alertRemoveFontInUseInformativeText;
+ (NSString *)alertDragPathUniquenessFailureMessageText;
+ (NSString *)alertDragPathUniquenessFailureInformativeTextWithParentPath:(CASLSpecPath *)parentPath names:(NSArray<NSString *> *)duplicateNames;

+ (NSString *)appVersionWithShortVersionString:(NSString *)shortVersionString;

+ (NSString *)unselectableDefaultMenuItem;

+ (NSString *)specKindNameSpec;
+ (NSString *)specKindNameColor;
+ (NSString *)specKindNameMetric;
+ (NSString *)specKindNameFont;
+ (NSString *)specKindNameGroup;

+ (NSString *)kindNameFonts;

+ (NSString *)nameForNewSpecOfKind:(NSString *)localizedSpecKindName;

+ (NSString *)undoActionNameRename:(NSString *)localizedSpecKindName;
+ (NSString *)undoActionNameMove:(NSString *)localizedSpecKindName;
+ (NSString *)undoActionNameAdd:(NSString *)localizedSpecKindName;
+ (NSString *)undoActionNameAddNew:(NSString *)localizedSpecKindName;
+ (NSString *)undoActionNameDuplicate:(NSString *)localizedSpecKindName;
+ (NSString *)undoActionNameDelete:(NSString *)localizedSpecKindName;
+ (NSString *)undoActionNamePickColor;
+ (NSString *)undoActionNameSetMetricValue;
+ (NSString *)undoActionNameSetFontFace;
+ (NSString *)undoActionNameSetFontStyle;
+ (NSString *)undoActionNameSetFontSize;
+ (NSString *)undoActionNameSetFontColor;
+ (NSString *)undoActionNameReplaceFont:(NSString *)localizedOldFontName withFont:(NSString *)localizedNewFontName;

+ (NSString *)menuItemTitleRemove;
+ (NSString *)menuItemTitleReplace;

+ (NSString *)preferencesTitle;
+ (NSString *)preferencesUpdating;

+ (NSString *)toolTipFontIsInUse;
+ (NSString *)toolTipFontIsNotInUse;

@end
