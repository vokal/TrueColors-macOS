//
//  TRUOutlineTreeDragController.h
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <AppKit/AppKit.h>

@class TRUDocument;

/**
 *  Controller to handle dragging within an outline view tree.
 */
IB_DESIGNABLE
@interface TRUOutlineTreeDragController : NSObject

/**
 *  Instances with the same identifier will allow dragging between their managed outlines/trees.
 */
@property (nonatomic, strong) IBInspectable NSString *identifier;

/**
 *  The key path on the document corresponding to the content of the tree controller.
 */
@property (nonatomic, strong) IBInspectable NSString *keyPathOnDocument;

/**
 *  The document.
 */
@property (nonatomic, weak) IBOutlet TRUDocument *document;

@end
