//
//  Document.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUDocument.h"

#import <CASLDocument.h>
#import <CASLIncludedFont.h>
#import <MAKVONotificationCenter/MAKVONotificationCenter.h>
#import <NSFont+CASL.h>

#import "CASLBaseSpec+TRU.h"

#import "TRUColorSpec.h"
#import "TRUMetricSpec.h"
#import "TRUFontSpec.h"

#import "TRUIncludedFontTreeObject.h"

#import "TRUOutlineTreeDragController.h"
#import "TRUReplaceFontWindowController.h"
#import "TRUVokalTitlebarBrandingViewController.h"

#import "TRULocalizedString.h"

@interface TRUDocument ()

@property (nonatomic, weak) IBOutlet NSOutlineView *colorsOutlineView;
@property (nonatomic, weak) IBOutlet NSOutlineView *metricsOutlineView;
@property (nonatomic, weak) IBOutlet NSOutlineView *textStylesOutlineView;

@property (nonatomic, strong) IBOutlet TRUOutlineTreeDragController *textStylesTreeDragController;

@property (nonatomic, weak) IBOutlet NSOutlineView *includedFontsOutlineView;

@property (nonatomic, strong) NSArray *colorsSelectedIndexPaths;
@property (nonatomic, strong) NSArray *metricsSelectedIndexPaths;
@property (nonatomic, strong) NSArray *textStylesSelectedIndexPaths;

@property (nonatomic, strong) id<NSObject> fontSpecFontFaceChangeObserver;

// Strong outlets to top-level objects that might not otherwise have strong references.
@property (nonatomic, strong) IBOutlet TRUOutlineTreeDragController *colorsTreeDragController;
@property (nonatomic, strong) IBOutlet TRUOutlineTreeDragController *metricsTreeDragController;
@property (nonatomic, strong) IBOutlet id<NSOutlineViewDelegate> specsOutlineDelegate;
@property (nonatomic, strong) IBOutlet NSTreeController *includedFontsTreeController;
@property (nonatomic, strong) IBOutlet id<NSOutlineViewDelegate> includedFontListDelegate;

- (IBAction)addColor:(id)sender;
- (IBAction)addMetric:(id)sender;
- (IBAction)addTextStyle:(id)sender;
- (IBAction)addIncludedFont:(id)sender;

@end

NSString *const TRUDocumentErrorDomain = @"io.vokal.TrueColors.TRUDocumentErrorDomain";

@implementation TRUDocument

- (instancetype)init
{
    self = [super init];
    if (self) {
        _document = [[CASLDocument alloc] initWithColorClass:TRUColorSpec.class
                                                 metricClass:TRUMetricSpec.class
                                                   fontClass:TRUFontSpec.class];
        self.undoManager = _document.context.undoManager;
        typeof(self) __weak weakSelf = self;
        [self addObserver:self
                  keyPath:VOKPathFromKeys(
                                          VOKKeyForSelf(document),
                                          VOKKeyForInstanceOf(CASLDocument, rootIncludedFonts),
                                          VOKKeyForInstanceOf(CASLBaseSpec, subSpecs),
                                          )
                  options:0
                    block:^(MAKVONotification *__unused notification) {
                        [NSOperationQueue.mainQueue addOperationWithBlock:^{
                            [weakSelf.includedFontsOutlineView expandItem:nil expandChildren:YES];
                        }];
                    }];
    }
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self.fontSpecFontFaceChangeObserver];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    for (NSOutlineView *outlineView in @[ self.colorsOutlineView, self.metricsOutlineView, self.textStylesOutlineView, ]) {
        outlineView.doubleAction = @selector(doubleClickedRow:);
    }
    
    [self.includedFontsOutlineView expandItem:nil expandChildren:YES];
    
    NSWindow *window = self.colorsOutlineView.window;
    if ([window respondsToSelector:@selector(addTitlebarAccessoryViewController:)]) {
        [window addTitlebarAccessoryViewController:[[TRUVokalTitlebarBrandingViewController alloc] init]];
    }
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSString *)windowNibName
{
    return NSStringFromClass(self.class);
}

- (BOOL)writeToURL:(NSURL *)url
            ofType:(NSString *__unused)typeName
             error:(NSError **)outError
{
    return [self.document writeToURL:url
                               error:outError];
}

