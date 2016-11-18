//
//  TRUTreeBasedPopUpButton.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUTreeBasedPopUpButton.h"

#import <MAKVONotificationCenter/MAKVONotificationCenter.h>

#import "TRUBaseSpec.h"

@interface TRUTreeBasedPopUpButton ()

@property (nonatomic, weak) id<MAKVOObservation> treeControllerObservation;

@end

@implementation TRUTreeBasedPopUpButton

- (NSTreeController *)treeController
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSMenuItem *)menuItemForNode:(NSTreeNode *)node
                   titleKeyPath:(NSString *)titleKeyPath
{
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@""
                                                  action:nil
                                           keyEquivalent:@""];
    
    NSTreeNode *__weak weakNode = node;
    TRUBaseSpec *baseSpec = node.representedObject;
    item.representedObject = baseSpec;
    [baseSpec addObserver:item
                  keyPath:titleKeyPath ?: VOKKeyForObject(baseSpec, description)
                  options:NSKeyValueObservingOptionInitial
                    block:^(MAKVONotification *__unused notification) {
                        NSString *title = (titleKeyPath
                                           ? [weakNode.representedObject valueForKeyPath:titleKeyPath]
                                           : [weakNode.representedObject description]);
                        item.title = title ?: @"";
                    }];
    
    return item;
}

- (NSArray<NSMenuItem *> *)menuItemsForNodes:(NSArray<NSTreeNode *> *)nodes
                                titleKeyPath:(NSString *)titleKeyPath
{
    NSMutableArray<NSMenuItem *> *items = [NSMutableArray arrayWithCapacity:nodes.count];
    
    for (NSTreeNode *node in nodes) {
        NSMenuItem *item = [self menuItemForNode:node
                                    titleKeyPath:titleKeyPath];
        
        [items addObject:item];
        
        if (node.childNodes.count) {
            item.enabled = NO;
            NSArray<NSMenuItem *> *childItems = [self menuItemsForNodes:node.childNodes
                                                           titleKeyPath:titleKeyPath];
            for (NSMenuItem *menuItem in childItems) {
                menuItem.indentationLevel++;
            }
            [items addObjectsFromArray:childItems];
        }
    }
    
    return [items copy];
}

- (NSMenu *)customMenu
{
    NSMenu *menu = [super customMenu];
    for (NSMenuItem *menuItem in [self menuItemsForNodes:[self.treeController.arrangedObjects childNodes]
                                            titleKeyPath:VOKKeyForInstanceOf(TRUBaseSpec, name)]) {
        [menu addItem:menuItem];
    }
    return menu;
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
    [super viewWillMoveToWindow:newWindow];
    
    [self.treeControllerObservation remove];
    typeof(self) __weak weakSelf = self;
    self.treeControllerObservation = [self.treeController
                                      addObserver:self
                                      keyPath:VOKKeyForObject(self.treeController, arrangedObjects)
                                      options:NSKeyValueObservingOptionInitial
                                      block:^(MAKVONotification *__unused notification) {
                                          weakSelf.menu = weakSelf.customMenu;
                                          [weakSelf updateSelectionToMatchBinding];
                                      }];
}

@end
