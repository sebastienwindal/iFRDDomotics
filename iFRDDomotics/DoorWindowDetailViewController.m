//
//  DoorWindowDetailViewController.m
//  iFRDDomotics
//
//  Created by Sebastien on 7/3/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "DoorWindowDetailViewController.h"
#import "FRDDomoticsClient.h"
#import "OpenClosePoint.h"


@interface DoorWindowDetailViewController ()

@end

@implementation DoorWindowDetailViewController

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
    
    [self fetchValues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) fetchValues
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setDay:-6];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *sevenDaysAgo = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    
    components = [cal components:NSDayCalendarUnit fromDate:sevenDaysAgo];
    [components setDay:7];
    
    NSDate *now = [NSDate date];
    
    NSMutableArray *openTimesAndDuration = [[NSMutableArray alloc] init]; // array of OpenClosePoint objects.
    
    [[FRDDomoticsClient sharedClient] getRawValuesForSensor:self.sensorID
                                            measurementtype:kSensorCapabilities_LEVEL
                                                  startDate:sevenDaysAgo
                                                    endDate:now
                                                    success:^(FRDDomoticsClient *domoClient, SensorMeasurement *values) {
                                                        
                                                        if (![values.values count])
                                                            return;
                                                        
                                                        OpenClosePoint *point = [OpenClosePoint openClosePointForState:([values.values[0] intValue]==1) relativeDate:0];
                                                        point.date = values.oldestDate;
                                                        
                                                        [openTimesAndDuration addObject:point];
                                                        
                                                        OpenClosePoint *lastPoint = point;
                                                        
                                                        for (int i=1; i<values.values.count; i++) {
                                                            BOOL isOpen = [values.values[i] intValue] == 1;
                                                            if (lastPoint.isOpen == isOpen)
                                                                continue;
                                                            
                                                            // ok this is not a dupe point, record it.
                                                            OpenClosePoint *newPoint = [OpenClosePoint openClosePointForState:isOpen relativeDate:(double)[values.dateOffsets[i] floatValue]];
                                                            newPoint.date = [values.oldestDate dateByAddingTimeInterval:newPoint.relativeDate];
                                                            lastPoint.stateDuration = newPoint.relativeDate - lastPoint.relativeDate;
                                                            [openTimesAndDuration addObject:newPoint];
                                                            
                                                            lastPoint = newPoint;
                                                        }
                                                        
                                                        lastPoint.stateDuration = -[values.mostRecentDate timeIntervalSinceDate:[NSDate date]];
                                                        
                                                    } failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
    
                                                    }];
}

@end
