//
//  CustomView.m
//  Sample
//
//  Created by Jayesh Kawli Backup on 3/18/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (void)drawRect:(CGRect)rect {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, 1.0f);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {1.0, 1.0, 0.0, 1.0};
    CGColorRef colorRef = CGColorCreate(colorSpace, components);
    CGContextSetStrokeColorWithColor(currentContext, colorRef);
    CGContextSetFillColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
    CGContextAddEllipseInRect(currentContext, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    //CGContextStrokePath(currentContext);
    CGContextFillPath(currentContext);
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(currentContext, [UIColor greenColor].CGColor);
    CGContextMoveToPoint(currentContext, self.center.x, 0);
    CGContextAddLineToPoint(currentContext, 0, self.frame.size.height/2);
    CGContextAddLineToPoint(currentContext, self.center.x, self.frame.size.height);
    CGContextAddLineToPoint(currentContext, self.frame.size.width, self.frame.size.height/2);
    CGContextAddLineToPoint(currentContext, self.center.x, 0);
    
    //CGContextStrokePath(currentContext);
    CGContextFillPath(currentContext);
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(currentContext, 0, 0);
    CGContextAddCurveToPoint(currentContext, 20, self.frame.size.height*0.3, 150, self.frame.size.height*0.8, self.center.x, self.frame.size.height);
    CGContextStrokePath(currentContext);
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blueColor].CGColor);
    CGContextMoveToPoint(currentContext, 0, self.frame.size.height/2);
    CGContextSetLineWidth(currentContext, 2);
    CGFloat dashArray[] = {20,5};
    CGContextSetLineDash(currentContext, 1, dashArray, 2);
    CGContextAddLineToPoint(currentContext, self.frame.size.width, self.frame.size.height/2);
    CGContextStrokePath(currentContext);
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(currentContext, 0, self.frame.size.height/2);
    CGContextAddQuadCurveToPoint(currentContext, self.center.x, self.frame.size.height, self.frame.size.width, self.frame.size.height/2);
    CGContextStrokePath(currentContext);
    
    UIImage* image = [UIImage imageNamed:@"donald.png"];
    [image drawInRect:CGRectMake(0, 0, 200, 200) blendMode:kCGBlendModeLuminosity alpha:1.0];
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorRef);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)
touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
@end
