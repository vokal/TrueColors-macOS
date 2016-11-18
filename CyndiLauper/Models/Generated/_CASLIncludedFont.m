// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CASLIncludedFont.m instead.

#import "_CASLIncludedFont.h"

@implementation CASLIncludedFontID
@end

@implementation _CASLIncludedFont

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"IncludedFont" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"IncludedFont";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"IncludedFont" inManagedObjectContext:moc_];
}

- (CASLIncludedFontID*)objectID {
	return (CASLIncludedFontID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic font;

@dynamic fontSpecs;

- (NSMutableSet<CASLFontSpec*>*)fontSpecsSet {
	[self willAccessValueForKey:@"fontSpecs"];

	NSMutableSet<CASLFontSpec*> *result = (NSMutableSet<CASLFontSpec*>*)[self mutableSetValueForKey:@"fontSpecs"];

	[self didAccessValueForKey:@"fontSpecs"];
	return result;
}

@end

@implementation CASLIncludedFontAttributes 
+ (NSString *)font {
	return @"font";
}
@end

@implementation CASLIncludedFontRelationships 
+ (NSString *)fontSpecs {
	return @"fontSpecs";
}
@end

