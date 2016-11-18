//
//  TRUBaseSpec.h
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLBaseSpec+TRU.h"

/// Applied on top of CASLBaseSpec to form TRUBaseSpec.
@protocol TRUBaseSpec <NSObject>

/**
 *  @return The localized name of the kind of spec that the class represents.
 */
+ (NSString *)localizedSpecKindName;

/**
 *  Remove the target specification.
 */
- (void)removeSpec;

@end

/**
 *  The pseudo-type formed by having CASLBaseSpec conform to the TRUBaseSpec protocol.
 */
typedef CASLBaseSpec<TRUBaseSpec> TRUBaseSpec;
