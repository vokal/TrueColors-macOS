//
//  TRUCustomMenuPopUpButton.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUCustomMenuPopUpButton.h"

#import "TRUFontSpec.h"

#import "TRULocalizedString.h"

@interface TRUCustomMenuPopUpButton ()

@property (nonatomic, assign) BOOL hasOverriddenMenu;

@end

@implementation TRUCustomMenuPopUpButton

- (NSMenu *)menu
{
    if (!self.hasOverriddenMenu) {
        self.hasOverriddenMenu = YES;
        [super setMenu:self.customMenu];
    }
    return [super menu];
}

- (NSMenu *)customMenu
{
    NSMenu *menu = [[NSMenu alloc] init];
    menu.autoenablesItems = NO;
    [menu addItem:({
        NSMenuItem *aMenuItem = [[NSMenuItem alloc] init];
        aMenuItem.title = TRULocalizedString.unselectableDefaultMenuItem;
        aMenuItem.enabled = NO;
        aMenuItem;
    })];
    return menu;
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
    [super viewWillMoveToWindow:newWindow];
    
    self.document = (TRUDocument *)newWindow.delegate;
}

- (void)viewDidMoveToWindow
{
    [super viewDidMoveToWindow];
    
    if ([self.superview isKindOfClass:NSTableCellView.class]) {
        TRUFontSpec *spec = ((NSTableCellView *)self.superview).objectValue;
        if ([spec isKindOfClass:TRUFontSpec.class]) {
            [self updateSelectionToMatchBinding];
        }
    }
}

- (void)setDocument:(TRUDocument *)document
{
    _document = document;
    self.hasOverriddenMenu = NO;
    [self setMenu:self.menu];
}

- (void)updateSelectionToMatchBinding
{
    NSDictionary *bindingInfo = [self infoForBinding:NSSelectedObjectBinding];
    id representedObject = [bindingInfo[NSObservedObjectKey] valueForKeyPath:bindingInfo[NSObservedKeyPathKey]];
    if (representedObject) {
        [self selectItemAtIndex:[self.menu indexOfItemWithRepresentedObject:representedObject]];
    } else {
        [self selectItemAtIndex:0];
    }
}

@end
