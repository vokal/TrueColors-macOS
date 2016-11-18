//
//  CASLDocumentSerializer.h
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/18/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Struct to define the keys used when serializing to JSON.
 */
struct CASLDocumentJsonKeys {
    /// The key for the set of color specifications.
    __unsafe_unretained NSString *colors;
    /// The key for the set of metric specifications.
    __unsafe_unretained NSString *metrics;
    /// The key for the set of text style specifications.
    __unsafe_unretained NSString *fonts;
    /// The key for the name of a specification.
    __unsafe_unretained NSString *name;
    /// The key for the path of a specification.
    __unsafe_unretained NSString *path;
    /// The key for the sub-specifications of a specification.
    __unsafe_unretained NSString *subSpecs;
    /// The key for the color value of a color specification.
    __unsafe_unretained NSString *color;
    /// The key for the numerical value of a metric specification.
    __unsafe_unretained NSString *value;
    /// The key for the font name of a text style specification.
    __unsafe_unretained NSString *fontName;
    /// The key for the font filename of a text style specification.
    __unsafe_unretained NSString *fileName;
    /// The key for the path to the metric specification defining the size of a text style specification.
    __unsafe_unretained NSString *sizePath;
    /// The key for the path to the color specification defining the color of a text style specification.
    __unsafe_unretained NSString *colorPath;
};

/**
 *  Type for the structure defining the keys used when serializing to JSON.
 */
typedef const struct CASLDocumentJsonKeys CASLDocumentJsonKeys;

/**
 *  The error domain used for serialization errors.
 */
FOUNDATION_EXPORT NSString *const CASLDocumentSerializerErrorDomain;

@class CASLDocument;

/**
 *  The class for reading/writing .truecolors documents.
 */
@interface CASLDocumentSerializer : NSObject

/**
 *  Read the contents of a URL into a CASLDocument object.
 *
 *  @param document    The CASLDocument object into which to read the contents of the URL
 *  @param url         The URL from which to read
 *  @param colorClass  The CASLColorSpec subclass to use when creating colors (pass Nil to use CASLColorSpec)
 *  @param metricClass The CASLMetricSpec subclass to use when creating metrics (pass Nil to use CASLMetricSpec)
 *  @param fontClass   The CASLFontSpec subclass to use when creating fonts (pass Nil to use CASLFontSpec)
 *  @param error       If an error occurs, upon return contains an NSError object that describes the problem
 *
 *  @return YES if the operation succeeds, otherwise NO.
 */
+ (BOOL)readDocument:(CASLDocument *)document
             fromURL:(NSURL *)url
          colorClass:(Class)colorClass
         metricClass:(Class)metricClass
           fontClass:(Class)fontClass
               error:(NSError **)error;

/**
 *  Write the contents of a CASLDocument object to a URL.
 *
 *  @param document The CASLDocument object to write
 *  @param url      The URL to which to write the document
 *  @param error    If an error occurs, upon return contains an NSError object that describes the problem
 *
 *  @return YES if the operation succeeds, otherwise NO.
 */
+ (BOOL)writeDocument:(CASLDocument *)document
                toURL:(NSURL *)url
                error:(NSError **)error;

@end
