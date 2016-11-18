// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CASLColorSpec.h instead.

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

@class NSObject;

@interface CASLColorSpecID : CASLBaseSpecID {}
@end

@interface _CASLColorSpec : CASLBaseSpec
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CASLColorSpecID *objectID;

@property (nonatomic, strong, nullable) id color;

@property (nonatomic, strong, nullable) NSSet<CASLFontSpec*> *fontSpecs;
- (nullable NSMutableSet<CASLFontSpec*>*)fontSpecsSet;

@end

@interface _CASLColorSpec (FontSpecsCoreDataGeneratedAccessors)
- (void)addFontSpecs:(NSSet<CASLFontSpec*>*)value_;
- (void)removeFontSpecs:(NSSet<CASLFontSpec*>*)value_;
- (void)addFontSpecsObject:(CASLFontSpec*)value_;
- (void)removeFontSpecsObject:(CASLFontSpec*)value_;

@end

@interface _CASLColorSpec (CoreDataGeneratedPrimitiveAccessors)

- (id)primitiveColor;
- (void)setPrimitiveColor:(id)value;

- (NSMutableSet<CASLFontSpec*>*)primitiveFontSpecs;
- (void)setPrimitiveFontSpecs:(NSMutableSet<CASLFontSpec*>*)value;

@end

@interface CASLColorSpecAttributes: NSObject 
+ (NSString *)color;
@end

@interface CASLColorSpecRelationships: NSObject
+ (NSString *)fontSpecs;
@end

NS_ASSUME_NONNULL_END
