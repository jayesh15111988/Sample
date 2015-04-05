//
//  ViewController.m
//  Sample
//
//  Created by Jayesh Kawli Backup on 2/28/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "ViewController.h"
#import <JKAnimatedOptionsOpenerView.h>
#import <JKCustomLoader.h>
#import <SAMTextView.h>
#import <JKSecretAnimatingLabel.h>

#define UNIQUE_ANIMATION_KEY @"drawCircleAnimation"
#define DEFAULT_ANIMATION_DURATION 0.25

@interface ViewController ()
@property (strong) CAShapeLayer* circlePathLayer;
@property (assign) CGFloat progress;
@property (nonatomic, retain) NSTimer* timer;
@property (assign) CGFloat progressIndicator;
@property (strong) CAShapeLayer *circle;
@property (strong) CABasicAnimation *drawAnimation;
@property (assign) CGFloat previousProgressIndicator;
@property (assign) NSInteger radius;
@property (assign) CGFloat maskSize;
@property (strong) UIImage* maskImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animateButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animateButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *tempView;
@property (weak, nonatomic) IBOutlet UIView *viewToAnimate;
@property (weak, nonatomic) IBOutlet SAMTextView *textView1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingEdgeConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIButton *animateViewButton;
@property (strong) NSTimer* imageMaskingOperationTimer;
@property (weak, nonatomic) IBOutlet JKSecretAnimatingLabel *labelToAnimate;

@end


@implementation ViewController

@synthesize radius;
@synthesize drawAnimation;
@synthesize circle;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maskSize = 0;
    [self setupAnimationForRedButton];
    self.maskImage = [UIImage imageNamed:@"red.png"];
    //self.tempView.layer.mask = [self getCustomMaskLayerFromRect:CGRectMake(0, 0, 0, 0)];
    //[self setupAnimationParameters];
    [self customLoaderTest];
}

-(void)customLoaderTest {
    JKCustomLoader* loader = [[JKCustomLoader alloc] initWithInputView:self.viewToAnimate andAnimationType:MaskShapeTypeCircle];
    [loader loadViewWithPartialCompletionBlock:^(CGFloat partialCompletionPercentage) {
        
    } andCompletionBlock:^{
        [self.labelToAnimate animateWithIndividualTextAnimationDuration:0.04 andRange:NSMakeRange(0, self.labelToAnimate.text.length)];
    }];
}

-(void)setupAnimationForRedButton {
    self.animateViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.animateViewButton addTarget:self action:@selector(animateButton) forControlEvents:UIControlEventTouchUpInside];
}

-(void)animateButton {
    self.bottomSpaceConstraint.constant = self.view.frame.size.height/2 - (20);
    self.trailingEdgeConstraint.constant = self.view.frame.size.width/2 - (36);
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //self.tempView.hidden = NO;
       /*self.imageMaskingOperationTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(updateImageMaskSize) userInfo:nil repeats:YES];
       [[NSRunLoop mainRunLoop] addTimer:self.imageMaskingOperationTimer forMode:NSDefaultRunLoopMode];
        */
       
        
        //With animation - Scale the button without altering its size and position
      /*  CABasicAnimation* animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.scale";
        animation.fromValue = [NSNumber numberWithFloat:1];
        animation.toValue = [NSNumber numberWithFloat:22];
        
        CAAnimationGroup* animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[animation];
        animationGroup.duration = 2.0f;
        animationGroup.timeOffset = 0.0;
        animationGroup.delegate = self;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animationGroup.removedOnCompletion = NO;
        [self.animateViewButton.layer addAnimation:animationGroup forKey:@"translateAnimation"];
        
        self.animateViewButton.transform = CGAffineTransformMakeScale(22, 22);*/
        [self performSegueWithIdentifier:@"customsegue" sender:self];
    }];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if(flag) {
        [UIView animateWithDuration:1.0 animations:^{
            self.animateViewButton.alpha = 0.0;
        }];
    }
}

