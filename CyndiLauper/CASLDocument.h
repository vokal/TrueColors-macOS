//
//  CASLDocument.h
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CASLColorSpec;
@class CASLMetricSpec;
@class CASLFontSpec;
@class CASLBaseSpec;
@class VOKCoreDataManager;

/**
 *  Represent the contents of a .truecolors document.
 */
@interface CASLDocument : NSObject

/**
 *  The core data manager that manages the storage for the document.
 */
@property (nonatomic, readonly) VOKCoreDataManager *coreDataManager;

/**
 *  The primary main-queue context associated with coreDataManager.
 */
@property (nonatomic, readonly) NSManagedObjectContext *context;

@property (nonatomic, strong) CASLBaseSpec *rootColorSpec;
@property (nonatomic, strong) CASLBaseSpec *rootMetricSpec;
@property (nonatomic, strong) CASLBaseSpec *rootIncludedFonts;
@property (nonatomic, strong) CASLBaseSpec *rootFontSpec;

/**
 *  The specifications for colors.
 */
@property (nonatomic, readonly) NSArray<CASLColorSpec *> *colorSpecs;

/**
 *  The specifications for metrics.
 */
@property (nonatomic, readonly) NSArray<CASLMetricSpec *> *metricSpecs;

/**
 *  The specifications for text styles.
 */
@property (nonatomic, readonly) NSArray<CASLFontSpec *> *fontSpecs;

/**
 *  The fonts embedded in the document.
 */
@property (nonatomic, readonly) NSArray<NSFont *> *embeddedFonts;

/**
 *  Write the contents of the receiver to a URL.
 *
 *  @param url      The URL to which to write
 *  @param outError If an error occurs, upon return contains an NSError object that describes the problem
 *
 *  @return YES if the operation succeeds, otherwise NO.
 */
- (BOOL)writeToURL:(NSURL *)url
             error:(NSError **)outError;

/**
 *  Construct a document from the contents of a URL.
 *
 *  @param url         The URL from which to read
 *  @param colorClass  The CASLColorSpec subclass to use when creating colors (pass Nil to use CASLColorSpec)
 *  @param metricClass The CASLMetricSpec subclass to use when creating metrics (pass Nil to use CASLMetricSpec)
 *  @param fontClass   The CASLFontSpec subclass to use when creating fonts (pass Nil to use CASLFontSpec)
 *  @param outError    If an error occurs, upon return contains an NSError object that describes the problem
 *
 *  @return The document.
 */
+ (instancetype)readFromURL:(NSURL *)url
                 colorClass:(Class)colorClass
                metricClass:(Class)metricClass
                  fontClass:(Class)fontClass
                      error:(NSError **)outError;

/**
 *  Initialize an empty document.
 *
 *  @param colorClass  The CASLColorSpec subclass to use when creating colors (pass Nil to use CASLColorSpec)
 *  @param metricClass The CASLMetricSpec subclass to use when creating metrics (pass Nil to use CASLMetricSpec)
 *  @param fontClass   The CASLFontSpec subclass to use when creating fonts (pass Nil to use CASLFontSpec)
 *
 *  @return The document.
 */
- (instancetype)initWithColorClass:(Class)colorClass
                       metricClass:(Class)metricClass
                         fontClass:(Class)fontClass
NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

