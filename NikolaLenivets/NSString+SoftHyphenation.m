//
//  NSString+SoftHyphenation.m
//  iMKR
//
//  Created by Yuri Karabatov on 21.11.14.
//
//

#import "NSString+SoftHyphenation.h"

NSString * const NSStringSoftHyphenationErrorDomain = @"NSStringSoftHyphenationErrorDomain";
NSString * const NSStringSoftHyphenationToken = @"\u00ad"; // NOTE: UTF-8 soft hyphen!


@implementation NSString (SoftHyphenation)


- (NSError *)hyphen_createOnlyError
{
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: @"Hyphenation is not available for given locale",
                               NSLocalizedFailureReasonErrorKey: @"Hyphenation is not available for given locale",
                               NSLocalizedRecoverySuggestionErrorKey: @"You could try using a different locale even though it might not be 100% correct"
                               };
    return [NSError errorWithDomain:NSStringSoftHyphenationErrorDomain code:NSStringSoftHyphenationErrorNotAvailableForLocale userInfo:userInfo];
}


- (NSString *)softHyphenatedStringWithLocale:(NSLocale *)locale error:(out NSError **)error
{
    CFLocaleRef localeRef = (__bridge CFLocaleRef)(locale);
    if (!CFStringIsHyphenationAvailableForLocale(localeRef))
    {
        if (error != NULL)
        {
            *error = [self hyphen_createOnlyError];
        }
        return [self copy];
    }
    else
    {
        NSMutableString *string = [self mutableCopy];
        unsigned char hyphenationLocations[string.length];
        memset(hyphenationLocations, 0, string.length);
        CFRange range = CFRangeMake(0, string.length);

        for (long i = 0; i < string.length; i++)
        {
            CFIndex location = CFStringGetHyphenationLocationBeforeIndex((CFStringRef)string, i, range, 0, localeRef, NULL);

            if (location >= 0 && location < string.length)
            {
                hyphenationLocations[location] = 1;
            }
        }

        for (long i = string.length - 1; i > 0; i--)
        {
            if (hyphenationLocations[i])
            {
                [string insertString:NSStringSoftHyphenationToken atIndex:i];
            }
        }

        if (error != NULL) { *error = nil; }
        
        return string;
    }
}


- (NSString *)softHyphenatedString
{
    NSError *error;
    NSString *rusTry = [self softHyphenatedStringWithLocale:[NSLocale localeWithLocaleIdentifier:@"ru_RU"] error:&error];
    if (error) {
        return [self softHyphenatedStringWithLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"] error:nil];
    } else {
        return rusTry;
    }
}


@end
