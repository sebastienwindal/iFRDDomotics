//
//  TimeChart.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/19/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "TimeChart.h"
#import <QuartzCore/QuartzCore.h>
#import "UnitConverter.h"

@interface TimeChart()

@property (nonatomic, strong) CAShapeLayer *gridLayer;
@property (nonatomic, strong) CAShapeLayer *outerLayer;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CAGradientLayer *areaLayer;
@property (nonatomic, strong) CAShapeLayer *areaMaskLayer;
@property (nonatomic, strong) NSArray *valueTextLayers;
@property (nonatomic, strong) NSArray *timeTextLayers;

@end

@implementation TimeChart
{
    CGFloat width;
    CGFloat height;
    CGFloat drawingWidth; // width without the margins
    CGFloat drawingHeight; // height without the margins
    NSTimeInterval totalDuration;
    float pixelPerSecond;
    float maxVal;
    float minVal;
    float pixelPerValue;
    
    float *timeSeries;
    float *valueSeries;
    int numberValues;
    
    int maximumNumberHorLines;
    int maximumNumberVertLines;
    
}

-(NSDictionary *) colors {
    
    NSDictionary *_colorsDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor colorWithRed:40/255.0f  green:10/255.0f   blue:70/255.0f alpha:1.0f],  @-50.0f,
            [UIColor colorWithRed:37/255.0f  green:11/255.0f   blue:100/255.0f alpha:1.0f], @-45.0f,
            [UIColor colorWithRed:78/255.0f  green:50/255.0f   blue:134/255.0f alpha:1.0f], @-40.0f,
            [UIColor colorWithRed:120/255.0f green:91/255.0f   blue:158/255.0f alpha:1.0f], @-35.0f,
            [UIColor colorWithRed:160/255.0f green:130/255.0f  blue:192/255.0f alpha:1.0f], @-30.0f,
            [UIColor colorWithRed:199/255.0f green:171/255.0f  blue:219/255.0f alpha:1.0f], @-25.0f,
            [UIColor colorWithRed:110/255.0f green:1/255.0f    blue:69/255.0f alpha:1.0f],  @-20.0f,
            [UIColor colorWithRed:163/255.0f green:49/255.0f   blue:136/255.0f alpha:1.0f], @-15.0f,
            [UIColor colorWithRed:215/255.0f green:113/255.0f  blue:206/255.0f alpha:1.0f], @-10.0f,
            [UIColor colorWithRed:167/255.0f green:227/255.0f  blue:251/255.0f alpha:1.0f], @-5.0f,
            [UIColor colorWithRed:89/255.0f  green:118/255.0f  blue:184/255.0f alpha:1.0f], @0.0f,
            [UIColor colorWithRed:22/255.0f  green:19/255.0f   blue:150/255.0f alpha:1.0f], @5.0f,
            [UIColor colorWithRed:122/255.0f green:113/255.0f  blue:98/255.0f alpha:1.0f],  @10.0f,
            [UIColor colorWithRed:216/255.0f green:215/255.0f  blue:49/255.0f alpha:1.0f],  @15.0f,
            [UIColor colorWithRed:217/255.0f green:151/255.0f  blue:3/255.0f alpha:1.0f],   @20.0f,
            [UIColor colorWithRed:214/255.0f green:42/255.0f   blue:6/255.0f alpha:1.0f],   @25.0f,
            [UIColor colorWithRed:146/255.0f green:1/255.0f    blue:0/255.0f alpha:1.0f],   @30.0f,
            [UIColor colorWithRed:245/255.0f green:125/255.0f  blue:199/255.0f alpha:1.0f], @35.0f,
            [UIColor colorWithRed:210/255.0f green:210/255.0f  blue:210/255.0f alpha:1.0f], @40.0f,
            [UIColor colorWithRed:244/255.0f green:0/255.0f    blue:101/255.0f alpha:1.0f], @45.0f,
            [UIColor colorWithRed:149/255.0f green:1/255.0f    blue:51/255.0f alpha:1.0f],  @50.0f,
            nil
            ];
    
    return _colorsDict;
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
    maximumNumberHorLines = 5;
    maximumNumberVertLines = 5;
    
    self.userInteractionEnabled = YES;
    
    width = self.frame.size.width;
    height= self.frame.size.height;
    drawingWidth = width - [self leftMargin] - [self rightMargin];
    drawingHeight = height - [self topMargin] - [self bottomMargin];
    
    [self computeMetrics];
    
    [self addOuterLayer];
    [self addGridLayer];
    [self addLineLayer];
    [self addAreaLayer];
    [self addAreaMaskLayer];
    [self addValueLegend];
}

