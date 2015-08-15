//
//  SKPodcastListType.m
//  Sample
//
//  Created by Jayesh Kawli Backup on 8/2/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "SKPodcastListType.h"
#import <objc/runtime.h>

@implementation SKPodcastListType

- (instancetype)initWithString:(NSString *)string {
    if ([string isEqualToString:@"unplayed"]) {
        return [SKUnplayedPodcastListType new];
    }
    if ([string isEqualToString:@"favorites"]) {
        return [SKFavoritesPodcastListType new];
    }
    return nil;
}

- (NSString*)displayName {
    return @"";
}

- (NSString*)listTypeFromClassName:(NSString*)className {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=SK)(.*?)(?=PodcastListType)" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matchedStringsCollection = [regex matchesInString:className options:0 range:NSMakeRange(0, [className length])];
    NSString* listType = @"";
    for (NSTextCheckingResult *match in matchedStringsCollection) {
        NSRange matchRange = [match rangeAtIndex:1];
        listType = [className substringWithRange:matchRange];
        break;
    }
    return listType;
}

@end

@implementation SKUnplayedPodcastListType

- (NSString*)displayName {
    return [self listTypeFromClassName:NSStringFromClass([self class])];
}

@end

@implementation SKFavoritesPodcastListType

- (NSString*)displayName {
    return [self listTypeFromClassName:NSStringFromClass([self class])];
}

@end
