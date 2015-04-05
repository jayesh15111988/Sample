//
//  ALTestViewController.m
//  Sample
//
//  Created by Jayesh Kawli Backup on 4/5/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "ALTestViewController.h"
#import <UIView+BlocksKit.h>

@interface ALTestViewController ()
@property (strong) NSDictionary* elementsCollection;
@property (strong) NSMutableArray* subItemViewsListCollection;
@property (strong) NSMutableArray* heightConstraintsCollection;
@end

@implementation ALTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.subItemViewsListCollection = [NSMutableArray new];
    self.heightConstraintsCollection = [NSMutableArray new];
    
    self.elementsCollection = @{@"First Row":@[@"first row first", @"first row second"],@"Second Row":@[@"second row first", @"second row second"], @"Third Row":@[@"third row first", @"third row second"],@"Fourth Row":@[@"fourth row first", @"fourth row second"]};
    CGFloat yValue = 44;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSInteger counter = 0;
    for(NSString* key in self.elementsCollection) {
        
        UIButton* headerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, yValue, 200, 44)];
        
        headerButton.translatesAutoresizingMaskIntoConstraints = NO;
        [headerButton setTitle:key forState:UIControlStateNormal];
        [headerButton setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:headerButton];
        
        if([self.subItemViewsListCollection count]) {
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self.subItemViewsListCollection lastObject] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        } else {
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:44]];
        }
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:44]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200]];
        NSArray* subItems = self.elementsCollection[key];
        
        [headerButton bk_whenTapped:^{
            NSLog(@"Button Title %@", headerButton.titleLabel.text);
            NSLayoutConstraint* con = [self.heightConstraintsCollection objectAtIndex:counter];
            con.constant = (con.constant == 0)? [subItems count]*44 : 0;
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
            }];
        }];
        
        
        yValue += 44;
        UIView* subItemsHolderView = [[UIView alloc] initWithFrame:CGRectMake(20, yValue, 200, 44*[subItems count])];
        [subItemsHolderView setBackgroundColor:[UIColor blueColor]];
        subItemsHolderView.translatesAutoresizingMaskIntoConstraints = NO;
        yValue += 44*[subItems count];
        CGFloat subYValue = 0;
        
        NSMutableArray* labelsCollection = [NSMutableArray new];
        
        for(NSString* subItem in subItems) {
            UILabel* lab = [[UILabel alloc] init];
            lab.translatesAutoresizingMaskIntoConstraints = NO;
            lab.text = subItem;
            lab.backgroundColor = [UIColor greenColor];
            [labelsCollection addObject:lab];
            [subItemsHolderView addSubview:lab];
            subYValue += 44;
        }
        
        [self.view addSubview:subItemsHolderView];
        
        
        NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:subItemsHolderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44*[subItems count]];
        heightConstraint.constant = 0;
        [self.heightConstraintsCollection addObject:heightConstraint];
        counter++;
        
        
        for(NSInteger i = 0; i<[labelsCollection count]; i++){
            UILabel* lab = labelsCollection[i];
            
            subItemsHolderView.clipsToBounds = YES;
            [lab addConstraint:[NSLayoutConstraint constraintWithItem:lab attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lab attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:subItemsHolderView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:1]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:subItemsHolderView attribute:NSLayoutAttributeTop multiplier:1.0 constant:44*i]];
            [lab addConstraint:[NSLayoutConstraint constraintWithItem:lab attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200]];
        }
        
        [self.view addConstraint:heightConstraint];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:subItemsHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:subItemsHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:subItemsHolderView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:44.0]];
        
        
        [self.subItemViewsListCollection addObject:subItemsHolderView];
    }
    UIButton* endButton = [[UIButton alloc] initWithFrame:CGRectMake(10, yValue, 200, 44)];
    
    endButton.backgroundColor = [UIColor redColor];
    endButton.translatesAutoresizingMaskIntoConstraints = NO;
    [endButton setTitle:@"End Button" forState:UIControlStateNormal];
    [self.view addSubview:endButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:endButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self.subItemViewsListCollection lastObject] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:endButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:44]];
    [endButton addConstraint:[NSLayoutConstraint constraintWithItem:endButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];
    [endButton addConstraint:[NSLayoutConstraint constraintWithItem:endButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200]];
}

@end
