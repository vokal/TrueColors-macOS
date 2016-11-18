//
//  CASLDocumentSerializerImplementation.h
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CASLDocument;

@protocol CASLDocumentSerializerImplementation <NSObject>

/**
 *  A number identifying the serializer version, for priority/sorting purposes.  Should be unique across all 
 *  serializers.  YYYYMMDD of format definition.
 *
 *  @return Unsigned integer identifying the serializer version among all serializers.
 */
+ (NSUInteger)serializerVersion;

/**
 *  Determine if the data at a URL can be deserialized by the recceiving deserializer class.
 *
 *  @param url The URL from which to read
 *
 *  @return YES if the receiving class can deserialize the data, otherwise NO.
 */
+ (BOOL)canDeserializeURL:(NSURL *)url;

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
