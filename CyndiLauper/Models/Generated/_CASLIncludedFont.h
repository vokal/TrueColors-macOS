// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CASLIncludedFont.h instead.

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

@interface CASLIncludedFontID : CASLBaseSpecID {}
@end

@interface _CASLIncludedFont : CASLBaseSpec
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CASLIncludedFontID *objectID;

@property (nonatomic, strong, nullable) id font;

@property (nonatomic, strong, nullable) NSSet<CASLFontSpec*> *fontSpecs;
- (nullable NSMutableSet<CASLFontSpec*>*)fontSpecsSet;

@end

@interface _CASLIncludedFont (FontSpecsCoreDataGeneratedAccessors)
- (void)addFontSpecs:(NSSet<CASLFontSpec*>*)value_;
- (void)removeFontSpecs:(NSSet<CASLFontSpec*>*)value_;
- (void)addFontSpecsObject:(CASLFontSpec*)value_;
- (void)removeFontSpecsObject:(CASLFontSpec*)value_;

@end

@interface _CASLIncludedFont (CoreDataGeneratedPrimitiveAccessors)

- (id)primitiveFont;
- (void)setPrimitiveFont:(id)value;

- (NSMutableSet<CASLFontSpec*>*)primitiveFontSpecs;
- (void)setPrimitiveFontSpecs:(NSMutableSet<CASLFontSpec*>*)value;

@end

@interface CASLIncludedFontAttributes: NSObject 
+ (NSString *)font;
@end

@interface CASLIncludedFontRelationships: NSObject
+ (NSString *)fontSpecs;
@end

NS_ASSUME_NONNULL_END
