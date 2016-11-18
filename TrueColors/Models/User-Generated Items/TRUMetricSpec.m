//
//  TRUMetricSpec.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUMetricSpec.h"

#import "TRULocalizedString.h"

@implementation TRUMetricSpec

+ (NSString *)localizedSpecKindName
{
    return TRULocalizedString.specKindNameMetric;
}

- (BOOL)isComplete
{
    return !!self.value;  // !! to boolify.
}

+ (NSSet *)keyPathsForValuesAffectingIsComplete
{
    return [NSSet setWithArray:@[
                                 VOKKeyForSelf(value),
                                 ]];
}

#pragma mark - Overridden setters for undo/redo

- (void)setValue:(NSDecimalNumber *)value
{
    if (self.value != value) {
        [self.managedObjectContext.undoManager setActionName:TRULocalizedString.undoActionNameSetMetricValue];
        [self willChangeValueForKey:VOKKeyForSelf(value)];
        [self setPrimitiveValue:value];
        [self didChangeValueForKey:VOKKeyForSelf(value)];
    }
}

@end
