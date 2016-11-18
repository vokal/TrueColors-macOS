//
//  TRUPreferencesWindowController.m
//  TrueColors
//
//  Created by Isaac Greenspan on 8/6/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUPreferencesWindowController.h"

#import "TRULocalizedString.h"

#import "TRUUpdatingPreferencesViewController.h"

@implementation TRUPreferencesWindowController

+ (instancetype)preferencesWindowController
{
    static TRUPreferencesWindowController *preferencesWindowController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preferencesWindowController = [[self alloc]
                                       initWithViewControllers:@[
                                                                 [[TRUUpdatingPreferencesViewController alloc] init],
                                                                 // Put other preference-pane VCs here.
                                                                 ]
                                       title:TRULocalizedString.preferencesTitle];
    });
    return preferencesWindowController;
}

@end
