//
//  CASLBaseSpec.h
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "_CASLBaseSpec.h"

#import "CASLDocumentSerializer.h"

@class CASLColorSpec;
@class CASLMetricSpec;

// The #defines below should actually be these typedefs, but using these typedefs breaks KVC.
//typedef NSArray<NSString *> CASLSpecPath;
//typedef NSMutableArray<NSString *> CASLMutableSpecPath;
#define CASLSpecPath NSArray<NSString *>
#define CASLMutableSpecPath NSMutableArray<NSString *>

/**
 *  The base class for specifications.
 */
@interface CASLBaseSpec : _CASLBaseSpec

/**
 *  Whether the spec has sub-specs.
 */
@property (nonatomic, readonly) BOOL hasSubSpecs;

/**
 *  The index path of the spec within its containing tree controller.
 */
@property (nonatomic, readonly) NSIndexPath *indexPath;

#pragma mark - — Serialization/Deserialization —

/**
 *  A default set of JSON keys.
 *
 *  @return The JSON keys.
 */
+ (CASLDocumentJsonKeys)defaultJsonKeys;

#pragma mark Instance to JSON-serializable dictionary

/**
 *  Construct the JSON-serializable representation of the receiver.
 *
 *  @param keys The struct containing the keys to use in the JSON
 *
 *  @return A dictionary containing only JSON-serializable object types.
 */
- (NSDictionary *)jsonSerializableRepresentationWithKeys:(CASLDocumentJsonKeys)keys;

#pragma mark Array of instances to array of JSON-serializable dictionaries

/**
 *  Construct an array of JSON-serializable representations of the objects in the given array.
 *
 *  @param array The (CASLBaseSpec) objects to convert
 *  @param keys  The struct containing the keys to use in the JSON
 *
 *  @return An array containing only JSON-serializable object types.
 */
+ (NSArray<NSDictionary *> *)jsonSerializableRepresentationOfArray:(NSArray<CASLBaseSpec *> *)array
                                                          withKeys:(CASLDocumentJsonKeys)keys;

#pragma mark Construct instance(s) from JSON dictionary/array

/**
 *  Construct a spec object from the JSON representation of that object, given the data for all colors and metrics.
 *
 *  Use this method when the object is expected to have references to colors and metrics, so that those references can
 *  be properly deserialized.
 *
 *  @param jsonRepresentation The JSON dictionary
 *  @param keys               The struct containing the keys to use in the JSON
 *  @param colors             An array (not necessarily flat) of CASLColorSpec objects
 *  @param metrics            An array (not necessarily flat) of CASLMetricSpec objects
 *  @param embeddedFonts      A dictionary mapping font filenames to NSFont objects.
 *
 *  @return The spec
 */
+ (instancetype)fromJsonRepresentation:(NSDictionary *)jsonRepresentation
                              withKeys:(CASLDocumentJsonKeys)keys
                                colors:(NSArray<CASLColorSpec *> *)colors
                               metrics:(NSArray<CASLMetricSpec *> *)metrics
                         embeddedFonts:(NSDictionary<NSString *, NSFont *> *)embeddedFonts
                               context:(NSManagedObjectContext *)context;

/**
 *  Construct a mutable array of spec objects from a JSON array of representations of that object type.
 *
 *  @param jsonArray The JSON array
 *  @param keys      The struct containing the keys to use in the JSON
 *
 *  @return A mutable array containing the specs
 */
+ (NSOrderedSet<__kindof CASLBaseSpec *> *)orderedSetFromJsonArray:(NSArray<NSDictionary *> *)jsonArray
                                                          withKeys:(CASLDocumentJsonKeys)keys
                                                           context:(NSManagedObjectContext *)context;

/**
 *  Construct a mutable array of spec objects from a JSON array of representations of that object type, given the data
 *  for all colors and metrics.
 *
 *  Use this method when the objects are expected to have references to colors and metrics, so that those references can
 *  be properly deserialized.
 *
 *  @param jsonArray     The JSON array
 *  @param keys          The struct containing the keys to use in the JSON
 *  @param colors        An array (not necessarily flat) of CASLColorSpec objects
 *  @param metrics       An array (not necessarily flat) of CASLMetricSpec objects
 *  @param embeddedFonts A dictionary mapping font filenames to NSFont objects.
 *
 *  @return A mutable array containing the specs
 */
+ (NSOrderedSet<__kindof CASLBaseSpec *> *)orderedSetFromJsonArray:(NSArray<NSDictionary *> *)jsonArray
                                                          withKeys:(CASLDocumentJsonKeys)keys
                                                            colors:(NSArray<CASLColorSpec *> *)colors
                                                           metrics:(NSArray<CASLMetricSpec *> *)metrics
                                                     embeddedFonts:(NSDictionary<NSString *, NSFont *> *)embeddedFonts
                                                           context:(NSManagedObjectContext *)context;

#pragma mark - Paths in hierarchical arrays

/**
 *  The "path" of the receiver within its heirarchy.
 *
 *  See specWithPath:inArray: for the definition of path.
 */
@property (nonatomic, readonly) CASLSpecPath *path;

/**
 *  Get a spec from within an array (not necessarily flat) based on a given "path".
 *
 *  @param path  An array of the name(s) of the containers from the given array, down into the specs, ending with the name of the target spec itself
 *  @param array An array (not necessarily flat) from which to get the object
 *
 *  @return The object matching the given path in the given array (nil if not found)
 */
+ (instancetype)specWithPath:(CASLSpecPath *)path inArray:(NSArray<CASLBaseSpec *> *)array;

@end