- (BOOL)readFromURL:(NSURL *)url
             ofType:(NSString *__unused)typeName
              error:(NSError **)outError
{
    self.document = [CASLDocument readFromURL:url
                                   colorClass:TRUColorSpec.class
                                  metricClass:TRUMetricSpec.class
                                    fontClass:TRUFontSpec.class
                                        error:outError];
    if (!self.document) {
        return NO;
    }
    self.undoManager = self.document.context.undoManager;
    return YES;
}

#pragma mark -

- (NSDictionary<NSString *, NSFont *> *)includedFontsDictionary
{
    NSMutableDictionary<NSString *, NSFont *> *includedFontsDictionary = [NSMutableDictionary dictionaryWithCapacity:self.document.rootIncludedFonts.subSpecs.count];
    for (CASLIncludedFont *includedFont in self.document.rootIncludedFonts.subSpecs) {
        includedFontsDictionary[includedFont.font.fontName] = includedFont.font;
    }
    return [includedFontsDictionary copy];
}

+ (NSSet *)keyPathsForValuesAffectingIncludedFontsTreeData
{
    return [NSSet setWithObject:VOKPathFromKeys(
                                                VOKKeyForSelf(document),
                                                VOKKeyForInstanceOf(CASLDocument, rootIncludedFonts),
                                                VOKKeyForInstanceOf(CASLBaseSpec, subSpecs),
                                                )];
}

