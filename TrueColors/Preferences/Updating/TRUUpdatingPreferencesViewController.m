//
//  TRUUpdatingPreferencesViewController.m
//  TrueColors
//
//  Created by Isaac Greenspan on 8/6/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUUpdatingPreferencesViewController.h"

#import "TRULocalizedString.h"

@interface TRUUpdatingPreferencesViewController ()

@end

@implementation TRUUpdatingPreferencesViewController

#pragma mark - MASPreferencesViewController

- (NSString *)identifier
{
    return NSStringFromClass(self.class);
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];  // TODO: get a better icon for this
}

- (NSString *)toolbarItemLabel
{
    return TRULocalizedString.preferencesUpdating;
}

@end
