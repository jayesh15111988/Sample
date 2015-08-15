/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.

 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "STCMeshLayer.h"

#import <libkern/OSAtomic.h>

static const CFTimeInterval STCMeshLayerTotalInstanceDelay = 10000000.0;
static NSString *const STCMeshLayerBoundsAnimationKey = @"STCMeshLayerBoundsAnimation";
static NSString *const STCMeshLayerTransformAnimationKey = @"STCMeshLayerTransformAnimation";
static NSString *const STCMeshLayerPositionAnimationKey = @"STCMeshLayerPositionAnimation";
static NSString *const STCMeshLayerAnchorPointAnimationKey = @"STCMeshLayerAnchorPointAnimation";
static NSString *const STCMeshLayerInstanceDelayAnimationKey = @"STCMeshLayerInstanceDelayAnimation";

@implementation STCMeshLayer {
    OSSpinLock _lock;

    CAReplicatorLayer *_wrapperLayer;
    CALayer *_contentLayer;

    CGRect *_instanceBounds;
    CATransform3D *_instanceTransforms;
    CGPoint *_instancePositions;
    CGPoint *_instanceAnchorPoints;
}

#pragma mark - Lifecycle

- (instancetype)init
{
    if ((self = [super init])) {
        _lock = OS_SPINLOCK_INIT;

        self.wrapperLayer = [[CAReplicatorLayer alloc] init];
        self.contentLayer = [[CALayer alloc] init];
    }

    return self;
}

- (void)dealloc
{
    OSSpinLockLock(&_lock);
    free(_instanceTransforms);
    _instanceTransforms = NULL;
    free(_instanceBounds);
    _instanceBounds = NULL;
    OSSpinLockUnlock(&_lock);
}

- (void)layoutSublayers
{
    [super layoutSublayers];

    OSSpinLockLock(&_lock);
    _wrapperLayer.frame = self.bounds;
    _contentLayer.frame = _wrapperLayer.bounds;
    [self _updateMeshAnimations];
    OSSpinLockUnlock(&_lock);
}

#pragma mark - Properties

@dynamic instanceDelay;

@dynamic instanceTransform;

- (void)setInstanceCount:(NSInteger)instanceCount
{
    OSSpinLockLock(&_lock);
    if (instanceCount != self.instanceCount) {
        [super setInstanceCount:instanceCount];

        free(_instanceTransforms);
        _instanceTransforms = NULL;
        free(_instanceBounds);
        _instanceBounds = NULL;

        [self setNeedsLayout];
    }
    OSSpinLockUnlock(&_lock);
}

- (CATransform3D *)instanceTransforms
{
    OSSpinLockLock(&_lock);
    CATransform3D *instanceTransforms = _instanceTransforms;
    OSSpinLockUnlock(&_lock);

    return instanceTransforms;
}

- (void)setInstanceTransforms:(CATransform3D *)instanceTransforms
{
    OSSpinLockLock(&_lock);
    free(_instanceTransforms);
    _instanceTransforms = NULL;

    if (instanceTransforms != NULL) {
        _instanceTransforms = calloc(sizeof(CATransform3D), self.instanceCount);
        memcpy(_instanceTransforms, instanceTransforms, self.instanceCount * sizeof(CATransform3D));
    }

    [self setNeedsLayout];
    OSSpinLockUnlock(&_lock);
}

- (CGPoint *)instancePositions
{
  OSSpinLockLock(&_lock);
  CGPoint *instancePositions = _instancePositions;
  OSSpinLockUnlock(&_lock);

  return instancePositions;
}

- (void)setInstancePositions:(CGPoint *)instancePositions
{
  OSSpinLockLock(&_lock);
  free(_instancePositions);
  _instancePositions = NULL;

  if (instancePositions != NULL) {
    _instancePositions = calloc(sizeof(CGPoint), self.instanceCount);
    memcpy(_instancePositions, instancePositions, self.instanceCount * sizeof(CGPoint));
  }

  [self setNeedsLayout];
  OSSpinLockUnlock(&_lock);
}

