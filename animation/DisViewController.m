//
//  ViewController.m
//  animation
//
//  Created by hlq on 16/11/23.
//  Copyright © 2016年 ustb. All rights reserved.
//

#import "DisViewController.h"

#define beginY 100
#define  SYSTEM_SCREEN_W ([UIScreen mainScreen].bounds.size.width)
#define  SYSTEM_SCREEN_H ([UIScreen mainScreen].bounds.size.height)
@interface DisViewController ()
@property (nonatomic, strong) CAShapeLayer *shaperLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGPoint controllerPoint;
@property (nonatomic, assign) CGPoint controllerBeginPoint;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecongnizer;
@property (nonatomic, assign) CGFloat timeOffset;
@property (nonatomic, assign) CGFloat duration;
@end

@implementation DisViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shaperLayer = [[CAShapeLayer alloc] init];
    self.shaperLayer.fillColor = [UIColor blueColor].CGColor;
    self.shaperLayer.frame = CGRectMake(0, 0,SYSTEM_SCREEN_W,SYSTEM_SCREEN_H);
    self.shaperLayer.strokeColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:self.shaperLayer];
    [self drawBeginShapeLayer:CGPointMake(SYSTEM_SCREEN_W/2.0, beginY)];
    self.panGestureRecongnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDidMove:)];
    [self.view addGestureRecognizer:self.panGestureRecongnizer];
    self.duration = 0.5;
}

- (void)displayLinkMethod:(CADisplayLink *)displayLink
{
    self.timeOffset = fmin(self.timeOffset+1/60.0, self.duration);
    CGFloat x = (SYSTEM_SCREEN_W/2.0-self.controllerBeginPoint.x) * ElasticEaseOut(self.timeOffset/self.duration) + self.controllerBeginPoint.x;
    CGFloat y = (beginY-self.controllerBeginPoint.y) * ElasticEaseOut(self.timeOffset/self.duration) + self.controllerBeginPoint.y;
    [self drawBeginShapeLayer:CGPointMake(x, y)];
    if (self.timeOffset >= self.duration) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        self.timeOffset = 0;
    }
}
- (void)panGestureDidMove:(UIPanGestureRecognizer *)panGestureRecongnizer
{
    if (self.displayLink && ![self.displayLink isPaused]) {
        return;
    }
    
    CGPoint point = [panGestureRecongnizer translationInView:self.view];
    if (panGestureRecongnizer.state == UIGestureRecognizerStateBegan) {
        self.beginPoint = point;
    } else if (panGestureRecongnizer.state == UIGestureRecognizerStateChanged) {
        self.controllerPoint = CGPointMake(SYSTEM_SCREEN_W/2.0+(point.x-self.beginPoint.x), beginY+(point.y-self.beginPoint.y));
        [self drawBeginShapeLayer:self.controllerPoint];
    } else if (panGestureRecongnizer.state == UIGestureRecognizerStateEnded || panGestureRecongnizer.state == UIGestureRecognizerStateCancelled) {
        [self createDisplayLink];
        self.controllerBeginPoint = point;
    }
}

- (void)createDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkMethod:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink.paused = NO;
}

- (void)drawBeginShapeLayer:(CGPoint)point
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, beginY)];
    [path addQuadCurveToPoint:CGPointMake(SYSTEM_SCREEN_W, beginY) controlPoint:point];
    [path addLineToPoint:CGPointMake(SYSTEM_SCREEN_W, SYSTEM_SCREEN_H)];
    [path addLineToPoint:CGPointMake(0, SYSTEM_SCREEN_H)];
    [path addLineToPoint:CGPointMake(0, beginY)];
    self.shaperLayer.path = path.CGPath;
}




static CGFloat ElasticEaseOut(CGFloat p)
{
    return sin(-13 * M_PI_2 * (p + 1)) * pow(2, -10 * p) + 1;
}
- (void)dealloc
{
    [self.panGestureRecongnizer removeTarget:self action:@selector(panGestureDidMove:)];
}
@end