-(NSArray *) timeTextLayers {
    if (_timeTextLayers == nil) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:maximumNumberVertLines];
        for (int i=0; i<maximumNumberVertLines; i++) {
            [arr addObject:[CATextLayer layer]];
            
            _timeTextLayers = [arr copy];
        }
    }
    return _timeTextLayers;
}


-(NSArray *) valueTextLayers {
    if (_valueTextLayers == nil) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:maximumNumberHorLines];
        
        for (int i=0; i<maximumNumberHorLines; i++)
             [arr addObject:[CATextLayer layer]];
        
        _valueTextLayers = [arr copy];
    }
    return _valueTextLayers;
}


-(CGFloat) leftMargin
{
    return 30.0f;
}

-(CGFloat) rightMargin
{
    return 10.0f;
}

-(CGFloat) topMargin
{
    return 5.0f;
}

-(CGFloat) bottomMargin
{
    return 10.0f;
}

-(void) computeMetrics
{
    if (!self.datasource)
        return;
    
    NSArray *times = [self.datasource timeChartTimeValues:self];
    NSArray *vals = [self.datasource timeChart:self valuesForLine:0];
    numberValues = [vals count];
    
    totalDuration = [times.lastObject floatValue];
    
    if (timeSeries) free(timeSeries);
    if (valueSeries) free(valueSeries);
    
    timeSeries = malloc(sizeof(CGFloat) * numberValues);
    valueSeries = malloc(sizeof(CGFloat) * numberValues);
    
    minVal = MAXFLOAT;
    maxVal = -MAXFLOAT;
    
    for (int i=0; i<[vals count]; i++) {
        timeSeries[i] = [times[i] floatValue];
        valueSeries[i] = [self.datasource convertValueToLocalUnit:[vals[i] floatValue]];
        minVal = MIN(minVal, valueSeries[i]);
        maxVal = MAX(maxVal, valueSeries[i]);
    }
    minVal -= 4;
    maxVal += 1;
    
    if (maxVal != minVal)
        pixelPerValue = drawingHeight / (maxVal - minVal);
    else
        pixelPerValue = 0;
    if (numberValues > 0)
        pixelPerSecond = drawingWidth / totalDuration;
    
    
}


-(CGFloat) timeToPixels:(float) time
{
    if (totalDuration == 0) return 0.0f;
    
    return [self leftMargin] + pixelPerSecond * time;
}


-(CGFloat) valueToPixels:(float) value
{
    if (minVal == maxVal) return 0.0f;
    
    return [self bottomMargin] + pixelPerValue * (value-minVal);
}


-(CGMutablePathRef) gridPath
{  

    CGMutablePathRef path = CGPathCreateMutable();
    [self addHorizontalLinesToPath:path];
    [self addVerticalLinesToPath:path];
    
    return path;
}

-(void) addHorizontalLinesToPath:(CGMutablePathRef)path
{
    CGFloat startX = [self leftMargin];
    CGFloat endX =  self->width - [self rightMargin];
    
    float amplitude = maxVal - minVal;
    // ideally we want between 3 and 5 horizontal lines,
    // and we want those lines to fit on round numbers...
    
    float delta = floor(amplitude/maximumNumberHorLines);
    if (delta < 1.0f) delta = 1.0f;
    else if (delta < 2.0f) delta = 2.0f;
    else if (delta < 5.0f) delta = 5.0f;
    else if (delta < 10.0f) delta = 10.0f;
    else if (delta < 20.0f) delta = 20.0f;
    else if (delta < 50.0f) delta = 50.0f;
    else if (delta < 100.0f) delta = 100.0f;
    else if (delta < 200.0f) delta = 200.0f;
    else if (delta < 500.0f) delta = 500.0f;
    else if (delta < 1000.0f) delta = 1000.0f;
    
    float val = ceilf(minVal / delta) * delta;
    
    int i=0;
    float textheight = 20.0f;
    while (val < maxVal) {
        CGPathMoveToPoint(path, NULL, startX, [self valueToPixels:val]);
        CGPathAddLineToPoint(path, NULL, endX, [self valueToPixels:val]);
        
        CATextLayer *textLayer = self.valueTextLayers[i];
        textLayer.string = [NSString stringWithFormat:@"%.0f", val];
        textLayer.frame = CGRectMake(0,
                                     self.frame.size.height - [self valueToPixels:val] - textheight/2.0f,
                                     [self leftMargin]-5,
                                     textheight);
        
        val += delta;
        i++;
    }
    while (i < maximumNumberHorLines) {
        // some lables may not be displayed anymore...
        CATextLayer *textLayer = self.valueTextLayers[i];
        textLayer.string = @"";
        i++;
    }

}