- (CGPoint *)instanceAnchorPoints
{
  OSSpinLockLock(&_lock);
  CGPoint *instanceAnchorPoints = _instanceAnchorPoints;
  OSSpinLockUnlock(&_lock);

  return instanceAnchorPoints;
}

- (void)setInstanceAnchorPoints:(CGPoint *)instanceAnchorPoints
{
  OSSpinLockLock(&_lock);
  free(_instanceAnchorPoints);
  _instanceAnchorPoints = NULL;

  if (instanceAnchorPoints != NULL) {
    _instanceAnchorPoints = calloc(sizeof(CGPoint), self.instanceCount);
    memcpy(_instanceAnchorPoints, instanceAnchorPoints, self.instanceCount * sizeof(CGPoint));
  }

  [self setNeedsLayout];
  OSSpinLockUnlock(&_lock);
}

- (CGRect *)instanceBounds
{
    OSSpinLockLock(&_lock);
    CGRect *instanceBounds = _instanceBounds;
    OSSpinLockUnlock(&_lock);

    return instanceBounds;
}

- (void)setInstanceBounds:(CGRect *)instanceBounds
{
    OSSpinLockLock(&_lock);
    free(_instanceBounds);
    _instanceBounds = NULL;

    if (instanceBounds != NULL) {
        _instanceBounds = calloc(sizeof(CGRect), self.instanceCount);
        memcpy(_instanceBounds, instanceBounds, self.instanceCount * sizeof(CGRect));
    }

    [self setNeedsLayout];
    OSSpinLockUnlock(&_lock);
}

- (CALayer *)contentLayer
{
    OSSpinLockLock(&_lock);
    CALayer *contentLayer = _contentLayer;
    OSSpinLockUnlock(&_lock);

    return contentLayer;
}

- (void)setContentLayer:(CALayer *)contentLayer
{
    OSSpinLockLock(&_lock);
    if (contentLayer != _contentLayer) {
        if (_contentLayer != nil) {
            [_contentLayer removeFromSuperlayer];
        }

        _contentLayer = contentLayer;

        if (_contentLayer != nil) {
            [_wrapperLayer addSublayer:_contentLayer];
        }
    }
    OSSpinLockUnlock(&_lock);
}

- (CAReplicatorLayer *)wrapperLayer
{
    OSSpinLockLock(&_lock);
    CAReplicatorLayer *wrapperLayer = _wrapperLayer;
    OSSpinLockUnlock(&_lock);

    return wrapperLayer;
}

- (void)setWrapperLayer:(CAReplicatorLayer *)wrapperLayer
{
    OSSpinLockLock(&_lock);
    if (wrapperLayer != _wrapperLayer) {
        if (_contentLayer != nil) {
            [_contentLayer removeFromSuperlayer];
        }

        if (_wrapperLayer != nil) {
            [_wrapperLayer removeFromSuperlayer];
        }

        _wrapperLayer = wrapperLayer;

        if (_wrapperLayer != nil) {
            _wrapperLayer.masksToBounds = YES;
            _wrapperLayer.instanceCount = 2;
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef hiddenColor = CGColorCreate(colorSpace, (CGFloat []){ 1.0, 1.0, 1.0, 0.0 });
            _wrapperLayer.instanceColor = hiddenColor;
            CGColorRelease(hiddenColor);
            CGColorSpaceRelease(colorSpace);
            _wrapperLayer.instanceAlphaOffset = 1.0;
            [self addSublayer:_wrapperLayer];
        }

        if (_contentLayer != nil) {
            [_wrapperLayer addSublayer:_contentLayer];
        }

        [self setNeedsLayout];
    }
    OSSpinLockUnlock(&_lock);
}

#pragma mark - Internal Methods
// expects _lock to be held when called

- (CGRect)_boundsAtIndex:(NSUInteger)index
{
    CGRect bounds = CGRectZero;

    if (_instanceBounds != NULL) {
        bounds = _instanceBounds[index];
    }

    return bounds;
}

- (CATransform3D)_transformAtIndex:(NSUInteger)index
{
    CATransform3D transform = CATransform3DIdentity;

    if (_instanceTransforms != NULL) {
        transform = _instanceTransforms[index];
    }

    return transform;
}

