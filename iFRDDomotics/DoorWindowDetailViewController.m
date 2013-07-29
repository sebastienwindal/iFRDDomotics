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
#import "DayCollectionViewCell.h"

@interface DoorWindowDetailViewController () 

@property (weak, nonatomic) IBOutlet UITableView *openEventTableView;

@property (nonatomic, strong) NSMutableArray *openTimesAndDuration; // array of OpenClosePoint objects.
@property (nonatomic, strong) NSMutableDictionary *dayAggregates;

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

-(NSMutableArray *) openTimesAndDuration
{
    if (_openTimesAndDuration == nil) {
        _openTimesAndDuration = [[NSMutableArray alloc] init];
    }
    return _openTimesAndDuration;
}

-(NSMutableDictionary *) dayAggregates
{
    if (!_dayAggregates) {
        _dayAggregates = [[NSMutableDictionary alloc] init];
    }
    return _dayAggregates;
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
    
    
    [[FRDDomoticsClient sharedClient] getRawValuesForSensor:self.sensorID
                                            measurementtype:kSensorCapabilities_LEVEL
                                                  startDate:sevenDaysAgo
                                                    endDate:now
                                                    success:^(FRDDomoticsClient *domoClient, SensorMeasurement *values) {
                                                        
                                                        if (![values.values count])
                                                            return;
                                                        
                                                        OpenClosePoint *point = [OpenClosePoint openClosePointForState:([values.values[0] intValue]==1) relativeDate:0];
                                                        point.date = values.oldestDate;
                                                        
                                                        [self.openTimesAndDuration addObject:point];
                                                        
                                                        OpenClosePoint *lastPoint = point;
                                                        
                                                        for (int i=1; i<values.values.count; i++) {
                                                            BOOL isOpen = [values.values[i] intValue] == 1;
                                                            if (lastPoint.isOpen == isOpen)
                                                                continue;
                                                            
                                                            // ok this is not a dupe point, record it.
                                                            OpenClosePoint *newPoint = [OpenClosePoint openClosePointForState:isOpen relativeDate:(double)[values.dateOffsets[i] floatValue]];
                                                            newPoint.date = [values.oldestDate dateByAddingTimeInterval:newPoint.relativeDate];
                                                            lastPoint.stateDuration = newPoint.relativeDate - lastPoint.relativeDate;
                                                            [self.openTimesAndDuration addObject:newPoint];
                                                            
                                                            lastPoint = newPoint;
                                                        }
                                                        
                                                        lastPoint.stateDuration = -[values.mostRecentDate timeIntervalSinceDate:[NSDate date]];
                                                        
                                                        [self aggregateByDay];
                                                        
                                                        [self.openEventTableView reloadData];
                                                        [self.collectionView reloadData];
                                                        
                                                    } failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
    
                                                    }];
}

-(void) aggregateByDay
{
    for (OpenClosePoint *point in self.openTimesAndDuration) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSIntegerMax fromDate:point.date];
        components.hour = 0;
        components.minute = 0;
        components.second = 0;

        NSDate *midnight = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        NSMutableArray *arr = self.dayAggregates[[midnight description]];
        if (!arr) {
            arr = [[NSMutableArray alloc] init];
        }
        [arr addObject:point];
        self.dayAggregates[[midnight description]] = arr;
    }
}

#pragma mark - UICollectionViewDataSource implementation

-(int) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dayAggregates count];
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DayCollectionViewCell *cell = (DayCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"OpenStateDayCell" forIndexPath:indexPath];
    
    //OpenClosePoint *point = self.openTimesAndDuration[indexPath.row];
    
    cell.dayLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    NSArray *arr = [self.dayAggregates allKeys];
    
    NSMutableArray * dayEvents = self.dayAggregates[arr[indexPath.row]];
    [cell.dayChart clear];
    for (OpenClosePoint *point in dayEvents) {
    
        if (point.isOpen){
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSIntegerMax fromDate:point.date];
    
            float hour1 = components.hour + components.minute / 60.0f + components.second / 3600.0f;
            float hour2 = hour1 + point.stateDuration / 3600.0f;
        
            [cell.dayChart highLightStateBetweenHour:hour1 andHour:hour2];
        }
    }
    return cell;
}


@end

