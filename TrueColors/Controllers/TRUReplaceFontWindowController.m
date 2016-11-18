//
//  TRUReplaceFontWindowController.m
//  TrueColors
//
//  Created by Isaac Greenspan on 10/3/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

#import "TRUReplaceFontWindowController.h"

#import "TRUDocument.h"
#import "TRUFontMenuPopUpButton.h"
#import "TRUIncludedFontTreeObject.h"

@interface TRUReplaceFontWindowController ()

@property (nonatomic, weak) IBOutlet TRUFontMenuPopUpButton *fontPopUpButton;
@property (nonatomic, weak) IBOutlet NSImageView *fontNameImageView;

@end

@implementation TRUReplaceFontWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.fontNameImageView.image = self.includedFontTreeObject.nameImage;
    self.fontPopUpButton.document = self.document;
}

- (void)setIncludedFontTreeObject:(TRUIncludedFontTreeObject *)includedFontTreeObject
{
    _includedFontTreeObject = includedFontTreeObject;
    self.fontNameImageView.image = self.includedFontTreeObject.nameImage;
}

#pragma mark - IBActions

- (IBAction)cancel:(id __unused)sender
{
    [self.window.sheetParent endSheet:self.window];
}

- (IBAction)replace:(id __unused)sender
{
    [(TRUDocument *)self.document undoableReplaceIncludedFont:self.includedFontTreeObject.includedFont
                                             withIncludedFont:self.fontPopUpButton.selectedItem.representedObject];
    [self.window.sheetParent endSheet:self.window];
}

@end
