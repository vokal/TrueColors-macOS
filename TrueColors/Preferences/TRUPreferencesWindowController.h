//
//  TRUPreferencesWindowController.h
//  TrueColors
//
//  Created by Isaac Greenspan on 8/6/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "MASPreferencesWindowController.h"

/**
 *  Window controller for the preferences window.
 */
@interface TRUPreferencesWindowController : MASPreferencesWindowController

/**
 *  Get the shared singleton preferences window controller.
 *
 *  @return The preferences window controller
 */
+ (instancetype)preferencesWindowController;

@end
