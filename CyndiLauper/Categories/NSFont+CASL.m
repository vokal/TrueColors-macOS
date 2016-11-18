//
//  NSFont+CASL.m
//  CyndiLauper
//
//  Created by Isaac Greenspan on 9/13/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "NSFont+CASL.h"

#import <objc/runtime.h>

static const void *EmbeddedFontDataKey = &EmbeddedFontDataKey;
static const void *EmbeddedFontFileNameKey = &EmbeddedFontFileNameKey;

@implementation NSFont (CASL)

+ (instancetype)casl_fontFromDataProvider:(CGDataProviderRef)dataProvider
{
    if (!dataProvider) {
        return nil;
    }
    // Create a CGFont with the data provider.
    CGFontRef fontRef = CGFontCreateWithDataProvider(dataProvider);
    if (!fontRef) {
        return nil;
    }
    // Make an NSFont (toll-free bridged with CTFontRef) from the CGFont.
    NSFont *font = CFBridgingRelease(CTFontCreateWithGraphicsFont(fontRef, NSFont.systemFontSize, NULL, NULL));
    CGFontRelease(fontRef);
    return font;
}

+ (instancetype)casl_fontFromData:(NSData *)data
{
    // Get a CGDataProvider from the NSData.
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    // Create a font with the data provider.
    NSFont *font = [self casl_fontFromDataProvider:dataProvider];
    CGDataProviderRelease(dataProvider);
    return font;
}

+ (NSArray<NSFont *> *)casl_fontsFromData:(NSData *)data extension:(NSString *)extension
{
    if ([extension.lowercaseString isEqualToString:@"ttc"]) {
        extension = @"ttf";
    }
    NSMutableArray<NSFont *> *fonts = [NSMutableArray array];
    for (NSData *singleFontData in [self arrayOfSingleFontDataObjectsFromFontFileData:data]) {
        NSFont *font = [self casl_fontFromData:singleFontData];
        font.casl_embeddedFontData = singleFontData;
        font.casl_embeddedFontFileName = [font.fontName stringByAppendingPathExtension:extension];
        [fonts addObject:font];
    }
    return [fonts copy];
}

+ (instancetype)casl_fontFromURL:(NSURL *)url
{
    // Get a CGDataProvider from the URL.
    CGDataProviderRef dataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    // Create a font with the data provider.
    NSFont *font = [self casl_fontFromDataProvider:dataProvider];
    CGDataProviderRelease(dataProvider);
    return font;
}

- (instancetype)casl_fontWithSize:(CGFloat)size
{
    NSFont *font = CFBridgingRelease(CTFontCreateCopyWithAttributes((__bridge CTFontRef)self,
                                                                    size,
                                                                    NULL,
                                                                    nil));
    font.casl_embeddedFontFileName = self.casl_embeddedFontFileName;
    font.casl_embeddedFontData = self.casl_embeddedFontData;
    return font;
}

#pragma mark - properties

