//
//  NSTableRowView+TRU.h
//  TrueColors
//
//  Created by Isaac Greenspan on 9/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MAKVONotificationCenter/MAKVONotificationCenter.h>

/**
 *  Add property to hold an opaque observation object.
 */
@interface NSTableRowView (TRU)

/**
 *  The observation used to track changes in a specification's completeness.
 */
@property (nonatomic, strong) id<MAKVOObservation> tru_specCompleteObservation;

@end