-(CAShapeLayer*)getCustomMaskLayerFromRect:(CGRect)rectPathToMask {
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rectPathToMask;
    maskLayer.contents = (__bridge id) self.maskImage.CGImage;
    return maskLayer;
}

-(CAShapeLayer*)getShapeFromRect:(CGRect)rectPathForMask {
    return [self getCustomMaskLayerFromRect:rectPathForMask];
}

-(void)updateImageMaskSize {
    self.tempView.layer.mask = [self getShapeFromRect:CGRectMake((self.tempView.frame.size.width - self.maskSize)/2, (self.tempView.frame.size.height - self.maskSize)/2, self.maskSize, self.maskSize)];
    //self.tempView.layer.mask.backgroundColor = [UIColor whiteColor].CGColor;
    self.maskSize += 2;
    if(self.maskSize > MAX(self.view.frame.size.height, self.view.frame.size.width)) {
        [self.imageMaskingOperationTimer invalidate];
        self.imageMaskingOperationTimer = nil;
    }
}

-(void)setupAnimationParameters {
    self.previousProgressIndicator = 0;
    self.progressIndicator = 0;
    
    radius = 100;
    circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    circle.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
                                  CGRectGetMidY(self.view.frame)-radius);
    
    self.view.alpha = 0.2;
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor blackColor].CGColor;
    circle.lineWidth = 10;
    circle.strokeStart = 0.0;
    circle.strokeEnd = 1.0;
    
    
    // Add to parent layer
    [self.view.layer addSublayer:circle];
    [self.view setBackgroundColor:[UIColor redColor]];
    // Configure animation
    drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = DEFAULT_ANIMATION_DURATION;
    drawAnimation.repeatCount         = 1.0;
    drawAnimation.removedOnCompletion = YES;
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:self.previousProgressIndicator];
    drawAnimation.toValue   = [NSNumber numberWithFloat:self.progressIndicator];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:UNIQUE_ANIMATION_KEY];
    self.timer = [NSTimer timerWithTimeInterval:DEFAULT_ANIMATION_DURATION target:self selector:@selector(animateCircle) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    
    UIView* circleLayer = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    circleLayer.layer.cornerRadius = 50;
    circleLayer.layer.backgroundColor = [UIColor whiteColor].CGColor;
    circleLayer.layer.borderWidth = 5.0f;
    [self.view addSubview:circleLayer];
    
    CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    // animate from red to blue border ...
    color.fromValue = (id)[UIColor redColor].CGColor;
    color.toValue   = (id)[UIColor blueColor].CGColor;
    // ... and change the model value
    circleLayer.layer.borderColor = [UIColor blueColor].CGColor;
    circleLayer.layer.borderWidth = 5.0f;
    
    CABasicAnimation *width = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    // animate from 2pt to 4pt wide border ...
    width.fromValue = @0;
    width.toValue   = @50;
    circleLayer.layer.cornerRadius = 50;
    
    CAAnimationGroup *both = [CAAnimationGroup animation];
    // animate both as a group with the duration of 0.5 seconds
    both.duration   = 2;
    both.animations = @[width, color];
    both.repeatCount = 1.0;
    both.removedOnCompletion = NO;
    // optionally add other configuration (that applies to both animations)
    //both.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [circleLayer.layer addAnimation:both forKey:@"color and width"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"IU Football";
}

-(void)animateCircle {
    if(self.progressIndicator <= 1.0) {
        drawAnimation.fromValue   = [NSNumber numberWithFloat:self.previousProgressIndicator];
        drawAnimation.toValue   = [NSNumber numberWithFloat:self.progressIndicator];
        [circle addAnimation:drawAnimation forKey:UNIQUE_ANIMATION_KEY];
        self.previousProgressIndicator = self.progressIndicator;
        CGFloat temp = ((arc4random()%9)/100.0);
        self.progressIndicator += truncf(temp * 100) / 100;
        self.view.alpha = self.progressIndicator;
        NSLog(@"%f", self.progressIndicator);
    } else {
        [self.timer invalidate];
   }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if([identifier isEqualToString:@"customsegue"]) {
        return NO;
    }
    return YES;
}

@end
