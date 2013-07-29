//
//  DayChart.m
//  iFRDDomotics
//
//  Created by Sebastien Windal on 7/28/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "DayChart.h"
#import <QuartzCore/QuartzCore.h>

@interface DayChart()

@property (nonatomic, strong) CAShapeLayer *hourLineLayer;
@property (nonatomic, strong) NSMutableArray *stateLayers;

@end

@implementation DayChart
{
    CGFloat _pixelPerHour;
}

-(void) clear
{
    for (CALayer *layer in self.stateLayers) {
        [layer removeFromSuperlayer];
    }
    [self.stateLayers removeAllObjects];
}

-(NSMutableArray *) stateLayers
{
    if (_stateLayers == nil) {
        _stateLayers = [[NSMutableArray alloc] init];
    }
    return _stateLayers;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitializer];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitializer];
    }
    return self;
}


-(void) commonInitializer
{
    _pixelPerHour = self.frame.size.height / 24.0f;
    
    [self addColorAreas];
    [self addHourLines];
    
#define ARC4RANDOM_MAX      0x100000000
    float n1 = 24.0f * arc4random() / ARC4RANDOM_MAX;
    float n2 = 24.0f * arc4random() / ARC4RANDOM_MAX;
    n2 = n1 + 4 / 3600.0f;
    [self highLightStateBetweenHour:MIN(n1,n2) andHour:MAX(n1,n2)];
}


-(CGFloat) hourToPixel:(float)hour
{
    return self.frame.size.height * hour / 24.0f;
}

-(void) addColorAreas
{
    
    NSArray *colors = @[ [UIColor colorWithWhite:0.1f alpha:0.2f],
                         [UIColor colorWithWhite:0.4f alpha:0.2f],
                         [UIColor colorWithWhite:0.7f alpha:0.2f],
                         [UIColor colorWithWhite:0.1f alpha:0.2f]
                         ];
    
    for (int i=0; i<4; i++) {
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGFloat startX = 0.0f;
        CGFloat endX =  self.frame.size.width;
        CGFloat startY = [self hourToPixel:i*6];
        CGFloat endY = [self hourToPixel:(i+1)*6];
        CGPathAddRect(path, NULL, CGRectMake(startX, startY, endX-startX, endY-startY));
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        
        layer.path = path;
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.lineWidth = 1.0f;
        layer.strokeColor = [colors[i] CGColor];
        layer.fillColor = [colors[i] CGColor];
        layer.lineCap = kCALineCapRound;
        
        [self.layer addSublayer:layer];

    }
}

-(CGMutablePathRef) hourHorizontalLinesPath
{
    
    CGMutablePathRef path = CGPathCreateMutable();

    CGFloat startX = 0.0f;
    CGFloat endX =  self.frame.size.width;
    
    
    for (int hourIndex = 0; hourIndex <= 24; hourIndex++) {
        CGFloat y = [self hourToPixel:hourIndex];
        CGPathMoveToPoint(path, NULL, startX, y);
        CGPathAddLineToPoint(path, NULL, endX, y);
    }
    
    return path;
}

-(void) addHourLines
{
    self.hourLineLayer = [CAShapeLayer layer];

    CGMutablePathRef path = [self hourHorizontalLinesPath];

    self.hourLineLayer.path = path;
    [self.hourLineLayer setFrame:self.bounds];
    self.hourLineLayer.contentsScale = [UIScreen mainScreen].scale;
    self.hourLineLayer.lineWidth = 1.0f;
    self.hourLineLayer.strokeColor = [UIColor colorWithWhite:0.5 alpha:0.2].CGColor;
    self.hourLineLayer.fillColor = [UIColor clearColor].CGColor;
    self.hourLineLayer.lineCap = kCALineCapRound;
    self.hourLineLayer.lineDashPattern = @[@(2), @(2)];

    CGPathRelease(path);

    [self.layer addSublayer:self.hourLineLayer];
}

-(void) highLightStateBetweenHour:(float)startHour andHour:(float)endHour
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat startX = 0.0f;
    CGFloat endX =  self.frame.size.width;
    
    CGFloat startY = [self hourToPixel:startHour];
    CGFloat endY = [self hourToPixel:endHour];
    CGPathMoveToPoint(path, NULL, startX, startY);
    CGPathAddLineToPoint(path, NULL, endX, startY);
    CGPathAddLineToPoint(path, NULL, endX, endY);
    CGPathAddLineToPoint(path, NULL, startX, endY);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    
    layer.path = path;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.lineWidth = 1.0f;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor redColor].CGColor;
    layer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:layer];
    [self.stateLayers addObject:layer];
}


@end
