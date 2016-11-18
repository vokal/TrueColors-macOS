#import "_CASLIncludedFont.h"

@interface CASLIncludedFont : _CASLIncludedFont

@property (nonatomic, strong, nullable) NSFont *font;

+ (nonnull instancetype)includedFontForFont:(nonnull NSFont *)font
                     inManagedObjectContext:(nonnull NSManagedObjectContext *)context;

@end
