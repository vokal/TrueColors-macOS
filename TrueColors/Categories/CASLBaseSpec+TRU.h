//
//  CASLBaseSpec+TRU.h
//  TrueColors
//
//  Created by Isaac Greenspan on 8/5/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLBaseSpec.h"

/**
 *  Add mechanics only used in the app to the base specification model.
 */
@interface CASLBaseSpec (TRU)

/**
 *  Remove the target specification.
 */
- (void)removeSpec;

/**
 *  Key-Value Validation on the name property
 */
- (BOOL)validateName:(NSString **)ioName
               error:(NSError **)outError;

/**
 *  Name the object automatically--e.g., as "New Spec" or "New Spec 2", etc., ensuring that path uniqueness is enforced.
 */
- (void)tru_autoName;

/**
 *  Name the object automatically--e.g., as "New Group", etc., ensuring that path uniqueness is enforced.
 */
- (void)tru_autoNameGroup;

/**
 *  Name the object automatically--e.g., as "Some Spec copy" or "Some Spec copy 2", etc., ensuring that path uniqueness is enforced.
 */
- (void)tru_autoNameCopy;

/**
 *  Whether the spec is "complete."
 */
@property (nonatomic, readonly) BOOL isComplete;

@end
