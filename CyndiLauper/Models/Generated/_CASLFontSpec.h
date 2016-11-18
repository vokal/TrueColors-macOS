// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CASLFontSpec.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "CASLBaseSpec.h"

NS_ASSUME_NONNULL_BEGIN

@class CASLColorSpec;
@class CASLIncludedFont;
@class CASLMetricSpec;

@interface CASLFontSpecID : CASLBaseSpecID {}
@end

@interface _CASLFontSpec : CASLBaseSpec
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CASLFontSpecID *objectID;

@property (nonatomic, strong, nullable) CASLColorSpec *colorSpec;

@property (nonatomic, strong, nullable) CASLIncludedFont *fontFace;

@property (nonatomic, strong, nullable) CASLMetricSpec *size;

@end

@interface _CASLFontSpec (CoreDataGeneratedPrimitiveAccessors)

- (CASLColorSpec*)primitiveColorSpec;
- (void)setPrimitiveColorSpec:(CASLColorSpec*)value;

- (CASLIncludedFont*)primitiveFontFace;
- (void)setPrimitiveFontFace:(CASLIncludedFont*)value;

- (CASLMetricSpec*)primitiveSize;
- (void)setPrimitiveSize:(CASLMetricSpec*)value;

@end

@interface CASLFontSpecRelationships: NSObject
+ (NSString *)colorSpec;
+ (NSString *)fontFace;
+ (NSString *)size;
@end

NS_ASSUME_NONNULL_END
