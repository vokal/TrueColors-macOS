//
//  CASLDocumentSerializerZipV1.m
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLDocumentSerializerZipV1.h"

#import <VOKUtilities/VOKKeyPathHelper.h>
#import <zipzap.h>

#import "NSFont+CASL.h"

#import "CASLLocalizedString.h"

#import "CASLDocumentSerializerJsonV1.h"

#import "CASLDocument.h"

#import "CASLFontSpec.h"

static NSString *const ArchiveFileNameJson = @"data.json";
static NSString *const ArchiveFileNameFlatJson = @"flat-data.json";
static NSString *const ArchiveDirNameFonts = @"fonts";

@implementation CASLDocumentSerializerZipV1

#pragma mark - CASLDocumentSerializerImplementation

+ (NSUInteger)serializerVersion
{
    return 20150621;  // 2015-06-21
}

+ (BOOL)canDeserializeURL:(NSURL *)url
{
    if (![ZZArchive archiveWithURL:url error:NULL]) {
        return NO;
    }
    
    return YES;  // This serializer presumes it can deserialize any given zip URL, since this is the earliest zip serializer.
}

+ (BOOL)readDocument:(CASLDocument *)document
             fromURL:(NSURL *)url
          colorClass:(Class)colorClass
         metricClass:(Class)metricClass
           fontClass:(Class)fontClass
               error:(NSError **)error
{
    ZZArchive *archive = [ZZArchive archiveWithURL:url error:error];
    if (!archive) {
        return NO;
    }
    
    ZZArchiveEntry *jsonEntry = archive.entries.lastObject;
    if (![ArchiveFileNameJson isEqualToString:jsonEntry.fileName.lastPathComponent]) {
        if (error) {
            *error = [NSError errorWithDomain:CASLDocumentSerializerErrorDomain
                                         code:0
                                     userInfo:@{
                                                NSLocalizedDescriptionKey:
                                                    CASLLocalizedString.errorDescriptionFileFormatNotRecognized,
                                                }];
        }
        return NO;
    }
    
    NSData *jsonData = [jsonEntry newDataWithError:error];
    if (!jsonData) {
        return NO;
    }
    
    // Load fonts.
    NSMutableDictionary *embeddedFonts = [NSMutableDictionary dictionary];
    NSString *fontPrefix = [jsonEntry.fileName.pathComponents.firstObject stringByAppendingPathComponent:ArchiveDirNameFonts];
    for (ZZArchiveEntry *entry in archive.entries) {
        if ([entry.fileName hasPrefix:fontPrefix]) {
            NSError *zzError;
            NSData *fontData = [entry newDataWithError:&zzError];
            if (!fontData) {
                if (error) {
                    *error = [NSError errorWithDomain:CASLDocumentSerializerErrorDomain
                                                 code:0
                                             userInfo:@{
                                                        NSLocalizedDescriptionKey:
                                                            CASLLocalizedString.errorDescriptionEmbeddedFontLoadFailed,
                                                        NSUnderlyingErrorKey: zzError,
                                                        }];
                }
                return NO;
            }
            for (NSFont *font in [NSFont casl_fontsFromData:fontData extension:entry.fileName.pathExtension]) {
                embeddedFonts[font.casl_embeddedFontFileName] = font;
            }
        }
    }
    
    return [CASLDocumentSerializerJsonV1 readDocument:document
                                             fromData:jsonData
                                           colorClass:colorClass
                                          metricClass:metricClass
                                            fontClass:fontClass
                                        embeddedFonts:embeddedFonts
                                                error:error];
}

+ (BOOL)writeDocument:(CASLDocument *)document
                toURL:(NSURL *)url
                error:(NSError **)error
{
    ZZArchive *archive = [[ZZArchive alloc] initWithURL:url
                                                options:@{
                                                          ZZOpenOptionsCreateIfMissingKey: @YES,
                                                          }
                                                  error:error];
    if (!archive) {
        return NO;
    }
    
    NSString *filename = url.lastPathComponent;
    if (filename.pathExtension) {
        filename = filename.stringByDeletingPathExtension;
    } else {
        filename = [filename stringByAppendingString:@" dir"];
    }
    NSString *fontDir = [filename stringByAppendingPathComponent:ArchiveDirNameFonts];
    NSMutableArray<ZZArchiveEntry *> *entries = [NSMutableArray arrayWithCapacity:(document.embeddedFonts.count + 2)];
    for (NSFont *font in document.embeddedFonts) {
        [entries addObject:[ZZArchiveEntry archiveEntryWithFileName:[fontDir stringByAppendingPathComponent:font.casl_embeddedFontFileName]
                                                           compress:YES
                                                          dataBlock:^NSData *(NSError *__autoreleasing *__unused error) {
                                                              return font.casl_embeddedFontData;
                                                          }]];
    };
    [entries addObject:[ZZArchiveEntry archiveEntryWithFileName:[filename stringByAppendingPathComponent:ArchiveFileNameFlatJson]
                                                       compress:YES
                                                      dataBlock:^NSData *(NSError *__autoreleasing *error) {
                                                          return [CASLDocumentSerializerJsonV1 flatDataFromDocument:document
                                                                                                              error:error];
                                                      }]];
    [entries addObject:[ZZArchiveEntry archiveEntryWithFileName:[filename stringByAppendingPathComponent:ArchiveFileNameJson]
                                                       compress:YES
                                                      dataBlock:^NSData *(NSError *__autoreleasing *error) {
                                                          return [CASLDocumentSerializerJsonV1 dataFromDocument:document
                                                                                                          error:error];
                                                      }]];
    if (![archive updateEntries:entries error:error]) {
        return NO;
    }
    
    return YES;
}

@end
