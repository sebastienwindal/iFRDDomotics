//
//  TemperatureDetailViewController.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/12/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "TemperatureDetailViewController.h"
#import "UILabel+NUI.h"
#import "FRDDomoticsClient.h"
#import "TTTTimeIntervalFormatter.h"


@interface TemperatureDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionValueLabel;


@end

@implementation TemperatureDetailViewController

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
    
    self.locationLabel.nuiClass = @"sensorLegendLabel";
    self.lastUpdateLabel.nuiClass = @"sensorLegendLabel";
    self.descriptionLabel.nuiClass = @"sensorLegendLabel";

    self.unitLabel.nuiClass = @"unitSubtitleLabel";
    self.temperatureLabel.nuiClass = @"sensorValueLabel";
    
    [self updateUIFromSensor];
    
    [self fetchLastTemperature];
}

-(void) fetchLastTemperature
{
    [[FRDDomoticsClient sharedClient] getLastTemperatureForSensor:self.sensor.sensorID
                                                          success:^(FRDDomoticsClient *domoClient, Temperature *temperature) {
                                                              self.temperature = temperature;
                                                              [self updateUIFromTemperature];
                                                          }
                                                          failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
    
                                                          }];
}


-(void) updateUIFromSensor
{
    self.locationValueLabel.text = self.sensor.location;
    self.descriptionValueLabel.text = self.sensor.sensorDescription;
}


-(void) updateUIFromTemperature
{
    if ([self.temperature.values count] == 0) {
        self.temperatureLabel.text = @"-";
    } else {
        self.temperatureLabel.text = [NSString stringWithFormat:@"%1.1f", [self.temperature.values[0] floatValue]];
        TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        timeIntervalFormatter.futureDeicticExpression = @"ago";
        NSString *timeString = [timeIntervalFormatter stringForTimeIntervalFromDate:self.temperature.mostRecentDate
                                                                             toDate:[NSDate date]];
        self.lastUpdatedValueLabel.text = timeString;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
