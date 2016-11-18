//
//  NSManagedObjectModel+CASL.m
//  Pods
//
//  Created by Isaac Greenspan on 11/17/16.
//
//

#import "NSManagedObjectModel+CASL.h"

#import "CASLSpecsModel.h"

@implementation NSManagedObjectModel (CASL)

+ (instancetype)casl_model
{
    NSError *error;
    NSURL *cacheDirURL = [NSFileManager.defaultManager URLForDirectory:NSCachesDirectory
                                                              inDomain:NSUserDomainMask
                                                     appropriateForURL:nil
                                                                create:YES
                                                                 error:&error];
    if (!cacheDirURL) {
        NSLog(@"Error getting cache directory: %@", error);
        return nil;
    }
    cacheDirURL = [cacheDirURL URLByAppendingPathComponent:@"io.vokal.CASL"];
    if (![NSFileManager.defaultManager createDirectoryAtURL:cacheDirURL
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:&error]) {
        NSLog(@"Error creating cache directory: %@", error);
        return nil;
    }
    NSURL *dataModelURL = [cacheDirURL URLByAppendingPathComponent:@"CASLSpecs.mom"];
    if (![[NSData dataWithBytes:CASLSpecs_momd_CASLSpecs_mom length:CASLSpecs_momd_CASLSpecs_mom_len]
          writeToURL:dataModelURL
          options:NSDataWritingAtomic
          error:&error]) {
        NSLog(@"Error writing data model: %@", error);
        return nil;
    }
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:dataModelURL];
}

@end
