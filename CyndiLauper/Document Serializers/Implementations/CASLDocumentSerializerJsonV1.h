//
//  CASLDocumentSerializerBuild38.h
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLDocumentSerializerImplementation.h"

#import "CASLDocumentSerializer.h"

@interface CASLDocumentSerializerJsonV1 : NSObject <CASLDocumentSerializerImplementation>

/**
 *  Read NSData into a CASLDocument object.
 *
 *  @param document      The CASLDocument object into which to read the data
 *  @param data          The NSData from which to read
 *  @param colorClass    The CASLColorSpec subclass to use when creating colors (pass Nil to use CASLColorSpec)
 *  @param metricClass   The CASLMetricSpec subclass to use when creating metrics (pass Nil to use CASLMetricSpec)
 *  @param fontClass     The CASLFontSpec subclass to use when creating fonts (pass Nil to use CASLFontSpec)
 *  @param embeddedFonts A dictionary mapping font filenames to NSFont objects.
 *  @param error         If an error occurs, upon return contains an NSError object that describes the problem
 *
 *  @return YES if the operation succeeds, otherwise NO.
 */
+ (BOOL)readDocument:(CASLDocument *)document
            fromData:(NSData *)data
          colorClass:(Class)colorClass
         metricClass:(Class)metricClass
           fontClass:(Class)fontClass
       embeddedFonts:(NSDictionary *)embeddedFonts
               error:(NSError **)error;

/**
 *  Get the contents of a CASLDocument object as NSData.
 *
 *  @param document The CASLDocument object from which to get the data
 *  @param error    If an error occurs, upon return contains an NSError object that describes the problem
 *
 *  @return YES if the operation succeeds, otherwise NO.
 */
+ (NSData *)dataFromDocument:(CASLDocument *)document
                       error:(NSError **)error;

/**
 *  Get the contents of a CASLDocument object in a flat format as NSData.
 *
 *  @param document The CASLDocument object from which to get the data
 *  @param error    If an error occurs, upon return contains an NSError object that describes the problem
 *
 *  @return YES if the operation succeeds, otherwise NO.
 */
+ (NSData *)flatDataFromDocument:(CASLDocument *)document
                           error:(NSError **)error;

/**
 *  Get the keys used in the JSON as read/written by this serializer.
 *
 *  @return The keys used in the JSON as read/written by this serializer.
 */
+ (CASLDocumentJsonKeys)jsonKeys;

@end
