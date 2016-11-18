//
//  TRUContextMenuOutlineView.m
//  TrueColors
//
//  Created by Isaac Greenspan on 10/3/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

#import "TRUContextMenuOutlineView.h"

@implementation TRUContextMenuOutlineView

- (NSMenu *)menuForEvent:(NSEvent *)event
{
    NSMenu *menu = nil;
    CGPoint point = [self convertPoint:event.locationInWindow fromView:nil];
    NSInteger rowIndex = [self rowAtPoint:point];
    NSInteger columnIndex = [self columnAtPoint:point];
    if (rowIndex != -1) {
        NSTableRowView *rowView = [self rowViewAtRow:rowIndex makeIfNecessary:YES];
        if (columnIndex != -1) {
            NSTableCellView *cellView = [rowView viewAtColumn:columnIndex];
            menu = cellView.menu;
        }
        if (!menu) {
            menu = rowView.menu;
        }
    }
    self.menu = menu;
    return [super menuForEvent:event];
}

@end