- (NSArray<TRUIncludedFontTreeObject *> *)includedFontsTreeData
{
    NSMutableDictionary *byFamily = [NSMutableDictionary dictionary];
    for (CASLIncludedFont *includedFont in self.document.rootIncludedFonts.subSpecs) {
        TRUIncludedFontTreeObject *family = byFamily[includedFont.font.familyName];
        if (!family) {
            family = [[TRUIncludedFontTreeObject alloc] init];
            family.familyName = includedFont.font.familyName;
            byFamily[includedFont.font.familyName ?: @""] = family;
        }
        TRUIncludedFontTreeObject *fontTreeObject = [[TRUIncludedFontTreeObject alloc] init];
        fontTreeObject.font = includedFont.font;
        fontTreeObject.includedFont = includedFont;
        family.members = [family.members arrayByAddingObject:fontTreeObject];
    }
    NSMutableArray<TRUIncludedFontTreeObject *> *treeData = [NSMutableArray arrayWithCapacity:byFamily.count];
    for (NSString *familyName in [byFamily.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
        TRUIncludedFontTreeObject *family = byFamily[familyName];
        family.members = [family.members sortedArrayUsingDescriptors:
                          @[
                            [NSSortDescriptor sortDescriptorWithKey:VOKKeyForInstanceOf(TRUIncludedFontTreeObject,
                                                                                        localizedName)
                                                          ascending:YES],
                            ]];
        [treeData addObject:family];
    }
    return [treeData copy];
}

- (NSSet *)fontsInUse
{
    NSMutableSet *fontFaces = [NSMutableSet set];
    for (CASLIncludedFont *includedFont in self.document.rootIncludedFonts.subSpecs) {
        if (includedFont.fontSpecs.count) {
            [fontFaces addObject:includedFont.font];
        }
    }
    if (fontFaces.count) {
        DLOG(@"%@", fontFaces);
    }
    return [fontFaces copy];
}

- (NSTreeController *)treeControllerForClass:(Class)class
{
    if (class == TRUColorSpec.class) {
        return self.colorTreeController;
    }
    if (class == TRUMetricSpec.class) {
        return self.metricTreeController;
    }
    if (class == TRUFontSpec.class) {
        return self.textStylesTreeController;
    }
    NSAssert(NO, @"Unrecognized class (no known corresponding tree contorller).");
    return nil;
}

- (CASLBaseSpec *)rootSpecForClass:(Class)class
{
    if (class == TRUColorSpec.class) {
        return self.document.rootColorSpec;
    }
    if (class == TRUMetricSpec.class) {
        return self.document.rootMetricSpec;
    }
    if (class == TRUFontSpec.class) {
        return self.document.rootFontSpec;
    }
    NSAssert(NO, @"Unrecognized class (no known corresponding root spec).");
    return nil;
}

- (NSTreeController *)firstResponderTreeController
{
    NSResponder *firstResponder = self.windowControllers.firstObject.window.firstResponder;
    if (firstResponder == self.colorsOutlineView) {
        return self.colorTreeController;
    }
    if (firstResponder == self.metricsOutlineView) {
        return self.metricTreeController;
    }
    if (firstResponder == self.textStylesOutlineView) {
        return self.textStylesTreeController;
    }
    return nil;
}

#pragma mark - Make Undoable Changes

- (void)makeUndoWithName:(NSString *)localizedName actions:(void(^)(void))actions
{
    NSUndoManager *undoManager = self.undoManager;
    [undoManager beginUndoGrouping];
    // Set the name before the action because if we don't undo is very broken.
    [undoManager setActionName:localizedName];
    if (actions) {
        actions();
    }
    // Set the name again to fix any clobbering of the name that might have happened in action().
    [undoManager setActionName:localizedName];
    [undoManager endUndoGrouping];
}

- (void)undoableAddFonts:(NSArray<NSFont *> *)fonts
{
    [self makeUndoWithName:[TRULocalizedString undoActionNameAdd:TRULocalizedString.kindNameFonts]
                   actions:^{
                       for (NSFont *font in fonts) {
                           CASLIncludedFont *includedFont = [CASLIncludedFont includedFontForFont:font
                                                                           inManagedObjectContext:self.document.context];
                           if (!includedFont.parentSpec) {
                               [self.document.rootIncludedFonts addSubSpecsObject:includedFont];
                           }
                       }
                       [self.document.rootIncludedFonts.subSpecsSet
                        sortUsingDescriptors:@[
                                               [NSSortDescriptor sortDescriptorWithKey:VOKPathFromKeys(
                                                                                                       VOKKeyForInstanceOf(CASLIncludedFont, font),
                                                                                                       VOKKeyForInstanceOf(NSFont, fontName),
                                                                                                       )
                                                                             ascending:YES],
                                               ]];
                   }];
}

- (void)undoableRemoveFonts:(NSArray<CASLIncludedFont *> *)includedFonts
{
    if (!includedFonts.count) {
        return;
    }
    [self makeUndoWithName:[TRULocalizedString undoActionNameDelete:TRULocalizedString.kindNameFonts]
                   actions:^{
                       for (CASLIncludedFont *includedFont in includedFonts) {
                           [includedFont.parentSpec removeSubSpecsObject:includedFont];
                           [includedFont.managedObjectContext deleteObject:includedFont];
                       }
                   }];
}

- (void)undoableReplaceIncludedFont:(CASLIncludedFont *)oldIncludedFont withIncludedFont:(CASLIncludedFont *)newIncludedFont
{
    [self makeUndoWithName:[TRULocalizedString undoActionNameReplaceFont:oldIncludedFont.font.displayName
                                                                withFont:newIncludedFont.font.displayName]
                   actions:^{
                       for (TRUFontSpec *textStyle in [oldIncludedFont.fontSpecs copy]) {
                           [textStyle setFontFace:newIncludedFont
                                         undoable:NO];
                       }
                   }];
}

- (void)addNewSpecOfClass:(Class)class
{
    [self makeUndoWithName:[TRULocalizedString undoActionNameAddNew:[class localizedSpecKindName]]
                   actions:^{
                       TRUBaseSpec *spec = [class insertInManagedObjectContext:self.document.context];
                       [[self rootSpecForClass:class] addSubSpecsObject:spec];
                       [[self treeControllerForClass:class] addSelectionIndexPaths:@[ spec.indexPath, ]];
                       [spec tru_autoName];
                   }];
}

- (void)deleteSpecs:(NSArray<TRUBaseSpec *> *)specs
{
    if (!specs.count) {
        return;
    }
    [self makeUndoWithName:[TRULocalizedString undoActionNameDelete:[specs.firstObject.class localizedSpecKindName]]
                   actions:^{
                       for (TRUBaseSpec *spec in specs) {
                           CASLBaseSpec *parentSpec = spec.parentSpec;
                           [parentSpec removeSubSpecsObject:spec];
                           [spec.managedObjectContext deleteObject:spec];
                           // Check for emptied-out parents and remove them.
                           while (parentSpec && !parentSpec.hasSubSpecs) {
                               CASLBaseSpec *parentParentSpec = parentSpec.parentSpec;
                               if (!parentParentSpec) {
                                   break;
                               }
                               [parentParentSpec removeSubSpecsObject:parentSpec];
                               [parentSpec.managedObjectContext deleteObject:parentSpec];
                               parentSpec = parentParentSpec;
                           }
                       }
                   }];
}

- (void)duplicateSpecs:(NSArray<TRUBaseSpec *> *)specs
{
    [self makeUndoWithName:[TRULocalizedString undoActionNameDuplicate:[specs.firstObject.class localizedSpecKindName]]
                   actions:^{
                       NSDictionary<NSString *, NSFont *> *includedFontsDictionary = self.includedFontsDictionary;
                       for (TRUBaseSpec *spec in specs) {
                           TRUBaseSpec *newSpec = [spec.class fromJsonRepresentation:[spec jsonSerializableRepresentationWithKeys:CASLBaseSpec.defaultJsonKeys]
                                                                            withKeys:CASLBaseSpec.defaultJsonKeys
                                                                              colors:self.document.colorSpecs
                                                                             metrics:self.document.metricSpecs
                                                                       embeddedFonts:includedFontsDictionary
                                                                             context:spec.managedObjectContext];
                           [spec.parentSpec insertObject:newSpec
                                       inSubSpecsAtIndex:([spec.parentSpec.subSpecs indexOfObject:spec] + 1)];
                           [newSpec tru_autoNameCopy];
                       }
                   }];
}

- (BOOL)validateWithInvalidAlertMovingSpecs:(NSArray<TRUBaseSpec *> *)specs
                                   toParent:(CASLBaseSpec *)parentSpec
{
    NSParameterAssert(specs.count);
    TRUBaseSpec *firstSpec = specs.firstObject;
    if (!firstSpec) {
        return NO;
    }
    
    NSMutableArray *duplicateNames = [NSMutableArray array];
    NSArray *movingSpecNames = [specs valueForKeyPath:VOKKeyForObject(firstSpec, name)];
    
    // Check for duplicates within the specs being moved.
    NSCountedSet *countedMovingSpecNames = [NSCountedSet setWithArray:movingSpecNames];
    for (NSString *name in countedMovingSpecNames) {
        if ([countedMovingSpecNames countForObject:name] > 1) {
            [duplicateNames addObject:name];
        }
    }
    
    // Check for conflicts with existing subspecs.
    if (parentSpec) {
        NSMutableOrderedSet *subSpecs = [parentSpec.subSpecs mutableCopy];
        [subSpecs removeObjectsInArray:specs];
        NSOrderedSet *existingSubspecNames = [subSpecs valueForKeyPath:VOKKeyForObject(parentSpec, name)];
        [duplicateNames addObjectsFromArray:[movingSpecNames filteredArrayUsingPredicate:
                                             [NSPredicate predicateWithFormat:@"self IN %@",
                                              existingSubspecNames]]];
    }
    
    // Do we have duplicates?
    if (duplicateNames.count) {
        // The move would create duplicate paths, so show an alert.
        NSAlert *alert = [[NSAlert alloc] init];
        alert.alertStyle = NSWarningAlertStyle;
        alert.messageText = TRULocalizedString.alertDragPathUniquenessFailureMessageText;
        alert.informativeText = [TRULocalizedString alertDragPathUniquenessFailureInformativeTextWithParentPath:parentSpec.path
                                                                                                          names:duplicateNames];
        [alert beginSheetModalForWindow:self.windowForSheet
                      completionHandler:nil];
        return NO;
    }
    
    return YES;
}

- (BOOL)moveSpecs:(NSArray<TRUBaseSpec *> *)specs
         toParent:(CASLBaseSpec *)parentSpec
          atIndex:(NSUInteger)index
{
    NSParameterAssert(specs.count);
    TRUBaseSpec *firstSpec = specs.firstObject;
    if (!firstSpec) {
        return NO;
    }
    
    parentSpec = parentSpec ?: [self rootSpecForClass:firstSpec.class];
    
    if (![self validateWithInvalidAlertMovingSpecs:specs toParent:parentSpec]) {
        // Fail/reverse the drag in the UI.
        return NO;
    }
    
    NSMutableSet *originalParents = [NSMutableSet setWithArray:[specs valueForKeyPath:VOKKeyForInstanceOf(TRUBaseSpec, parentSpec)]];
    [self
     makeUndoWithName:[TRULocalizedString undoActionNameMove:
                       [firstSpec.class localizedSpecKindName]]
     actions:^{
         // Move the nodes.
         NSInteger destinationIndex = index;
         for (TRUBaseSpec *spec in specs.reverseObjectEnumerator) {
             NSUInteger indexOfSpec = [parentSpec.subSpecs indexOfObject:spec];
             [spec.parentSpec removeSubSpecsObject:spec];
             if (indexOfSpec != NSNotFound && indexOfSpec < destinationIndex) {
                 // If the spec we're moving was before the insertion index, then adjust the insertion index to account
                 // for having removed it.
                 destinationIndex -= 1;
             }
             [parentSpec insertObject:spec inSubSpecsAtIndex:destinationIndex];
         }
         
         // Get just the now-empty source parent nodes...
         [originalParents filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@",
                                                VOKKeyForInstanceOf(TRUBaseSpec, hasSubSpecs),
                                                @NO]];
         // ... and remove them.
         for (TRUBaseSpec *emptyParent in originalParents) {
             CASLBaseSpec *parentSpec = emptyParent.parentSpec;
             [parentSpec removeSubSpecsObject:emptyParent];
             [emptyParent.managedObjectContext deleteObject:emptyParent];
             // Check for emptied-out parents and remove them.
             while (parentSpec && !parentSpec.hasSubSpecs) {
                 CASLBaseSpec *parentParentSpec = parentSpec.parentSpec;
                 if (!parentParentSpec) {
                     break;
                 }
                 [parentParentSpec removeSubSpecsObject:parentSpec];
                 [parentSpec.managedObjectContext deleteObject:parentSpec];
                 parentSpec = parentParentSpec;
             }
         }
     }];
    return YES;
}

