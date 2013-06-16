//
//  ValueOverTimeViewController.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/19/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "ValueOverTimeViewController.h"
#import "TimeChart.h"
#import "FRDDomoticsClient.h"
#import "SensorMeasurement.h"
#import "HourlyMeasurement.h"
#import "UnitConverter.h"
#import "ColorThresholds.h"
#import "PersistentStorage.h"
#import "IcoMoon.h"
#import <QuartzCore/QuartzCore.h>
#import "KGStatusBar.h"

typedef enum {
    kChartLoadStatePending,
    kChartLoadStateCompletedWithSuccess,
    kChartLoadStateCompletedWithError,
} kChartLoadStates;

@interface ValueOverTimeViewController ()<TimeChartDatasource>

@property (weak, nonatomic) IBOutlet TimeChart *historicalChart;
@property (nonatomic, strong) id measurement;

@property (weak, nonatomic) IBOutlet UILabel *chartLoadLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *timeSegmentControl;

@property (nonatomic) kChartLoadStates loadState;
@property (nonatomic, strong) CABasicAnimation *reloadRotationAnimation;

@end

@implementation ValueOverTimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.historicalChart.datasource = self;
    
    [self.historicalChart updateChart];
    
    [self timeIntervalChanged:self.timeSegmentControl];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setLoadIconFromMeasurement];
}

-(void) setLoadIconFromMeasurement
{
    if (self.sensor.capabilities == kSensorCapabilities_HUMIDITY)
        self.chartLoadLabel.text = [IcoMoon iconString:ICOMOON_TINT];
    else if (self.sensor.capabilities  == kSensorCapabilities_TEMPERATURE)
        self.chartLoadLabel.text = [IcoMoon iconString:ICOMOON_THERMOMETER_1];
    else if (self.sensor.capabilities  == kSensorCapabilities_LUMMINOSITY)
        self.chartLoadLabel.text = [IcoMoon iconString:ICOMOON_SUN_3];
    
    else self.chartLoadLabel.text = [IcoMoon iconString:ICOMOON_LOOP];
}

-(void) fetchValuesBetweenDate:(NSDate *)startDate andDate:(NSDate*)endDate
{
    self.loadState = kChartLoadStatePending;
    [KGStatusBar showWithStatus:@"Loading..."];
    
    NSTimeInterval duration = [endDate timeIntervalSinceDate:startDate];
    
    if (duration <= 4 * 60 * 60.0) {
        [[FRDDomoticsClient sharedClient] getRawValuesForSensor:self.sensor.sensorID
                                                measurementtype:self.sensor.capabilities
                                                         startDate:startDate
                                                           endDate:endDate
                                                           success:^(FRDDomoticsClient *domoClient, SensorMeasurement *values) {
                                                               self.measurement = values;
                                                               [self.historicalChart updateChart];
                                                               self.loadState = kChartLoadStateCompletedWithSuccess;
                                                               [KGStatusBar dismiss];
                                                           }
                                                           failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
                                                               self.loadState = kChartLoadStateCompletedWithError;
                                                               [KGStatusBar showErrorWithStatus:@"Failed to get data..."];
                                                           }
         ];
    } else {
        [[FRDDomoticsClient sharedClient] getHourlyValuesForSensor:self.sensor.sensorID
                                                   measurementtype:self.sensor.capabilities
                                                         startDate:startDate
                                                           endDate:endDate
                                                           success:^(FRDDomoticsClient *domoClient, HourlyMeasurement *values) {
                                                               self.measurement = values;
                                                               [self.historicalChart updateChart];
                                                               self.loadState = kChartLoadStateCompletedWithSuccess;
                                                               [KGStatusBar dismiss];
                                                           } failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
                                                               self.loadState = kChartLoadStateCompletedWithError;
                                                               [KGStatusBar showErrorWithStatus:@"Failed to get data..."];
                                                           }
         ];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)timeIntervalChanged:(UISegmentedControl *)timeSegmentControl
{
    NSDate *endDate = [NSDate date];
    NSDate *startDate = endDate;
    switch(timeSegmentControl.selectedSegmentIndex) {
        case 0: // last 4 hours
            startDate = [endDate dateByAddingTimeInterval:-4*60*60.0f];
            break;
        case 1: // last 24 hrs
            startDate = [endDate dateByAddingTimeInterval:-24*60*60.0f];
            break;
        case 2: // 7 days
            startDate = [endDate dateByAddingTimeInterval:-24*60*60.0f*7];
            break;
        case 3: // 4 weeks
            startDate = [endDate dateByAddingTimeInterval:-24*60*60.0f*7*4];
            break;
    }
    
    [self fetchValuesBetweenDate:startDate andDate:endDate];
}


-(NSArray *) timeChartTimeValues:(TimeChart *)chart
{
    if ([self.measurement isKindOfClass:[HourlyMeasurement class]]) {
        NSMutableArray *convertedArray = [[self.measurement hourOffsets] mutableCopy];
        
        for (int i=0; i<[convertedArray count]; i++)
            convertedArray[i] = @([convertedArray[i] floatValue] * 3600.0f);
        
        return [convertedArray copy];
    } else {
        return [self.measurement dateOffsets];
    }
}

-(int) timeChartNumberLines:(TimeChart *)chart
{
    return 1;
}

-(NSArray *) timeChart:(TimeChart *)chart valuesForLine:(int)lineIndex
{
    if ([self.measurement isKindOfClass:[HourlyMeasurement class]])
        return [self.measurement meanValues];
    else
        return [self.measurement values];
}

