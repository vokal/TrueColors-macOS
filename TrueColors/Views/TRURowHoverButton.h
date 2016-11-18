//
//  TRURowHoverButton.h
//  TrueColors
//
//  Created by Isaac Greenspan on 7/2/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 *  A button that appears only when the mouse is over the table row containing it.
 */
@interface TRURowHoverButton : NSButton

/**
 *  The table row view containing the receiver.
 *
 *  @return The table row view containing the receiver
 */
- (NSView *)rowView;

@end
