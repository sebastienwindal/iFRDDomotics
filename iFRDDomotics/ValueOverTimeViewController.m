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


@interface ValueOverTimeViewController ()<TimeChartDatasource>

@property (weak, nonatomic) IBOutlet TimeChart *historicalChart;
@property (nonatomic, strong) id measurement;

@property (weak, nonatomic) IBOutlet UISegmentedControl *timeSegmentControl;
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

-(void) fetchValuesBetweenDate:(NSDate *)startDate andDate:(NSDate*)endDate
{
    NSTimeInterval duration = [endDate timeIntervalSinceDate:startDate];
    
    if (duration <= 4 * 60 * 60.0) {
        [[FRDDomoticsClient sharedClient] getRawValuesForSensor:self.sensor.sensorID
                                                measurementtype:self.sensor.capabilities
                                                         startDate:startDate
                                                           endDate:endDate
                                                           success:^(FRDDomoticsClient *domoClient, SensorMeasurement *values) {
                                                               self.measurement = values;
                                                               [self.historicalChart updateChart];
                                                           }
                                                           failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
    
                                                           }
         ];
    } else {
        [[FRDDomoticsClient sharedClient] getHourlyValuesForSensor:self.sensor.sensorID
                                                   measurementtype:self.sensor.sensorID
                                                         startDate:startDate
                                                           endDate:endDate
                                                           success:^(FRDDomoticsClient *domoClient, HourlyMeasurement *values) {
                                                               self.measurement = values;
                                                               [self.historicalChart updateChart];
                                                           } failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
                                                               
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
    if ([self.measurement isKindOfClass:[HourlyMeasurement class]])
        return [self.measurement hourOffsets];
    else
        return [self.measurement dateOffsets];
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

@end
