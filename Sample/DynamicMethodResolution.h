//
//  DynamicMethodResolution.h
//  Sample
//
//  Created by Jayesh Kawli Backup on 8/3/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicMethodResolution : NSObject

- (void)implementDynamicWithObject:(id)inputObject;

@end

@interface Animal : NSObject

- (void)makeSoundWithAnimal:(Animal*)animal;

@end

@interface Human : NSObject

- (void)makeSoundWithHuman:(Human*)human;

@end

@interface Bird : NSObject

- (void)makeSoundWithBird:(Bird*)bird;

@end
