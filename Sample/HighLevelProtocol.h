//
//  HighLevelProtocol.h
//  Sample
//
//  Created by Jayesh Kawli Backup on 8/14/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HighLevelProtocol <NSObject>

@required
- (void)doRequiredMethodOne;
- (NSString*)sitcomTypeValue;


@optional
- (void)doOptionalMethodOne;
- (void)doOptionalMethodTwo;


@end
