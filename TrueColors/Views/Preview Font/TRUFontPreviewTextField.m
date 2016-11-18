//
//  TRUFontPreviewTextField.m
//  TrueColors
//
//  Created by Isaac Greenspan on 9/18/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUFontPreviewTextField.h"

#import "TRUDocument.h"

@implementation TRUFontPreviewTextField

- (NSTableRowView *)rowView
{
    NSView *rowView = self;
    do {
        rowView = rowView.superview;
    } while (rowView && ![rowView isKindOfClass:NSTableRowView.class]);
    return (NSTableRowView *)rowView;
}

- (void)setFont:(NSFont *)font
{
    [super setFont:font];
    
    // Tell the tableview that this row's height has changed (or, at least, might have changed).
    NSTableRowView *rowView = self.rowView;
    NSTableView *tableView = (NSTableView *)rowView.superview;
    NSInteger rowIndex = [tableView rowAtPoint:rowView.frame.origin];
    if (rowIndex >= 0) {
        [tableView noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndex:rowIndex]];
    }
}

@end