-(void) addVerticalLinesToPath:(CGMutablePathRef)path
{
    NSDate *startDate = [self.datasource timeChartOldestDate:self];
    
    NSTimeInterval timeDelta;
    BOOL roundToHour = YES;
    BOOL roundToWeek = NO;
    
    if (totalDuration <= 4 * 3600.0f)
        timeDelta = 3600.0f;
    else if (totalDuration <= 24 * 3600.0f)
        timeDelta = 6 * 3600.0f;
    else if (totalDuration <= 4 * 24 * 3600.0f) {
        timeDelta = 24 * 3600.0f;
        roundToHour = NO;
    } else if (totalDuration <= 7 * 24 * 3600.0f) {
        timeDelta = 24 * 2 * 3600.0f;
        roundToHour = NO;
    } else if (totalDuration <= 28 * 24 * 3600.0f) {
        timeDelta = 7 * 24 * 3600.0f;
        roundToHour = NO;
        roundToWeek = YES;
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:startDate];
    if (roundToHour)
        [components setHour:[components hour] + 1];
    else {
        // round to midnight
        [components setDay:[components day] + 1];
        if (roundToWeek)
            [components setWeek:[components week] + 1];
    }
    
    NSDate *roundHourDate = [gregorian dateFromComponents:components];
    
    CGFloat startY = [self bottomMargin];
    CGFloat endY =  self->height - [self topMargin];
    
    NSTimeInterval t = [roundHourDate timeIntervalSinceDate:startDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString;
    if (roundToHour)
        formatString = @"HH:mm";
    else if (roundToWeek)
        formatString = @"MM/dd";
    else
        formatString = @"EE";
    
    [dateFormatter setDateFormat:formatString];

    
    int i=0;

    while (t < totalDuration) {
        float x = [self timeToPixels:t];
        CGPathMoveToPoint(path, NULL, x, startY);
        CGPathAddLineToPoint(path, NULL, x, endY);
        
        CATextLayer *textLayer = self.timeTextLayers[i];
        NSDate *date = [startDate dateByAddingTimeInterval:t];
        
        textLayer.string = [dateFormatter stringFromDate:date];
        textLayer.frame = CGRectMake(x-20,
                                     endY,
                                     40.0,
                                     20.0);
        
        t += timeDelta;
        i++;
    }
    while (i<maximumNumberVertLines) {
        [self.timeTextLayers[i++] setString:@""];
    }
}


-(CGMutablePathRef) outerPath
{
    CGFloat startX = [self leftMargin];
    CGFloat endX =  self->width - [self rightMargin];
    CGFloat startY = [self bottomMargin];
    CGFloat endY = self->height - [self topMargin];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, startX, startY);
    CGPathAddLineToPoint(path, NULL, endX, startY);
    
    CGPathAddLineToPoint(path, NULL, endX, endY);
    CGPathAddLineToPoint(path, NULL, startX, endY);
    CGPathAddLineToPoint(path, NULL, startX, startY);
    
    return path;
}


-(CGMutablePathRef) linePath
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    if(numberValues > 1) {
        CGPathMoveToPoint(path, NULL, [self timeToPixels:timeSeries[0]], [self valueToPixels:valueSeries[0]]);
        for (int i=0; i<numberValues; i++) {
            CGPathAddLineToPoint(path, NULL, [self timeToPixels:timeSeries[i]], [self valueToPixels:valueSeries[i]]);
        }
        CGPathAddLineToPoint(path, NULL, [self timeToPixels:timeSeries[numberValues-1]], [self valueToPixels:valueSeries[numberValues -1]]);
    }
    return path;
}

