//
//  TRURowHoverButton.m
//  TrueColors
//
//  Created by Isaac Greenspan on 7/2/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRURowHoverButton.h"

@interface TRURowHoverButton ()

@property (nonatomic, strong) NSTrackingArea *trackingArea;

@end

@implementation TRURowHoverButton

- (NSView *)rowView
{
    NSView *rowView = self;
    do {
        rowView = rowView.superview;
    } while (rowView && ![rowView isKindOfClass:NSTableRowView.class]);
    return rowView;
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
    if (self.trackingArea) {
        [self.rowView removeTrackingArea:self.trackingArea];
        self.trackingArea = nil;
    }
    if (newWindow) {
        self.hidden = YES;
    }
}

- (void)viewDidMoveToWindow
{
    if (self.window && !self.trackingArea) {
        NSView *rowView = self.rowView;
        self.trackingArea = [[NSTrackingArea alloc] initWithRect:rowView.bounds
                                                         options:(NSTrackingMouseEnteredAndExited
                                                                  | NSTrackingActiveInKeyWindow)
                                                           owner:self
                                                        userInfo:nil];
        [rowView addTrackingArea:self.trackingArea];
    }
}

- (BOOL)canBecomeKeyView
{
    return NO;
}

- (void)mouseEntered:(NSEvent *__unused)theEvent
{
    self.hidden = NO;
}

- (void)mouseExited:(NSEvent *__unused)theEvent
{
    self.hidden = YES;
}

@end
