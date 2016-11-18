// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CASLMetricSpec.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "CASLBaseSpec.h"

NS_ASSUME_NONNULL_BEGIN

@class CASLFontSpec;

@interface CASLMetricSpecID : CASLBaseSpecID {}
@end

@interface _CASLMetricSpec : CASLBaseSpec
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CASLMetricSpecID *objectID;

@property (nonatomic, strong, nullable) NSDecimalNumber* value;

@property (nonatomic, strong, nullable) NSSet<CASLFontSpec*> *fontSpecs;
- (nullable NSMutableSet<CASLFontSpec*>*)fontSpecsSet;

@end

@interface _CASLMetricSpec (FontSpecsCoreDataGeneratedAccessors)
- (void)addFontSpecs:(NSSet<CASLFontSpec*>*)value_;
- (void)removeFontSpecs:(NSSet<CASLFontSpec*>*)value_;
- (void)addFontSpecsObject:(CASLFontSpec*)value_;
- (void)removeFontSpecsObject:(CASLFontSpec*)value_;

@end

@interface _CASLMetricSpec (CoreDataGeneratedPrimitiveAccessors)

- (NSDecimalNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSDecimalNumber*)value;

- (NSMutableSet<CASLFontSpec*>*)primitiveFontSpecs;
- (void)setPrimitiveFontSpecs:(NSMutableSet<CASLFontSpec*>*)value;

@end

@interface CASLMetricSpecAttributes: NSObject 
+ (NSString *)value;
@end

@interface CASLMetricSpecRelationships: NSObject
+ (NSString *)fontSpecs;
@end

NS_ASSUME_NONNULL_END