-(CGMutablePathRef) areaPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    if(numberValues > 1) {
        if(numberValues > 1) {
            CGPathMoveToPoint(path, NULL, [self timeToPixels:timeSeries[numberValues-1]], [self valueToPixels:minVal]);
            CGPathAddLineToPoint(path, NULL, [self timeToPixels:timeSeries[0]], [self valueToPixels:minVal]);
            int i;
            for (i=0; i<numberValues; i++) {
                CGPathAddLineToPoint(path, NULL, [self timeToPixels:timeSeries[i]], [self valueToPixels:valueSeries[i]]);
            }
            CGPathAddLineToPoint(path, NULL, [self timeToPixels:timeSeries[numberValues-1]], [self valueToPixels:minVal]);
            float x = [self timeToPixels:timeSeries[numberValues-1]];
            float y = [self valueToPixels:valueSeries[numberValues-1]];
            // when transitioning from a filled CGPath to a filled CGPath with less points,
            // results are not visually pleasing. Add points to make sure we have the same number
            // of points no matter what the time selection is...
            // highest number of points: 4 wks: 4 * 7 * 24 = 672.
            while (i<700) {
                CGPathAddLineToPoint(path, NULL, x, y);
                i++;
            }
        }
    }
    return path;
}


-(void) addGridLayer
{
    self.gridLayer = [CAShapeLayer layer];
    
    CGMutablePathRef path = [self gridPath];
    
    self.gridLayer.path = path;
    [self.gridLayer setFrame:self.bounds];
    self.gridLayer.transform = CATransform3DMakeScale(1.0f, -1.0f, 1.0f);
    self.gridLayer.contentsScale = [UIScreen mainScreen].scale;
    self.gridLayer.lineWidth = 1.0f;
    self.gridLayer.strokeColor = [UIColor colorWithWhite:0.7 alpha:0.5].CGColor;
    self.gridLayer.fillColor = [UIColor clearColor].CGColor;
    self.gridLayer.lineCap = kCALineCapRound;
    self.gridLayer.lineDashPattern = @[@(3), @(5)];
    
    CGPathRelease(path);
    
    [self.layer addSublayer:self.gridLayer];
}


-(void) addOuterLayer
{
    self.outerLayer = [CAShapeLayer layer];
    
    CGMutablePathRef path = [self outerPath];
    
    self.outerLayer.path = path;
    [self.outerLayer setFrame:self.bounds];
    self.outerLayer.transform = CATransform3DMakeScale(1.0f, -1.0f, 1.0f);
    self.outerLayer.lineWidth = 1.0f;
    self.outerLayer.strokeColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    self.outerLayer.fillColor = [UIColor clearColor].CGColor;
    self.outerLayer.lineCap = kCALineCapRound;
    self.outerLayer.contentsScale = [UIScreen mainScreen].scale;
    
    CGPathRelease(path);
    
    [self.layer addSublayer:self.outerLayer];
}


-(void) addLineLayer
{
    self.lineLayer = [CAShapeLayer layer];
     
     CGMutablePathRef path = [self linePath];
    
     self.lineLayer.path = path;
     [self.lineLayer setFrame:self.bounds];
     self.lineLayer.transform = CATransform3DMakeScale(1.0f, -1.0f, 1.0f);
     self.lineLayer.lineWidth = 2.0f;
     self.lineLayer.strokeColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
     self.lineLayer.fillColor = [UIColor clearColor].CGColor;
     self.lineLayer.lineCap = kCALineCapRound;
     self.lineLayer.contentsScale = [UIScreen mainScreen].scale;
     
     CGPathRelease(path);
     
     [self.layer addSublayer:self.lineLayer];
}

-(void) addAreaMaskLayer
{
    CGMutablePathRef path = [self areaPath];
    self.areaMaskLayer = [CAShapeLayer layer];
    self.areaMaskLayer.path = path;
    self.areaMaskLayer.lineWidth = 0.0f;
    self.areaMaskLayer.strokeColor = [UIColor blackColor].CGColor;
    self.areaMaskLayer.fillColor = [UIColor colorWithWhite:0.0 alpha:0.8f].CGColor;
    self.areaMaskLayer.lineCap = kCALineCapRound;
    
    self.areaLayer.mask = self.areaMaskLayer;

    CGPathRelease(path);
}


