// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CASLBaseSpec.m instead.

#import "_CASLBaseSpec.h"

@implementation CASLBaseSpecID
@end

@implementation _CASLBaseSpec

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BaseSpec" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BaseSpec";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BaseSpec" inManagedObjectContext:moc_];
}

- (CASLBaseSpecID*)objectID {
	return (CASLBaseSpecID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"rootValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"root"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic name;

@dynamic root;

- (BOOL)rootValue {
	NSNumber *result = [self root];
	return [result boolValue];
}

- (void)setRootValue:(BOOL)value_ {
	[self setRoot:@(value_)];
}

- (BOOL)primitiveRootValue {
	NSNumber *result = [self primitiveRoot];
	return [result boolValue];
}

- (void)setPrimitiveRootValue:(BOOL)value_ {
	[self setPrimitiveRoot:@(value_)];
}

@dynamic parentSpec;

@dynamic subSpecs;

- (NSMutableOrderedSet<CASLBaseSpec*>*)subSpecsSet {
	[self willAccessValueForKey:@"subSpecs"];

	NSMutableOrderedSet<CASLBaseSpec*> *result = (NSMutableOrderedSet<CASLBaseSpec*>*)[self mutableOrderedSetValueForKey:@"subSpecs"];

	[self didAccessValueForKey:@"subSpecs"];
	return result;
}

@end

@implementation _CASLBaseSpec (SubSpecsCoreDataGeneratedAccessors)
- (void)addSubSpecs:(NSOrderedSet<CASLBaseSpec*>*)value_ {
	[self.subSpecsSet unionOrderedSet:value_];
}
- (void)removeSubSpecs:(NSOrderedSet<CASLBaseSpec*>*)value_ {
	[self.subSpecsSet minusOrderedSet:value_];
}
- (void)addSubSpecsObject:(CASLBaseSpec*)value_ {
	[self.subSpecsSet addObject:value_];
}
- (void)removeSubSpecsObject:(CASLBaseSpec*)value_ {
	[self.subSpecsSet removeObject:value_];
}
- (void)insertObject:(CASLBaseSpec*)value inSubSpecsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"subSpecs"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self subSpecs]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"subSpecs"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"subSpecs"];
}
- (void)removeObjectFromSubSpecsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"subSpecs"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self subSpecs]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"subSpecs"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"subSpecs"];
}
- (void)insertSubSpecs:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"subSpecs"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self subSpecs]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"subSpecs"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"subSpecs"];
}
- (void)removeSubSpecsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"subSpecs"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self subSpecs]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"subSpecs"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"subSpecs"];
}
- (void)replaceObjectInSubSpecsAtIndex:(NSUInteger)idx withObject:(CASLBaseSpec*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"subSpecs"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self subSpecs]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"subSpecs"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"subSpecs"];
}
- (void)replaceSubSpecsAtIndexes:(NSIndexSet *)indexes withSubSpecs:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"subSpecs"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self subSpecs]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"subSpecs"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"subSpecs"];
}
@end

@implementation CASLBaseSpecAttributes 
+ (NSString *)name {
	return @"name";
}
+ (NSString *)root {
	return @"root";
}
@end

@implementation CASLBaseSpecRelationships 
+ (NSString *)parentSpec {
	return @"parentSpec";
}
+ (NSString *)subSpecs {
	return @"subSpecs";
}
@end