- (BOOL)makeNewContainerIn:(CASLBaseSpec *)containerParentSpec
                   atIndex:(NSUInteger)index
           containingSpecs:(NSArray<TRUBaseSpec *> *)specs
{
    NSParameterAssert(specs.count);
    if (![self validateWithInvalidAlertMovingSpecs:specs toParent:nil]) {
        // Fail/reverse the drag in the UI.
        return NO;
    }
    
    TRUBaseSpec *firstSpec = specs.firstObject;
    if (!firstSpec) {
        return NO;
    }
    
    [self.undoManager beginUndoGrouping];
    TRUBaseSpec *container = [firstSpec.class insertInManagedObjectContext:firstSpec.managedObjectContext];
    [containerParentSpec insertObject:container
                    inSubSpecsAtIndex:index];
    [container tru_autoNameGroup];
    BOOL result = [self moveSpecs:specs
                         toParent:container
                          atIndex:0];
    [self.undoManager setActionName:[TRULocalizedString undoActionNameMove:
                                     [firstSpec.class localizedSpecKindName]]];
    [self.undoManager endUndoGrouping];
    return result;
}

#pragma mark - Action Helpers

- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem
{
    SEL action = anItem.action;
    if (action == @selector(delete:)
        || action == @selector(duplicate:)) {
        return (self.firstResponderTreeController.selectedObjects.count > 0);
    }
    return [super validateUserInterfaceItem:anItem];
}

