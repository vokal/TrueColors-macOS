//
//  TRUCustomMenuPopUpButton.h
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TRUDocument;

/**
 *  Parent class for pop-up buttons with custom menus.
 */
@interface TRUCustomMenuPopUpButton : NSPopUpButton

/**
 *  The custom menu to display.  This implementation returns a menu with a single unselectable item to indicate no
 *  selection.  Subclasses may call this implementation to have that item or override or alter the menu.
 */
@property (nonatomic, readonly) NSMenu *customMenu;

/**
 *  The TRUDocument corresponding to the window in which the popup button appears.
 */
@property (nonatomic, weak) TRUDocument *document;

/**
 *  Forces the menu to select the object specified by the binding.
 */
- (void)updateSelectionToMatchBinding;

@end
