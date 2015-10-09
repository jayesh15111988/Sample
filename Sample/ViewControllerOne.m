//
//  ViewControllerOne.m
//  Sample
//
//  Created by Jayesh Kawli Backup on 8/27/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <JK3DFlapView/JKFlippingView.h>
#import "ViewControllerOne.h"
#import "ViewControllerTwo.h"

@interface ViewControllerOne ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewControllerOne

- (void)viewDidLoad {
	[super viewDidLoad];
	JKFlippingView* view = [[JKFlippingView alloc] init3DFlapWithOpeningMode:JKFlapOpeningMode3DBottom
								 andFlipviewSize:CGSizeMake (50, 50)];
	view.overlayLabelTextValue = @"This is the one and only beatles band which rocks the world";
	view.blurredImageEffectValue = JKBlurredImageEffectColorful;
	view.animationDuration = 1.0f;
	view.playOpeningFlapSound = YES;
	view.flipAnimationEasingFunction = ElasticEaseOut;
	view.backgroundColor = [UIColor redColor];
	view.flapOpeningAngle = 180.0f;
	view.frame = CGRectMake (100, 400, 50, 50);
	[self.view addSubview:view];
    
    NSString *youTubeVideoId = @"83_H6cAQ16Q";//@"http://view.vzaar.com/105214.video";
    //NSString *videoHTML = [NSString stringWithFormat:@"<iframe id='playerId' type='text/html' width='100' height='100' src='%@' frameborder='0'>", videoURL];
    NSString* videoHTML = [NSString stringWithFormat:@"<embed id=\"yt\" src=\"https://www.youtube.com/v/%@\" type=\"application/x-shockwave-flash\" \
                           width=\"100\" height=\"100\"></embed>", youTubeVideoId];
    
    
    [self.webView loadHTMLString:videoHTML baseURL: nil];
}

- (IBAction)buttonPressed:(id)sender {
	ViewControllerTwo* vcTwo = [self.storyboard instantiateViewControllerWithIdentifier:@"viewControllerTwo"];
	[self.navigationController pushViewController:vcTwo animated:YES];
}

@end
