//
//  NSString+SoftHyphenation.h
//  iMKR
//
//  Created by Yuri Karabatov on 21.11.14.
//
//  Source: http://stackoverflow.com/questions/19709465/hyphenation-in-native-ios-app

#import <Foundation/Foundation.h>

typedef enum {
    NSStringSoftHyphenationErrorNotAvailableForLocale
} NSStringSoftHyphenationError;

extern NSString * const NSStringSoftHyphenationErrorDomain;

@interface NSString (SoftHyphenation)

- (NSString *)softHyphenatedStringWithLocale:(NSLocale *)locale error:(out NSError **)error;
- (NSString *)softHyphenatedString;

@end
