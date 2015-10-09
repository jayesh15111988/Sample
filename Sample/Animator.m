//
//  Animator.m
//  Sample
//
//  Created by Jayesh Kawli Backup on 8/27/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "Animator.h"

@implementation Animator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIViewController* toViewController =
	    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController* fromViewController =
	    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	[[transitionContext containerView] addSubview:toViewController.view];
	toViewController.view.alpha = 0;

	[UIView animateWithDuration:[self transitionDuration:transitionContext]
	    animations:^{
	      fromViewController.view.transform = CGAffineTransformMakeScale (0.1, 0.1);
	      toViewController.view.alpha = 1;
	    }
	    completion:^(BOOL finished) {
	      fromViewController.view.transform = CGAffineTransformIdentity;
	      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];

	    }];
}

@end
