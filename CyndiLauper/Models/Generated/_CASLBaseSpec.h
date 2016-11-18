// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CASLBaseSpec.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class CASLBaseSpec;
@class CASLBaseSpec;

@interface CASLBaseSpecID : NSManagedObjectID {}
@end

@interface _CASLBaseSpec : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CASLBaseSpecID *objectID;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* root;

@property (atomic) BOOL rootValue;
- (BOOL)rootValue;
- (void)setRootValue:(BOOL)value_;

@property (nonatomic, strong, nullable) CASLBaseSpec *parentSpec;

@property (nonatomic, strong, nullable) NSOrderedSet<CASLBaseSpec*> *subSpecs;
- (nullable NSMutableOrderedSet<CASLBaseSpec*>*)subSpecsSet;

@end

@interface _CASLBaseSpec (SubSpecsCoreDataGeneratedAccessors)
- (void)addSubSpecs:(NSOrderedSet<CASLBaseSpec*>*)value_;
- (void)removeSubSpecs:(NSOrderedSet<CASLBaseSpec*>*)value_;
- (void)addSubSpecsObject:(CASLBaseSpec*)value_;
- (void)removeSubSpecsObject:(CASLBaseSpec*)value_;

- (void)insertObject:(CASLBaseSpec*)value inSubSpecsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSubSpecsAtIndex:(NSUInteger)idx;
- (void)insertSubSpecs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSubSpecsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSubSpecsAtIndex:(NSUInteger)idx withObject:(CASLBaseSpec*)value;
- (void)replaceSubSpecsAtIndexes:(NSIndexSet *)indexes withSubSpecs:(NSArray *)values;

@end

@interface _CASLBaseSpec (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveRoot;
- (void)setPrimitiveRoot:(NSNumber*)value;

- (BOOL)primitiveRootValue;
- (void)setPrimitiveRootValue:(BOOL)value_;

- (CASLBaseSpec*)primitiveParentSpec;
- (void)setPrimitiveParentSpec:(CASLBaseSpec*)value;

- (NSMutableOrderedSet<CASLBaseSpec*>*)primitiveSubSpecs;
- (void)setPrimitiveSubSpecs:(NSMutableOrderedSet<CASLBaseSpec*>*)value;

@end

@interface CASLBaseSpecAttributes: NSObject 
+ (NSString *)name;
+ (NSString *)root;
@end

@interface CASLBaseSpecRelationships: NSObject
+ (NSString *)parentSpec;
+ (NSString *)subSpecs;
@end

NS_ASSUME_NONNULL_END
