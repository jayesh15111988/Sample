//
//  DynamicMethodResolution.m
//  Sample
//
//  Created by Jayesh Kawli Backup on 8/3/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "DynamicMethodResolution.h"


@implementation DynamicMethodResolution

- (void)implementDynamicWithObject:(id)inputObject {
    NSString* classNameForPassedObject = NSStringFromClass([inputObject class]);
    NSString* selectorStringForCurrentClass = [NSString stringWithFormat:@"makeSoundWith%@:", classNameForPassedObject];
    SEL selector = NSSelectorFromString(selectorStringForCurrentClass);
    if ([self respondsToSelector:selector]) {
        IMP implementation = [self methodForSelector:selector];
        void(*fun)(id, SEL, id) = (void*)implementation;
        fun(self, selector, inputObject);
    }
}

- (void)makeSoundWithAnimal:(Animal*)Animal {
    NSLog(@"Barking Animal");
}

- (void)makeSoundWithHuman:(Human*)Human {
    NSLog(@"Speaking Human");
}

- (void)makeSoundWithBird:(Bird*)Bird {
    NSLog(@"Chirping Bird");
}

@end


@implementation Animal : NSObject

- (void)makeSoundWithAnimal:(Animal*)animal {
    
}

@end

@implementation Human : NSObject

- (void)makeSoundWithHuman:(Human *)human {
    
}

@end

@implementation Bird : NSObject

- (void)makeSoundWithBird:(Bird *)bird {
    
}
@end
