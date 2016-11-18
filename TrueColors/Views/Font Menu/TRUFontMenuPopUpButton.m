//
//  TRUFontMenuPopUpButton.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUFontMenuPopUpButton.h"

#import <CASLDocument.h>
#import <CASLFontSpec.h>
#import <CASLIncludedFont.h>
#import <MAKVONotificationCenter/MAKVONotificationCenter.h>

#import "TRUDocument.h"

#import "TRUFontMenuItem.h"

@interface TRUFontMenuPopUpButton ()

@property (nonatomic, weak) id<MAKVOObservation> includedFontObservation;

@end

@implementation TRUFontMenuPopUpButton

- (NSMenu *)customMenu
{
    NSMenu *menu = [super customMenu];
    for (CASLIncludedFont *includedFont in self.document.document.rootIncludedFonts.subSpecs) {
        [menu addItem:[TRUFontMenuItem fontMenuItemFromIncludedFont:includedFont]];
    }
    return menu;
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
    [super viewWillMoveToWindow:newWindow];
    
    [self.includedFontObservation remove];
    typeof(self) __weak weakSelf = self;
    self.includedFontObservation = [self.document.document
                                    addObserver:self
                                    keyPath:VOKPathFromKeys(
                                                            VOKKeyForObject(self.document.document, rootIncludedFonts),
                                                            VOKKeyForInstanceOf(CASLBaseSpec, subSpecs),
                                                            )
                                    options:NSKeyValueObservingOptionInitial
                                    block:^(MAKVONotification *__unused notification) {
                                        weakSelf.menu = [[NSMenu alloc] init];
                                        weakSelf.menu = weakSelf.customMenu;
                                        [weakSelf updateSelectionToMatchBinding];
                                    }];
}

@end
