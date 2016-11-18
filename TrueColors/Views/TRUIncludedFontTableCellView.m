//
//  TRUIncludedFontTableCellView.m
//  TrueColors
//
//  Created by Isaac Greenspan on 10/3/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

#import "TRUIncludedFontTableCellView.h"

#import "TRUDocument.h"
#import "TRUIncludedFontTreeObject.h"
#import "TRULocalizedString.h"

@implementation TRUIncludedFontTableCellView

- (NSMenu *)menu
{
    TRUIncludedFontTreeObject *object = self.objectValue;
    if (object.members.count) {
        return nil;
    }
    
    NSString *title;
    SEL action;
    if (object.inUse) {
        title = [TRULocalizedString menuItemTitleReplace];
        action = @selector(replaceFont:);
    } else {
        title = [TRULocalizedString menuItemTitleRemove];
        action = @selector(removeFont:);
    }
    NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:title
                                                      action:action
                                               keyEquivalent:@""];
    menuItem.representedObject = object;
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItem:menuItem];
    return menu;
}

@end
