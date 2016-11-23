//
//  ViewController.m
//  animation
//
//  Created by hlq on 16/11/23.
//  Copyright © 2016年 ustb. All rights reserved.
//

#import "SpringViewController.h"

#define beginY 64
#define  SYSTEM_SCREEN_W ([UIScreen mainScreen].bounds.size.width)
#define  SYSTEM_SCREEN_H ([UIScreen mainScreen].bounds.size.height)
@interface SpringViewController ()<CAAnimationDelegate>
@property (nonatomic, strong) CAShapeLayer *shaperLayer;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGPoint controllerPoint;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecongnizer;
@property (nonatomic, strong) UIView *controllerPointView;
@property (nonatomic, assign, getter=isAnimation) BOOL animation;
@property (nonatomic, assign) CGFloat duration;
@end

@implementation SpringViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shaperLayer = [[CAShapeLayer alloc] init];
    self.shaperLayer.fillColor = [UIColor blueColor].CGColor;
    self.shaperLayer.frame = CGRectMake(0, beginY,SYSTEM_SCREEN_W,SYSTEM_SCREEN_H-beginY);
    self.shaperLayer.strokeColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:self.shaperLayer];
    [self drawBeginShapeLayer:CGPointMake(SYSTEM_SCREEN_W/2.0, beginY)];
    self.panGestureRecongnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDidMove:)];
    [self.view addGestureRecognizer:self.panGestureRecongnizer];
    self.duration = 0.5;
}

- (void)panGestureDidMove:(UIPanGestureRecognizer *)panGestureRecongnizer
{
    
    CGPoint point = [panGestureRecongnizer translationInView:self.view];
    if (panGestureRecongnizer.state == UIGestureRecognizerStateBegan) {
        self.beginPoint = point;
    } else if (panGestureRecongnizer.state == UIGestureRecognizerStateChanged) {
        self.controllerPoint = CGPointMake(SYSTEM_SCREEN_W/2.0+(point.x-self.beginPoint.x), beginY+(point.y-self.beginPoint.y));
        [self drawBeginShapeLayer:self.controllerPoint];
    } else if (panGestureRecongnizer.state == UIGestureRecognizerStateEnded || panGestureRecongnizer.state == UIGestureRecognizerStateCancelled) {
        [self createControllerView];
        self.controllerPoint = point;
    }
}

- (void)createControllerView
{
    self.controllerPointView = [[UIView alloc] init];
    self.controllerPointView.bounds = CGRectMake(0, 0, 10, 10);
    self.controllerPointView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.controllerPointView];
    
    
    CASpringAnimation *springAnimation = [[CASpringAnimation alloc] init];
    springAnimation.keyPath = @"postion";
    springAnimation.duration = self.duration;
    springAnimation.delegate = self;
    springAnimation.fromValue  = [NSValue valueWithCGPoint:self.controllerPoint];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(SYSTEM_SCREEN_W/2.0, beginY)];
    
    
    [self.controllerPointView.layer addAnimation:springAnimation forKey:nil];
    
}

- (void)animationDidStart:(CAAnimation *)anim{
    self.animation = YES;
    [self.controllerPointView.layer.presentationLayer addObserver:self forKeyPath:@"postion" options:NSKeyValueObservingOptionNew context:nil];
}



- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.animation = NO;
    [self.controllerPointView.layer removeAllAnimations];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"postion"]) {
        
    }
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




- (void)dealloc
{
    [self.panGestureRecongnizer removeTarget:self action:@selector(panGestureDidMove:)];
}
@end