-(void) addAreaLayer
{
    self.areaLayer = [CAGradientLayer layer];

    [self.areaLayer setFrame:self.bounds];
    self.areaLayer.transform = CATransform3DMakeScale(1.0f, -1.0f, 1.0f);
    
    self.areaLayer.contentsScale = [UIScreen mainScreen].scale;
    
    self.areaLayer.startPoint = CGPointMake(0.5,1.0);
    self.areaLayer.endPoint = CGPointMake(0.5,0.0);

    
    [self.layer addSublayer:self.areaLayer];
}

-(void) addValueLegend
{
    for (CATextLayer *textLayer in [self valueTextLayers]) {
        textLayer.foregroundColor = [UIColor colorWithWhite:0.4 alpha:1.0f].CGColor;
        textLayer.font = (__bridge CFTypeRef)(@"GillSans");
        textLayer.alignmentMode = kCAAlignmentRight;
        textLayer.fontSize = 18.0f;
        textLayer.contentsScale = [UIScreen mainScreen].scale;


        [self.layer addSublayer:textLayer];
    }
    
    for (CATextLayer *textLayer in [self timeTextLayers]) {
        textLayer.foregroundColor = [UIColor colorWithWhite:0.4 alpha:1.0f].CGColor;
        textLayer.font = (__bridge CFTypeRef)(@"GillSans");
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.fontSize = 15.0f;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        
        [self.layer addSublayer:textLayer];
    }
}

-(void) updateGridLayerAnimated:(BOOL)animated
{
    NSTimeInterval animationInterval = 0.5;
    CGMutablePathRef path = [self gridPath];
    
    if (animated) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        anim.duration = animationInterval;
        anim.fromValue = (__bridge id)self.gridLayer.path;
        anim.toValue = (__bridge id)(path);
        
        [self.gridLayer addAnimation:anim forKey:@"animatePath"];
    }
    self.gridLayer.path = path;
    CGPathRelease(path);
    
}


-(void) updateOuterLayer
{
    CGMutablePathRef path = [self outerPath];
    self.outerLayer.path = path;
    CGPathRelease(path);
}


-(void) updateLineLayerAnimated:(BOOL)animated
{
    NSTimeInterval animationInterval = 0.5;
    CGMutablePathRef newPath = [self linePath];
    
    if (animated) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        anim.duration = animationInterval;
        anim.fromValue = (__bridge id)self.lineLayer.path;
        anim.toValue = (__bridge id)(newPath);
        
        [self.lineLayer addAnimation:anim forKey:@"animatePath"];
    }
    self.lineLayer.path = newPath;
    CGPathRelease(newPath);
}

-(void) updateGradientStopsAnimated:(BOOL)animated
{
    NSMutableArray *gradStops = [NSMutableArray array];
    NSMutableArray *gradLocations = [NSMutableArray array];
    
    float val = minVal;
    val = 5.0f * ceilf(minVal / 5.0f);
    UIColor *c = [self colors][@(val)];

    if (c) {
        [gradLocations insertObject:@(1.0f-(val-minVal)/(maxVal-minVal)) atIndex:0];
        [gradStops insertObject:(id)[c CGColor] atIndex:0];
    }
    
    val += 5.0f;
    while (val < maxVal) {
        UIColor *c = [self colors][@(val)];
        if (c) {
            [gradLocations insertObject:@(1.0f-(val-minVal)/(maxVal-minVal)) atIndex:0];
            [gradStops insertObject:(id)[c CGColor] atIndex:0];
            
        }
        val +=  5.0f;
    }
        
    self.areaLayer.colors = gradStops;
    self.areaLayer.locations = gradLocations;
}

-(void) updateAreaLayerAnimated:(BOOL)animated
{
    NSTimeInterval animationInterval = 0.5;
    CGMutablePathRef newPath = [self areaPath];
    
    if (animated) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        anim.duration = animationInterval;
        anim.fromValue = (__bridge id)self.areaMaskLayer.path;
        anim.toValue = (__bridge id)(newPath);
        
        [self.areaMaskLayer addAnimation:anim forKey:@"animatePath"];
    }
    self.areaMaskLayer.path = newPath;
    CGPathRelease(newPath);
}


-(void) updateChart
{
    [self.layer removeAllAnimations];
    
    [self computeMetrics];
    
    [self updateOuterLayer];
    [self updateGridLayerAnimated:YES];
    [self updateAreaLayerAnimated:YES];
    [self updateLineLayerAnimated:YES];
    [self updateGradientStopsAnimated:YES];
}



@end