- (CGPoint)_positionAtIndex:(NSUInteger)index
{
  CGPoint position = CGPointZero;

  if (_instancePositions != NULL) {
    position = _instancePositions[index];
  }

  return position;
}

- (CGPoint)_anchorPointAtIndex:(NSUInteger)index
{
  CGPoint anchorPoint = CGPointMake(0.5, 0.5);

  if (_instanceAnchorPoints != NULL) {
    anchorPoint = _instanceAnchorPoints[index];
  }

  return anchorPoint;
}

- (void)_updateMeshAnimations
{
    [_wrapperLayer removeAllAnimations];

    super.instanceDelay = -STCMeshLayerTotalInstanceDelay / self.instanceCount;

    CAKeyframeAnimation *boundsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.calculationMode = kCAAnimationDiscrete;
    boundsAnimation.duration = STCMeshLayerTotalInstanceDelay;
    boundsAnimation.removedOnCompletion = NO;
    NSMutableArray *boundsValues = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.instanceCount; i++) {
        CGRect bounds = [self _boundsAtIndex:i];
        NSValue *boundsValue = [NSValue valueWithBytes:&bounds objCType:@encode(CGRect)];
        [boundsValues addObject:boundsValue];
    }
    boundsAnimation.values = boundsValues;
    [_wrapperLayer addAnimation:boundsAnimation forKey:STCMeshLayerBoundsAnimationKey];

    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transformAnimation.calculationMode = kCAAnimationDiscrete;
    transformAnimation.duration = STCMeshLayerTotalInstanceDelay;
    transformAnimation.removedOnCompletion = NO;
    NSMutableArray *transformValues = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.instanceCount; i++) {
        CATransform3D transform = [self _transformAtIndex:i];
        NSValue *transformValue = [NSValue valueWithCATransform3D:transform];
        [transformValues addObject:transformValue];
    }
    transformAnimation.values = transformValues;
    [_wrapperLayer addAnimation:transformAnimation forKey:STCMeshLayerTransformAnimationKey];

    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.calculationMode = kCAAnimationDiscrete;
    positionAnimation.duration = STCMeshLayerTotalInstanceDelay;
    positionAnimation.removedOnCompletion = NO;
    NSMutableArray *positionValues = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.instanceCount; i++) {
      CGPoint position = [self _positionAtIndex:i];
      NSValue *positionValue = [NSValue valueWithBytes:&position objCType:@encode(CGPoint)];
      [positionValues addObject:positionValue];
    }
    positionAnimation.values = positionValues;
    [_wrapperLayer addAnimation:positionAnimation forKey:STCMeshLayerPositionAnimationKey];

    CAKeyframeAnimation *anchorPointAnimation = [CAKeyframeAnimation animationWithKeyPath:@"anchorPoint"];
    anchorPointAnimation.calculationMode = kCAAnimationDiscrete;
    anchorPointAnimation.duration = STCMeshLayerTotalInstanceDelay;
    anchorPointAnimation.removedOnCompletion = NO;
    NSMutableArray *anchorPointValues = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.instanceCount; i++) {
      CGPoint anchorPoint = [self _anchorPointAtIndex:i];
      NSValue *anchorPointValue = [NSValue valueWithBytes:&anchorPoint objCType:@encode(CGPoint)];
      [anchorPointValues addObject:anchorPointValue];
    }
    anchorPointAnimation.values = anchorPointValues;
    [_wrapperLayer addAnimation:anchorPointAnimation forKey:STCMeshLayerAnchorPointAnimationKey];

    CAKeyframeAnimation *timeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"instanceDelay"];
    timeAnimation.calculationMode = kCAAnimationDiscrete;
    timeAnimation.duration = STCMeshLayerTotalInstanceDelay;
    timeAnimation.removedOnCompletion = NO;
    NSMutableArray *timeValues = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.instanceCount; i++) {
        CFTimeInterval delay = -super.instanceDelay * i;
        [timeValues addObject:@(delay)];
    }
    timeAnimation.values = timeValues;
    [_wrapperLayer addAnimation:timeAnimation forKey:STCMeshLayerInstanceDelayAnimationKey];
}

@end
