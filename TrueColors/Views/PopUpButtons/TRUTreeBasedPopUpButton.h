//
//  TRUTreeBasedPopUpButton.h
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUCustomMenuPopUpButton.h"

/**
 *  Parent class for pop-up buttons with custom menus based on the contents of a tree controller.
 */
@interface TRUTreeBasedPopUpButton : TRUCustomMenuPopUpButton

/**
 *  The NSTreeController from which to get the menu items.  Subclasses should override and implement this method.
 */
@property (nonatomic, readonly) NSTreeController *treeController;

/**
 *  The menu item for a given tree node, using the given title key path on the node's represented object to get the title of the menu item.
 *
 *  @param node         The tree node to represent
 *  @param titleKeyPath The key path to use on the node's represented object to get the menu item title
 *
 *  @return The menu item
 */
- (NSMenuItem *)menuItemForNode:(NSTreeNode *)node
                   titleKeyPath:(NSString *)titleKeyPath;

@end