- (void)setCasl_embeddedFontData:(NSData *)casl_embeddedFontData
{
    objc_setAssociatedObject(self, EmbeddedFontDataKey, casl_embeddedFontData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSData *)casl_embeddedFontData
{
    return objc_getAssociatedObject(self, EmbeddedFontDataKey);
}

- (void)setCasl_embeddedFontFileName:(NSString *)casl_embeddedFontFileName
{
    objc_setAssociatedObject(self, EmbeddedFontFileNameKey, casl_embeddedFontFileName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)casl_embeddedFontFileName
{
    return objc_getAssociatedObject(self, EmbeddedFontFileNameKey);
}

#pragma mark -

static uint32_t CalcTableChecksumInBufferAtOffset(void *buffer, uint32_t offset, uint32_t length)
{
    uint32_t *table = buffer + offset;
    uint32_t sum = 0L;
    uint32_t *end_ptr = table + ((length + 3) & ~3) / sizeof(uint32_t);
    while (table < end_ptr) {
        sum += ntohl(*table);
        table++;
    }
    return sum;
}

static uint32_t UInt32InBufferAtOffset(const void *buffer, size_t offset) {
    uint32_t fourByteChunk;
    memcpy(&fourByteChunk, buffer + offset, sizeof(fourByteChunk));
    return ntohl(fourByteChunk);
}

static void WriteUInt32ToBufferAtOffset(uint32_t value, void *buffer, size_t offset) {
    memcpy(buffer + offset, &value, sizeof(value));
}

static uint16_t UInt16InBufferAtOffset(const void *buffer, size_t offset) {
    uint16_t twoByteChunk;
    memcpy(&twoByteChunk, buffer + offset, sizeof(twoByteChunk));
    return ntohs(twoByteChunk);
}

/**
 Turns a single NSData object representing one or more fonts into an array of NSData objects each represeting a single font.
 
 Any data that isn't a TrueType Collection is assumed to be a single font.
 
 @param data The NSData to convert.
 
 @return An array of NSData objects each representing a single font.
 */
+ (NSArray<NSData *> *)arrayOfSingleFontDataObjectsFromFontFileData:(NSData *)data
{
    /*
     Based on https://web.archive.org/web/20100325141843/http://solaris.sunfish.suginami.tokyo.jp/tips/playground/truetype/ttc2ttf/ttc2ttf.cpp
     (Archive of http://solaris.sunfish.suginami.tokyo.jp/tips/playground/truetype/ttc2ttf/ttc2ttf.cpp )
     
     That code is nearly identical to https://web.archive.org/web/20101030015654/http://hp.vector.co.jp/authors/VA010851/be/index.html
     (Archive of http://hp.vector.co.jp/authors/VA010851/be/index.html )
     
     The README file for that contains:
     
             ttc2ttf
             
             AAPRではTTF(TrueType Font)は読めるが、複数のTTFを一つにまとめた
             TTC(TrueType Collection)は読むことができないので、TTCを無理やり
             TTFにします。
             
             font.ttcというフォントをTTFに分割したい場合は、
             ttc2ttf font.ttc
             とします。
             
             危険ですのでオリジナルのフォントは必ず保存しておいてください。
             
             
             ttc2ttfはフリーウエアですので自由に使ってください。ついでに、
             配布や改良も自由です。
             
             
             作者について：
             http://www.asahi-net.or.jp/~wr6t-kdm/be/index.html
             mailto:ktakeshi@yo.rim.or.jp
     
     The last sentence before the URL/contact paragraph says something to the effect of "ttc2ttf is `freeware and you are
     free to use it however. Also, you are free to distribute and modify ('improve') it as you please."
     
     That code has been modified to input and output NSData, replace the INTEL macro and accompanying macros with the
     endianness-converting ntohs and ntohl functions, use types with explicit bit-sizes, and conform to Vokal's coding 
     standards.
     */
    const void *buffer = data.bytes;
    if (memcmp(buffer, "ttcf", 4)) {
        // Not a .ttc file, so we assume it's the data of a single font and return it in an array.
        return @[ data, ];
    }
    uint32_t ttf_count = UInt32InBufferAtOffset(buffer, 0x08);
    
    NSMutableArray<NSData *> *results = [NSMutableArray arrayWithCapacity:ttf_count];
    
    uint32_t ttf_offset_array[ttf_count];
    memcpy(ttf_offset_array, buffer + 0x0C, sizeof(ttf_offset_array));
    
    for (uint32_t i = 0; i < ttf_count; i++) {
        uint32_t table_header_offset = ntohl(ttf_offset_array[i]);
        uint16_t table_count = UInt16InBufferAtOffset(buffer, table_header_offset + 0x04);
        uint32_t header_length = 0x0C + table_count * 0x10;
        uint32_t table_length = 0;
        
        for (uint16_t j = 0; j < table_count; j++) {
            uint32_t length = UInt32InBufferAtOffset(buffer, table_header_offset + 0x0C + 0x0C + j * 0x10);
            table_length += (length + 3) & ~3;
        }
        
        uint32_t total_length = header_length + table_length;
        void *new_buffer = malloc(total_length);
        uint32_t pad = 0;
        memcpy(new_buffer, &buffer[table_header_offset], header_length);
        uint32_t current_offset = header_length;
        
        for (uint16_t j = 0; j < table_count; j++) {
            uint32_t offset = UInt32InBufferAtOffset(buffer, table_header_offset + 0x0C + 0x08 + j * 0x10);
            uint32_t length = UInt32InBufferAtOffset(buffer, table_header_offset + 0x0C + 0x0C + j * 0x10);
            WriteUInt32ToBufferAtOffset(htonl(current_offset),
                                        new_buffer, 0x0C + 0x08 + j * 0x10);
            memcpy(&new_buffer[current_offset], &buffer[offset], length);
            memcpy(&new_buffer[current_offset + length], &pad, ((length + 3) & ~3) - length);
            
            WriteUInt32ToBufferAtOffset(htonl(CalcTableChecksumInBufferAtOffset(new_buffer, current_offset, length)),
                                        new_buffer, 0x0C + 0x04 + j * 0x10);
            
            current_offset += (length + 3) & ~3;
        }
        
        [results addObject:[NSData dataWithBytes:new_buffer length:total_length]];
        free(new_buffer);
    }
    return [results copy];
}

@end
