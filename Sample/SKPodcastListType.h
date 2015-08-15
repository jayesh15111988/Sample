//
//  SKPodcastListType.h
//  Sample
//
//  Created by Jayesh Kawli Backup on 8/2/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKPodcastListType : NSObject

- (instancetype)initWithString:(NSString*)string;
@property (strong, nonatomic, readonly) NSString *displayName;

@end

@interface SKUnplayedPodcastListType : SKPodcastListType

@end

@interface SKFavoritesPodcastListType : SKPodcastListType

@end
