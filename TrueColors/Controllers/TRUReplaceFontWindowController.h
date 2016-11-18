//
//  TRUReplaceFontWindowController.h
//  TrueColors
//
//  Created by Isaac Greenspan on 10/3/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TRUIncludedFontTreeObject;

@interface TRUReplaceFontWindowController : NSWindowController

@property (nonatomic, strong) TRUIncludedFontTreeObject *includedFontTreeObject;

@end
