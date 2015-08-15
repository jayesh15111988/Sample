//
//  ProtocoloUtilizerOne.h
//  Sample
//
//  Created by Jayesh Kawli Backup on 8/14/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HighLevelProtocol.h"

@interface ProtocoloUtilizerOne : NSObject

@property (weak, nonatomic) id<HighLevelProtocol> delegate;
- (void)doStuffOne;
@end