-(NSDate *) timeChartOldestDate:(TimeChart *)chart
{
    return [self.measurement oldestDate];
}

-(float) convertValueToLocalUnit:(float)value
{
    if ([self.measurement measurementType] == kSensorCapabilities_TEMPERATURE)
        return [UnitConverter toLocaleTemperature:value];
    return value;
}

-(NSArray *) gradientColorsBetweenValue:(float)minVal andValue:(float)maxVal
{
    if ([self.measurement measurementType] == kSensorCapabilities_TEMPERATURE)
        return [self gratiendTempColorsBetweenValue:minVal andValue:maxVal];
    else if ([self.measurement measurementType] == kSensorCapabilities_LUMMINOSITY)
        return [self gradientLumColorsBetweenValue:minVal andValue:maxVal];
    else
        return [self gradiendHumidityColorsBetweenValue:minVal andValue:maxVal];
        
}

-(NSArray *) gradientLumColorsBetweenValue:(float)minVal andValue:(float)maxVal
{
    return @[
             (id) [[UIColor orangeColor] CGColor],
             (id) [[UIColor darkGrayColor] CGColor]
                ];
}

-(NSArray *) gradiendHumidityColorsBetweenValue:(float)minVal andValue:(float)maxVal
{
    NSMutableArray *arr = [@[
             (id) [[UIColor blueColor] CGColor],
             (id) [[UIColor orangeColor] CGColor]
             ] mutableCopy];
    
    return arr;
}


-(void) setLoadState:(kChartLoadStates)loadState
{
    _loadState = loadState;
    
    if (loadState == kChartLoadStatePending) {
        [self startRotateReloadLabel];
        self.chartLoadLabel.alpha = 1.0f;
        self.historicalChart.alpha = 0.5f;
    } else if (loadState == kChartLoadStateCompletedWithError) {
        self.chartLoadLabel.alpha = 0.0f;
        self.historicalChart.alpha = 1.0f;
        [self endRotateReloadLabel];
    } else if (loadState == kChartLoadStateCompletedWithSuccess) {
        self.chartLoadLabel.alpha = 0.0f;
        self.historicalChart.alpha = 1.0f;
        [self endRotateReloadLabel];
    }
}


-(void) startRotateReloadLabel
{
    [self.chartLoadLabel.layer addAnimation:self.reloadRotationAnimation forKey:@"rotationAnimation"];
}

-(void) endRotateReloadLabel
{
    [self.chartLoadLabel.layer removeAllAnimations];
    self.reloadRotationAnimation = nil;
}


-(NSArray *) gratiendTempColorsBetweenValue:(float)minVal andValue:(float)maxVal
{
    float interval = [[PersistentStorage sharedInstance] celcius] ? 5.0f : 10.0f;
    
    ColorThresholds *colorThreshold = [[ColorThresholds alloc] init];
    NSMutableArray *gradStops = [NSMutableArray array];
    
    float val = minVal;
    val = interval * ceilf(minVal / interval);
    UIColor *c = colorThreshold.temperatureColorsDict[@(val)];
    
    if (c) {
        [gradStops insertObject:(id)[c CGColor] atIndex:0];
    }
    val = interval * floorf(minVal / interval);
    val += interval;
    while (val < maxVal) {
        UIColor *c = colorThreshold.temperatureColorsDict[@(val)];
        if (c) {
            [gradStops insertObject:(id)[c CGColor] atIndex:0];
        }
        val +=  interval;
    }
    return gradStops;
}


-(NSArray *) gradientStopsBetweenValue:(float)minVal andValue:(float)maxVal
{
    if ([self.measurement measurementType] == kSensorCapabilities_TEMPERATURE)
        return [self gradientTempStopsBetweenValue:minVal andValue:maxVal];
    else 
        return @[@(0.0f), @(1.0f)];
}


-(CABasicAnimation *) reloadRotationAnimation
{
    if (!_reloadRotationAnimation) {
        int repeat = 99999999;
        NSTimeInterval duration = 0.3;
        
        _reloadRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        _reloadRotationAnimation.toValue = @1.5f; //[NSNumber numberWithFloat: M_PI * 2.0 * duration ];
        _reloadRotationAnimation.duration = duration;
        //_reloadRotationAnimation.cumulative = YES;
        _reloadRotationAnimation.repeatCount = repeat;
        _reloadRotationAnimation.autoreverses = YES;
    }
    return _reloadRotationAnimation;
}


-(NSArray *) gradientTempStopsBetweenValue:(float)minVal andValue:(float)maxVal
{
    float interval = [[PersistentStorage sharedInstance] celcius] ? 5.0f : 10.0f;
    
    NSMutableArray *gradLocations = [NSMutableArray array];
    ColorThresholds *colorThreshold = [[ColorThresholds alloc] init];
    
    float val = minVal;
    val = interval * ceilf(minVal / interval);
    UIColor *c = colorThreshold.temperatureColorsDict[@(val)];
    
    if (c) {
        [gradLocations insertObject:@(1.0f-(val-minVal)/(maxVal-minVal)) atIndex:0];
    }
    val = interval * floorf(minVal / interval);
    
    val += interval;
    while (val < maxVal) {
        UIColor *c = colorThreshold.temperatureColorsDict[@(val)];
        if (c) {
            [gradLocations insertObject:@(1.0f-(val-minVal)/(maxVal-minVal)) atIndex:0];
        }
        val +=  interval;
    }
    return gradLocations;
}

@end
