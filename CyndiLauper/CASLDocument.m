//
//  CASLDocument.m
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLDocument.h"

#import <Vokoder/VOKCoreDataManager.h>
#import <VOKUtilities/VOKKeyPathHelper.h>

#import "NSManagedObjectModel+CASL.h"

#import "CASLDocumentSerializer.h"

#import "CASLColorSpec.h"
#import "CASLMetricSpec.h"
#import "CASLFontSpec.h"
#import "CASLIncludedFont.h"

@interface CASLDocument ()

@property (nonatomic, strong, readwrite) VOKCoreDataManager *coreDataManager;

@end



@interface VOKCoreDataManager ()
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end



@implementation CASLDocument

- (instancetype)initWithColorClass:(Class)colorClass
                       metricClass:(Class)metricClass
                         fontClass:(Class)fontClass
{
    self = [super init];
    if (self) {
        NSManagedObjectModel *managedObjectModel = NSManagedObjectModel.casl_model;
        NSAssert(managedObjectModel, @"Error getting maanged object model.");
        for (NSEntityDescription *entityDescription in managedObjectModel.entities) {
            if (colorClass && [entityDescription.managedObjectClassName isEqualToString:NSStringFromClass(CASLColorSpec.class)]) {
                entityDescription.managedObjectClassName = NSStringFromClass(colorClass);
            } else if (metricClass && [entityDescription.managedObjectClassName isEqualToString:NSStringFromClass(CASLMetricSpec.class)]) {
                entityDescription.managedObjectClassName = NSStringFromClass(metricClass);
            } else if (fontClass && [entityDescription.managedObjectClassName isEqualToString:NSStringFromClass(CASLFontSpec.class)]) {
                entityDescription.managedObjectClassName = NSStringFromClass(fontClass);
            }
        }
        _coreDataManager = [[VOKCoreDataManager alloc] init];
        _coreDataManager.managedObjectModel = managedObjectModel;
        
        _rootColorSpec = (CASLBaseSpec *)[_coreDataManager managedObjectOfClass:CASLBaseSpec.class
                                                                      inContext:nil];
        _rootMetricSpec = (CASLBaseSpec *)[_coreDataManager managedObjectOfClass:CASLBaseSpec.class
                                                                       inContext:nil];
        _rootIncludedFonts = (CASLBaseSpec *)[_coreDataManager managedObjectOfClass:CASLBaseSpec.class
                                                                          inContext:nil];
        _rootFontSpec = (CASLBaseSpec *)[_coreDataManager managedObjectOfClass:CASLBaseSpec.class
                                                                     inContext:nil];
    }
    return self;
}

- (BOOL)writeToURL:(NSURL *)url
             error:(NSError **)outError
{
    return [CASLDocumentSerializer writeDocument:self
                                           toURL:url
                                           error:outError];
}

+ (instancetype)readFromURL:(NSURL *)url
                 colorClass:(Class)colorClass
                metricClass:(Class)metricClass
                  fontClass:(Class)fontClass
                      error:(NSError **)outError
{
    CASLDocument *document = [[self alloc] initWithColorClass:colorClass
                                                  metricClass:metricClass
                                                    fontClass:fontClass];
    if (![CASLDocumentSerializer readDocument:document
                                      fromURL:url
                                   colorClass:colorClass
                                  metricClass:metricClass
                                    fontClass:fontClass
                                        error:outError]) {
        return nil;
    }
    
    [document.context processPendingChanges];
    [document.context.undoManager removeAllActions];
    
    return document;
}

#pragma mark -

- (NSArray<NSString *> *)linesRecursivelyDescribingArrayOfSpecs:(NSArray<CASLBaseSpec *> *)specs
{
    NSMutableArray<NSString *> *result = [NSMutableArray arrayWithCapacity:specs.count];
    for (CASLBaseSpec *spec in specs) {
        [result addObjectsFromArray:[self linesRecursivelyDescribingSpec:spec]];
    }
    return result;
}

- (NSArray<NSString *> *)linesRecursivelyDescribingSpec:(CASLBaseSpec *)spec
{
    NSMutableArray<NSString *> *result = [NSMutableArray arrayWithObject:spec.description];
    for (NSString *descriptionLine in [self linesRecursivelyDescribingArrayOfSpecs:spec.subSpecs.array]) {
        [result addObject:[@"| " stringByAppendingString:descriptionLine]];
    }
    return result;
}

- (NSString *)recursiveDescription
{
    return [NSString stringWithFormat:@"Colors:\n%@\nMetrics:\n%@\nFonts:\n%@",
            [[self linesRecursivelyDescribingArrayOfSpecs:self.colorSpecs] componentsJoinedByString:@"\n"],
            [[self linesRecursivelyDescribingArrayOfSpecs:self.metricSpecs] componentsJoinedByString:@"\n"],
            [[self linesRecursivelyDescribingArrayOfSpecs:self.fontSpecs] componentsJoinedByString:@"\n"]
            ];
}

#pragma mark - Derived (readonly) properties

- (NSManagedObjectContext *)context
{
    return self.coreDataManager.managedObjectContext;
}

- (NSArray<CASLColorSpec *> *)colorSpecs
{
    return (NSArray<CASLColorSpec *> *)self.rootColorSpec.subSpecs.array;
}

- (NSArray<CASLMetricSpec *> *)metricSpecs
{
    return (NSArray<CASLMetricSpec *> *)self.rootMetricSpec.subSpecs.array;
}

- (NSArray<CASLFontSpec *> *)fontSpecs
{
    return (NSArray<CASLFontSpec *> *)self.rootFontSpec.subSpecs.array;
}

- (NSArray<NSFont *> *)embeddedFonts
{
    return [self.rootIncludedFonts.subSpecs.array valueForKeyPath:CASLIncludedFontAttributes.font];
}

@end