#pragma mark - IBActions

- (IBAction)addColor:(id __unused)sender
{
    [self addNewSpecOfClass:TRUColorSpec.class];
}

- (IBAction)addMetric:(id __unused)sender
{
    [self addNewSpecOfClass:TRUMetricSpec.class];
}

- (IBAction)addTextStyle:(id __unused)sender
{
    [self addNewSpecOfClass:TRUFontSpec.class];
}

- (IBAction)removeSpec:(TRUBaseSpec *)sender
{
    NSTreeController *treeController = [self treeControllerForClass:sender.class];
    if (!treeController) {
        return;
    }
    if ([treeController.selectedObjects containsObject:sender]) {
        // The object is part of the selection, so remove anything that's selected.
        [self deleteSpecs:treeController.selectedObjects];
    } else {
        // The object isn't selected, so just remove the object.
        [self deleteSpecs:@[ sender, ]];
    }
}

- (IBAction)delete:(id __unused)sender
{
    NSTreeController *treeController = self.firstResponderTreeController;
    [self deleteSpecs:treeController.selectedObjects];
}

- (IBAction)duplicate:(id __unused)sender
{
    NSTreeController *treeController = self.firstResponderTreeController;
    NSArray *selectedObjects = treeController.selectedObjects;
    [self duplicateSpecs:selectedObjects];
    treeController.selectionIndexPaths = [selectedObjects valueForKeyPath:VOKKeyForInstanceOf(TRUBaseSpec, indexPath)];
}

