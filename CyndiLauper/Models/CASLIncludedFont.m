#import "CASLIncludedFont.h"

#import "NSFont+CASL.h"

@interface CASLIncludedFont ()

// Private interface goes here.

@end

@implementation CASLIncludedFont

@dynamic font;

+ (instancetype)includedFontForFont:(NSFont *)font
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *fontName = font.fontName;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K=%@",
                              CASLBaseSpecAttributes.name, fontName];
    CASLIncludedFont *includedFont = [context executeFetchRequest:fetchRequest error:NULL].firstObject;
    if (!includedFont) {
        includedFont = [self insertInManagedObjectContext:context];
        includedFont.name = fontName;
        includedFont.font = [font casl_fontWithSize:NSFont.systemFontSize];
    }
    return includedFont;
}

@end
