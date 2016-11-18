//
//  TRUSpecOutlineViewDelegate.m
//  TrueColors
//
//  Created by Isaac Greenspan on 9/18/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUSpecOutlineViewDelegate.h"

#import "NSTableRowView+TRU.h"

#import "TRUBaseSpec.h"
#import "TRUFontSpec.h"

@interface TRUSpecOutlineViewDelegate () <NSOutlineViewDelegate>

@end

@implementation TRUSpecOutlineViewDelegate

#pragma mark - NSOutlineViewDelegate

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(NSTreeNode *)item
{
    static NSLayoutManager *layoutManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        layoutManager = [[NSLayoutManager alloc] init];
    });
    
    if ([item.representedObject isKindOfClass:TRUFontSpec.class]) {
        // We're only manipulating the heights of the text style (font spec) rows.
        TRUFontSpec *fontSpec = item.representedObject;
        NSFont *font = fontSpec.font;
        return MAX(outlineView.rowHeight, [layoutManager defaultLineHeightForFont:font]);
    }
    return outlineView.rowHeight;
}

- (void)outlineView:(NSOutlineView *__unused)outlineView
      didAddRowView:(NSTableRowView *)rowView
             forRow:(NSInteger __unused)row
{
    NSColor *incompleteBackgroundColor = [NSColor.redColor colorWithAlphaComponent:0.3];
    
    [rowView.tru_specCompleteObservation remove];
    NSTableCellView *aCellView = [rowView viewAtColumn:0];
    typeof(rowView) __weak weakRowView = rowView;
    rowView.tru_specCompleteObservation = [aCellView
                                           addObserver:rowView
                                           keyPath:VOKPathFromKeys(
                                                                   VOKKeyForObject(aCellView, objectValue),
                                                                   VOKKeyForInstanceOf(TRUBaseSpec, isComplete),
                                                                   )
                                           options:NSKeyValueObservingOptionInitial
                                           block:^(MAKVONotification *notification) {
                                               TRUBaseSpec *spec = [notification.target objectValue];
                                               weakRowView.backgroundColor = (spec.isComplete || spec.hasSubSpecs
                                                                              ? NSColor.clearColor
                                                                              : incompleteBackgroundColor);
                                           }];
}

@end
