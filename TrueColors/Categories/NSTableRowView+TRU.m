//
//  NSTableRowView+TRU.m
//  TrueColors
//
//  Created by Isaac Greenspan on 9/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "NSTableRowView+TRU.h"

#import <objc/runtime.h>

static const void *ObservationKey = &ObservationKey;

@implementation NSTableRowView (TRU)

- (id<MAKVOObservation>)tru_specCompleteObservation
{
    return objc_getAssociatedObject(self, ObservationKey);
}

- (void)setTru_specCompleteObservation:(id<MAKVOObservation>)tru_specCompleteObservation
{
    objc_setAssociatedObject(self, ObservationKey, tru_specCompleteObservation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
