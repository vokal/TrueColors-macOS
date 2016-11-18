// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CASLMetricSpec.m instead.

#import "_CASLMetricSpec.h"

@implementation CASLMetricSpecID
@end

@implementation _CASLMetricSpec

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MetricSpec" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MetricSpec";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MetricSpec" inManagedObjectContext:moc_];
}

- (CASLMetricSpecID*)objectID {
	return (CASLMetricSpecID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic value;

@dynamic fontSpecs;

- (NSMutableSet<CASLFontSpec*>*)fontSpecsSet {
	[self willAccessValueForKey:@"fontSpecs"];

	NSMutableSet<CASLFontSpec*> *result = (NSMutableSet<CASLFontSpec*>*)[self mutableSetValueForKey:@"fontSpecs"];

	[self didAccessValueForKey:@"fontSpecs"];
	return result;
}

@end

@implementation CASLMetricSpecAttributes 
+ (NSString *)value {
	return @"value";
}
@end

@implementation CASLMetricSpecRelationships 
+ (NSString *)fontSpecs {
	return @"fontSpecs";
}
@end

