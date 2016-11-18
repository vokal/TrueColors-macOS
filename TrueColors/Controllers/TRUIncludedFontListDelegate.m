//
//  TRUIncludedFontListDelegate.m
//  TrueColors
//
//  Created by Isaac Greenspan on 9/13/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUIncludedFontListDelegate.h"

#import "TRUIncludedFontTreeObject.h"

@implementation TRUIncludedFontListDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *__unused)tableColumn
                   item:(NSTreeNode *)item
{
    TRUIncludedFontTreeObject *object = item.representedObject;
    NSTableCellView *cellView = [outlineView makeViewWithIdentifier:(object.members.count
                                                                     ? @"HeaderCell"
                                                                     : @"DataCell")
                                                              owner:self];
    [cellView.imageView unregisterDraggedTypes];
    return cellView;
}

- (BOOL)outlineView:(NSOutlineView *__unused)outlineView
   shouldSelectItem:(NSTreeNode *__unused)item
{
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *__unused)outlineView
        isGroupItem:(NSTreeNode *)item
{
    TRUIncludedFontTreeObject *object = item.representedObject;
    return !!object.members.count;
}

- (BOOL)outlineView:(NSOutlineView *__unused)outlineView shouldCollapseItem:(id __unused)item
{
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *__unused)outlineView shouldShowOutlineCellForItem:(id __unused)item
{
    return NO;
}

@end
