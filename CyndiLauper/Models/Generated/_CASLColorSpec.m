// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CASLColorSpec.m instead.

#import "_CASLColorSpec.h"

@implementation CASLColorSpecID
@end

@implementation _CASLColorSpec

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ColorSpec" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ColorSpec";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ColorSpec" inManagedObjectContext:moc_];
}

- (CASLColorSpecID*)objectID {
	return (CASLColorSpecID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic color;

@dynamic fontSpecs;

- (NSMutableSet<CASLFontSpec*>*)fontSpecsSet {
	[self willAccessValueForKey:@"fontSpecs"];

	NSMutableSet<CASLFontSpec*> *result = (NSMutableSet<CASLFontSpec*>*)[self mutableSetValueForKey:@"fontSpecs"];

	[self didAccessValueForKey:@"fontSpecs"];
	return result;
}

@end

@implementation CASLColorSpecAttributes 
+ (NSString *)color {
	return @"color";
}
@end

@implementation CASLColorSpecRelationships 
+ (NSString *)fontSpecs {
	return @"fontSpecs";
}
@end

