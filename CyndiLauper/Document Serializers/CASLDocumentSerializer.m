//
//  CASLDocumentSerializer.m
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/18/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLDocumentSerializer.h"

#import <ILGDynamicObjC/ILGClasses.h>
#import <VOKUtilities/VOKKeyPathHelper.h>

#import "CASLDocument.h"
#import "CASLDocumentSerializerImplementation.h"
#import "CASLLocalizedString.h"

NSString *const CASLDocumentSerializerErrorDomain = @"io.vokal.TrueColors.CASLDocumentSerializerErrorDomain";

@implementation CASLDocumentSerializer

+ (NSArray<Class> *)serializerImplementationClasses
{
    static NSArray<Class> *serializerImplementationClasses;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serializerImplementationClasses = [[ILGClasses classesConformingToProtocol:@protocol(CASLDocumentSerializerImplementation)]
                                           sortedArrayUsingDescriptors:@[
                                                                         [NSSortDescriptor
                                                                          sortDescriptorWithKey:VOKKeyForClass([NSObject class], serializerVersion)  // Not a very strong check, but better than nothing (ensuring a class method exists on a specific protocol is hard/impossible).
                                                                          ascending:NO],
                                                                         ]];
    });
    return serializerImplementationClasses;
}

+ (Class)currentSerializer
{
    return [self serializerImplementationClasses].firstObject;
}

+ (Class)serializerForURL:(NSURL *)url
{
    for (Class class in [self serializerImplementationClasses]) {
        if ([class canDeserializeURL:url]) {
            return class;
        }
    }
    return Nil;
}

+ (BOOL)readDocument:(CASLDocument *)document
             fromURL:(NSURL *)url
          colorClass:(Class)colorClass
         metricClass:(Class)metricClass
           fontClass:(Class)fontClass
               error:(NSError **)error
{
    Class serializerClass = [self serializerForURL:url];
    if (!serializerClass) {
        if (error) {
             *error = [NSError errorWithDomain:CASLDocumentSerializerErrorDomain
                                          code:0
                                      userInfo:@{
                                                 NSLocalizedDescriptionKey:
                                                     CASLLocalizedString.errorDescriptionFileFormatNotRecognized,
                                                 }];
        }
        return NO;
    }
    
    return [serializerClass readDocument:document
                                 fromURL:url
                              colorClass:colorClass
                             metricClass:metricClass
                               fontClass:fontClass
                                   error:error];
}

+ (BOOL)writeDocument:(CASLDocument *)document
                toURL:(NSURL *)url
                error:(NSError **)error
{
    Class serializerClass = [self currentSerializer];
    return [serializerClass writeDocument:document
                                    toURL:url
                                    error:error];
}

@end
