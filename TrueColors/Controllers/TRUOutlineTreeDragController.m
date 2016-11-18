//
//  TRUOutlineTreeDragController.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUOutlineTreeDragController.h"

#import <CASLDocument.h>

#import "TRUBaseSpec.h"
#import "TRUFontSpec.h"

#import "TRUDocument.h"

#import "TRULocalizedString.h"

@interface TRUOutlineTreeDragController () <NSOutlineViewDataSource>

@property (nonatomic, weak) IBOutlet NSTreeController *treeController;
@property (nonatomic, weak) IBOutlet NSOutlineView *outlineView;

@property (nonatomic, strong) NSArray<NSString *> *dragType;
@property (nonatomic, strong) NSArray<NSTreeNode *> *draggedNodes;

@end

@implementation TRUOutlineTreeDragController

- (void)awakeFromNib
{
    self.dragType = @[ [NSBundle.mainBundle.bundleIdentifier stringByAppendingPathExtension:self.identifier], ];
    [self.outlineView registerForDraggedTypes:self.dragType];
}

- (NSString *)identifier
{
    if (!_identifier) {
        return self.keyPathOnDocument;
    }
    return _identifier;
}

- (BOOL)isNode:(NSTreeNode *)possibleAncestor
    ancestorOf:(NSTreeNode *)possibleSubnode
{
    NSTreeNode *walkUpFromSubnode = possibleSubnode;
    while (walkUpFromSubnode) {
        if (walkUpFromSubnode == possibleAncestor) {
            return YES;
        }
        walkUpFromSubnode = walkUpFromSubnode.parentNode;
    }
    return NO;
}

- (NSSet<CASLSpecPath *> *)duplicatePathsFromDraggedNodes
{
    // Get newly-created duplicate paths by checking all the child nodes of the new parent node.
    NSArray<NSTreeNode *> *allChildNodes = self.draggedNodes.firstObject.parentNode.childNodes;
    NSCountedSet<CASLSpecPath *> *paths = [[NSCountedSet alloc] initWithArray:
                                           [allChildNodes valueForKeyPath:
                                            VOKPathFromKeys(
                                                            VOKKeyForInstanceOf(NSTreeNode, representedObject),
                                                            VOKKeyForInstanceOf(TRUBaseSpec, path),
                                                            )]];
    return [paths objectsPassingTest:^BOOL(id obj, BOOL *__unused stop) {
        return [paths countForObject:obj] > 1;
    }];
}

#pragma mark - NSOutlineViewDataSource

- (BOOL)outlineView:(NSOutlineView *__unused)outlineView
         writeItems:(NSArray *)items
       toPasteboard:(NSPasteboard *)pboard
{
    [pboard declareTypes:self.dragType owner:self];
    self.draggedNodes = items;
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *__unused)outlineView
         acceptDrop:(id<NSDraggingInfo> __unused)info
               item:(id)item
         childIndex:(NSInteger)index
{
    NSMutableSet<NSTreeNode *> *sourceParents = [NSMutableSet set];
    for (NSTreeNode *node in self.draggedNodes) {
        if (node.parentNode) {
            [sourceParents addObject:node.parentNode];
        }
    }
    NSTreeNode *parentNode = item;
    if (index < 0) {
        // A negative index doesn't make sense in context and will cause NSIndexPath to crash.
        // (In the implicit cast from int to NSUInteger, it gets turned into a very large positive number, which is
        // almost certainly out of bounds.)
        index = 0;
    }
    TRUBaseSpec *destinationObject = parentNode.representedObject;
    if (destinationObject && !destinationObject.hasSubSpecs) {
        // Dropped on a "leaf", so create a new container and put both the dragged items and parentNode into it.
        NSArray<NSTreeNode *> *nodes;
        if ([parentNode.indexPath compare:self.draggedNodes.firstObject.indexPath] == NSOrderedAscending) {
            nodes = [@[ parentNode, ] arrayByAddingObjectsFromArray:self.draggedNodes];
        } else {
            nodes = [self.draggedNodes arrayByAddingObject:parentNode];
        }
        return [self.document makeNewContainerIn:destinationObject.parentSpec
                                         atIndex:[destinationObject.parentSpec.subSpecs indexOfObject:destinationObject]
                                 containingSpecs:[nodes valueForKeyPath:VOKKeyForInstanceOf(NSTreeNode, representedObject)]];
    }
        
    // Dropped on the root or something that's already a container.
    return [self.document moveSpecs:[self.draggedNodes valueForKeyPath:VOKKeyForInstanceOf(NSTreeNode, representedObject)]
                           toParent:destinationObject
                            atIndex:index];
}

- (NSDragOperation)outlineView:(NSOutlineView *__unused)outlineView
                  validateDrop:(id<NSDraggingInfo> __unused)info
                  proposedItem:(id)item
            proposedChildIndex:(NSInteger __unused)index
{
    NSTreeNode *newParent = item;
    
    // drags to the root are always acceptable
    if (!newParent) {
        return NSDragOperationGeneric;
    }
    
    // Verify that we are not dragging a parent to one of its own ancestors
    // causes a parent loop where a group of nodes point to each other and disappear
    // from the control
    for (NSTreeNode *node in self.draggedNodes) {
        if ([self isNode:node ancestorOf:newParent]) {
            return NO;
        }
    }
    
    return NSDragOperationGeneric;
}

@end
