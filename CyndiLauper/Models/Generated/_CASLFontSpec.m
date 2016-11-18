// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CASLFontSpec.m instead.

#import "_CASLFontSpec.h"

@implementation CASLFontSpecID
@end

@implementation _CASLFontSpec

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FontSpec" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FontSpec";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FontSpec" inManagedObjectContext:moc_];
}

- (CASLFontSpecID*)objectID {
	return (CASLFontSpecID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic colorSpec;

@dynamic fontFace;

@dynamic size;

@end

@implementation CASLFontSpecRelationships 
+ (NSString *)colorSpec {
	return @"colorSpec";
}
+ (NSString *)fontFace {
	return @"fontFace";
}
+ (NSString *)size {
	return @"size";
}
@end

