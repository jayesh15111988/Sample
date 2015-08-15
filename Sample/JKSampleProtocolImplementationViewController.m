//
//  JKSampleProtocolImplementationViewController.m
//  Sample
//
//  Created by Jayesh Kawli Backup on 8/14/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKSampleProtocolImplementationViewController.h"
#import "HighLevelProtocol.h"
#import "ProtocoloUtilizerOne.h"

#import "ProtocoloImplementorOne.h"
#import "ProtocoloImplementorTwo.h"

@interface JKSampleProtocolImplementationViewController ()<HighLevelProtocol>


@end

@implementation JKSampleProtocolImplementationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doStuff];
}

- (void)doStuff {
    ProtocoloUtilizerOne* utilizerOne = [ProtocoloUtilizerOne new];
    utilizerOne.delegate = self;
    [utilizerOne doStuffOne];
    
    ProtocoloImplementorOne<HighLevelProtocol>* implementorOneInstance = [ProtocoloImplementorOne new];
    if ([implementorOneInstance conformsToProtocol:@protocol(HighLevelProtocol)] && [implementorOneInstance respondsToSelector:@selector(sitcomTypeValue)]) {
        NSLog(@"%@", [implementorOneInstance sitcomTypeValue]);
    }
    
    ProtocoloImplementorTwo<HighLevelProtocol>* implementorTwoInstance = [ProtocoloImplementorTwo new];
    if ([implementorTwoInstance conformsToProtocol:@protocol(HighLevelProtocol)] && [implementorTwoInstance respondsToSelector:@selector(sitcomTypeValue)]) {
        NSLog(@"%@", [implementorTwoInstance sitcomTypeValue]);
    }
}

- (void)doRequiredMethodOne {
    NSLog(@"Required Task Done");
}

- (NSString*)sitcomTypeValue {
    return @"";
}

@end
