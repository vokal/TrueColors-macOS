//
//  TRUIncludedFontsSectionView.m
//  TrueColors
//
//  Created by Isaac Greenspan on 9/13/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUIncludedFontsSectionView.h"

#import <NSFont+CASL.h>

#import "TRUDocument.h"

@interface TRUIncludedFontsSectionView () <NSDraggingDestination>

@property (nonatomic, weak) IBOutlet TRUDocument *document;

@end

@implementation TRUIncludedFontsSectionView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self registerForDraggedTypes:@[
                                        NSFilenamesPboardType,
                                        ]];
    }
    return self;
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = sender.draggingSourceOperationMask;
    pboard = sender.draggingPasteboard;
    
    if ([pboard.types containsObject:NSFilenamesPboardType]) {
        NSArray<NSString *> *files = [pboard propertyListForType:NSFilenamesPboardType];
        for (NSString *filePath in files) {
            if (![NSFont casl_fontFromURL:[NSURL fileURLWithPath:filePath]]) {
                return NSDragOperationNone;
            }
        }
        if (sourceDragMask & NSDragOperationGeneric
            || sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }
    
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = sender.draggingSourceOperationMask;
    pboard = sender.draggingPasteboard;
    
    if ([pboard.types containsObject:NSFilenamesPboardType]) {
        // Only a copy operation allowed so just copy the data
        [self.document addFontsFromPaths:[pboard propertyListForType:NSFilenamesPboardType]];
        return YES;
    }
    return NO;
}

@end
