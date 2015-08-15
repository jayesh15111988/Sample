//
//  AnotherViewController.m
//  Sample
//
//  Created by Jayesh Kawli Backup on 7/16/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "AnotherViewController.h"
#import <ScrollViewAutolayoutCreator.h>
#import "SKPodcastListType.h"
#import "DynamicMethodResolution.h"
#import <JKFacebookPrideEffect/JKFacebookPrideEffect.h>

@interface CustomBU : UIButton

@end

@implementation CustomBU


@end

@interface AnotherViewController ()

@end

@implementation AnotherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    ScrollViewAutolayoutCreator* scrollViewAL = [[ScrollViewAutolayoutCreator alloc] initWithSuperView:self.view];
//    UILabel* lab = [UILabel new];
//    lab.translatesAutoresizingMaskIntoConstraints = NO;
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.numberOfLines = 0;
//    lab.backgroundColor = [UIColor yellowColor];
//    lab.text = @"as das d asd as das da sd as d";
//    [scrollViewAL.contentView addSubview:lab];
//
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[lab]-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(lab)]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[lab(20)]-20-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(lab)]];
//    
//    CGRect areaOne, areaTwo;
//    CGRectDivide(self.view.bounds, &areaOne, &areaTwo, self.view.bounds.size.width * 0.30, CGRectMinXEdge);
//    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectInset(areaOne, 10, 10)];
//    [self.view addSubview:viewOne];
//    [viewOne setBackgroundColor:[UIColor redColor]];
//    
//    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectInset(areaTwo, 10, 10)];
//    [self.view addSubview:viewTwo];
//    [viewTwo setBackgroundColor:[UIColor grayColor]];
//    
//    CGRect areaThree, areaFour;
//    CGRectDivide(areaTwo, &areaThree, &areaFour, areaTwo.size.height * 0.70, CGRectMaxYEdge);
//    
//    UIView *viewThree = [[UIView alloc] initWithFrame:CGRectInset(areaThree, 0, 20)];
//    [viewTwo addSubview:viewThree];
//    [viewThree setBackgroundColor:[UIColor yellowColor]];
//    
//    UIView *viewFour = [[UIView alloc] initWithFrame:CGRectInset(areaFour, 0, 20)];
//    [viewTwo addSubview:viewFour];
//    [viewFour setBackgroundColor:[UIColor greenColor]];
    
//    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 200, 200, 200)];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:imageView];
//    JKFacebookPrideEffect* effect = [[JKFacebookPrideEffect alloc] initWithInputImage:[UIImage imageNamed:@"IU.jpeg"] andSize:imageView.frame.size];
//    effect.textRequired = YES;
//    effect.variableTextColors = NO;
//    effect.overlayTextColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//    effect.overlayTextAlignment = NSTextAlignmentAlternate;
//    imageView.image = [effect applyEffect];
    
    [self implementEnumsUsingClassHierarchy];
    
    SEL selec = NSSelectorFromString(@"doit");
    IMP imp = [self methodForSelector:selec];
    void (*func)(id, SEL) = (void *)imp;
    func(self, selec);

    
    SEL selector = NSSelectorFromString(@"processRegion:ofView:anotherView:");
    IMP imp1 = [self methodForSelector:selector];
    CGFloat (*func1)(id, SEL, CGFloat, CGFloat, CGFloat) = (void *)imp1;
    CGFloat result = self ?
    func1(self, selector, 20, 30, 40) : 0;
    NSLog(@"Result of Float operation is %f", result);
    
    // Following demo shows how dynamic method resolution can be used to resolve method implementation at the runtime.
    DynamicMethodResolution* dynamicMResolutionInstance = [DynamicMethodResolution new];
    [dynamicMResolutionInstance implementDynamicWithObject:[Animal new]];
    [dynamicMResolutionInstance implementDynamicWithObject:[Human new]];
    [dynamicMResolutionInstance implementDynamicWithObject:[Bird new]];
    
    UIButton* originalButton = [UIButton new];
    CustomBU* customButton = [CustomBU new];
    
    NSLog(@"Testing for original button types %d %d", [originalButton isKindOfClass:[UIButton class]], [originalButton isMemberOfClass:[UIButton class]]);
    NSLog(@"Testing for Custom button type %d %d %d %d", [customButton isKindOfClass:[UIButton class]], [customButton isMemberOfClass:[UIButton class]], [customButton isKindOfClass:[CustomBU class]], [customButton isMemberOfClass:[CustomBU class]]);
}

- (CGFloat)processRegion:(CGFloat)first ofView:(CGFloat)second anotherView:(CGFloat)third {
    return first + second + third;
}

- (void)doit {
    
}

- (void)implementEnumsUsingClassHierarchy {
    SKPodcastListType* unplayedType = [[SKPodcastListType alloc] initWithString:@"unplayed"];
    SKPodcastListType* favoriteType = [[SKPodcastListType alloc] initWithString:@"favorites"];
    
    NSString *type1 = unplayedType.displayName;
    NSString *type2 = favoriteType.displayName;
    NSLog(@"Display Name Type 1 %@ and Type 2 %@", type1, type2);
}

@end
