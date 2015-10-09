//
//  NavigationControllerDelegate.m
//  Sample
//
//  Created by Jayesh Kawli Backup on 8/27/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "Animator.h"

@interface NavigationControllerDelegate ()

@property (strong, nonatomic) Animator* animator;

@end

@implementation NavigationControllerDelegate

- (void)awakeFromNib {
    self.animator = [Animator new];
}

- (id<UIViewControllerAnimatedTransitioning>)
navigationController:(UINavigationController *)navigationController
animationControllerForOperation:(UINavigationControllerOperation)operation
fromViewController:(UIViewController*)fromVC
toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return self.animator;
    }
    return nil;
}


@end
