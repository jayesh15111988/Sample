//
//  CustomSegue.m
//  Sample
//
//  Created by Jayesh Kawli Backup on 3/28/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "CustomSegue.h"
#import "DestinationViewController.h"
#import <JKCustomLoader.h>

@implementation CustomSegue
-(void)perform {
    
    UIViewController *src = (UIViewController *)self.sourceViewController;
    DestinationViewController *dest = (DestinationViewController*)self.destinationViewController;
    src.title = @"OSU Football";
    JKCustomLoader* loader = [[JKCustomLoader alloc] initWithInputView:dest.view andAnimationType:MaskShapeTypeCircle];
    loader.maskImage = [UIImage imageNamed:@"plane1.png"];
    loader.maskSizeIncrementPerFrame = 20;
    CGRect originalFrame = dest.view.frame;
    originalFrame.origin.y = 64;
    dest.view.frame = originalFrame;
    [[src.view superview] addSubview:dest.view];
    
        [loader loadViewWithPartialCompletionBlock:^(CGFloat partialCompletionPercentage) {
            
        } andCompletionBlock:^{
            [dest.view removeFromSuperview];
            src.title = @"IU Football";
            [src.navigationController pushViewController:dest animated:NO];
        }];
}
     
@end