- (IBAction)doubleClickedRow:(NSOutlineView *)sender
{
    if (sender.clickedRow >= 0) {
        [sender editColumn:sender.clickedColumn
                       row:sender.clickedRow
                 withEvent:nil
                    select:YES];
    }
}

#pragma mark Included Fonts

- (IBAction)addIncludedFont:(id __unused)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = NO;
    openPanel.allowsMultipleSelection = YES;
    openPanel.allowedFileTypes = @[ @"public.font", ];  // kUTTypeFont is only available on 10.10+
    openPanel.prompt = [TRULocalizedString undoActionNameAdd:TRULocalizedString.kindNameFonts];
    typeof(self) __weak weakSelf = self;
    [openPanel beginSheetModalForWindow:self.windowForSheet
                      completionHandler:^(NSInteger result) {
                          if (result != NSFileHandlingPanelOKButton) {
                              return;
                          }
                          [weakSelf addFontsFromPaths:[openPanel.URLs valueForKeyPath:VOKKeyForInstanceOf(NSURL, path)]];
                      }];
}

- (IBAction)removeFont:(TRUIncludedFontTreeObject *)sender
{
    if ([sender isKindOfClass:NSMenuItem.class]) {
        sender = ((NSMenuItem *)sender).representedObject;
    }
    NSAssert([sender isKindOfClass:TRUIncludedFontTreeObject.class], @"sender (%@) is not of the appropriate type", sender);
    NSFont *font = sender.font;
    if ([self.fontsInUse containsObject:font]) {
        // The font the user is trying to remove is still being used, so don't allow the removal.
        // TODO: offer to replace the font in all specs using that font?
        NSAlert *alert = [[NSAlert alloc] init];
        alert.alertStyle = NSWarningAlertStyle;
        alert.messageText = [TRULocalizedString alertRemoveFontInUseMessageTextWithFont:font];
        alert.informativeText = TRULocalizedString.alertRemoveFontInUseInformativeText;
        [alert beginSheetModalForWindow:self.windowForSheet
                      completionHandler:nil];
        return;
    }
    [self undoableRemoveFonts:@[ sender.includedFont, ]];
}

- (IBAction)replaceFont:(NSMenuItem *)sender
{
    TRUIncludedFontTreeObject *treeObject = sender.representedObject;
    NSAssert([treeObject isKindOfClass:TRUIncludedFontTreeObject.class], @"treeObject (%@) is not of the appropriate type", treeObject);
    TRUReplaceFontWindowController *replaceFontWindowController = [[TRUReplaceFontWindowController alloc] initWithWindowNibName:
                                                                   NSStringFromClass(TRUReplaceFontWindowController.class)];
    replaceFontWindowController.document = self;
    replaceFontWindowController.includedFontTreeObject = treeObject;
    [self.windowForSheet beginSheet:replaceFontWindowController.window
                  completionHandler:^(NSModalResponse __unused returnCode) {
                      // Make the completion handler capture the window controller so that the window controller is
                      // kept around for the duration of its presentation.
                      (void)replaceFontWindowController;
                  }];
}

- (void)addFontsFromPaths:(NSArray<NSString *> *)filePaths
{
    NSMutableArray<NSFont *> *fonts = [NSMutableArray array];
    for (NSString *filePath in filePaths) {
        NSData *fontData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]
                                                 options:NSDataReadingMappedIfSafe
                                                   error:NULL];
        if (!fontData) {
            continue;
        }
        for (NSFont *font in [NSFont casl_fontsFromData:fontData extension:filePath.pathExtension]) {
            [fonts addObject:font];
        }
    }
    [self undoableAddFonts:fonts];
}

@end
