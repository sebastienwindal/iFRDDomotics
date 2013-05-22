//
//  TemperatureDetailViewController.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/12/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "SensorCurrentValueDetailViewController.h"
#import "UILabel+NUI.h"
#import "FRDDomoticsClient.h"
#import "TTTTimeIntervalFormatter.h"
#import "UILabel+FadeInTextTransition.h"
#import "UnitConverter.h"
#import "FontIcon.h"

@interface SensorCurrentValueDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *anHourAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *aDayAgoLabel;
@property (weak, nonatomic) IBOutlet UIButton *chartButton;

@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) CABasicAnimation *reloadRotationAnimation;
@property (nonatomic) BOOL isLoading;

@end

@implementation SensorCurrentValueDetailViewController

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
    
    if (self.sensor.capabilities & kSensorCapabilities_TEMPERATURE) {
        self.navigationItem.title = @"Temperature";
        self.unitLabel.text = [UnitConverter temperatureUnitName];
    }
    else if (self.sensor.capabilities & kSensorCapabilities_HUMIDITY) {
        self.navigationItem.title = @"Humidity";
        self.unitLabel.text = @"%";
    }
    else if (self.sensor.capabilities & kSensorCapabilities_LUMMINOSITY) {
        self.navigationItem.title = @"Luminosity";
        self.unitLabel.text = @"lux";
    }

    self.reloadButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.reloadButton.nuiClass = @"IconButton:NavIconButton";
    
    self.reloadButton.frame = CGRectMake(0,0,30,20);
    [self.reloadButton setTitle:[FontIcon iconString:ICON_RELOAD_4] forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(fetchLastValue) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.reloadButton];
    
    self.locationLabel.nuiClass = @"sensorLegendLabel";
    self.lastUpdateLabel.nuiClass = @"sensorLegendLabel";
    self.descriptionLabel.nuiClass = @"sensorLegendLabel";

    self.unitLabel.nuiClass = @"unitSubtitleLabel";
    self.temperatureLabel.nuiClass = @"sensorValueLabel";

    self.anHourAgoLabel.text = @"";
    self.aDayAgoLabel.text = @"";
    
    NSString *btnText = [NSString stringWithFormat:@"%@ %@", [FontIcon iconString:ICON_LINE_CHART], [FontIcon iconString:ICON_RIGHT_ARROW_2]];
    [self.chartButton setTitle:btnText forState:UIControlStateNormal];
    [self updateUIFromSensor];
    
    [self fetchLastValue];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.temperatureLabel enableFadeInTransitionWithDuration:1.5];
    [self.lastUpdatedValueLabel enableFadeInTransitionWithDuration:1.5];
    [self.aDayAgoLabel enableFadeInTransitionWithDuration:1.5];
    [self.anHourAgoLabel enableFadeInTransitionWithDuration:1.5];
}

-(void) fetchLastValue
{
    if (self.isLoading) return;
    
    self.isLoading = YES;
    
    [[FRDDomoticsClient sharedClient] getLastValueForSensor:self.sensor.sensorID
                                            measurementType:self.sensor.capabilities
                                                    success:^(FRDDomoticsClient *domoClient, SensorMeasurement *temperature) {
                                                        self.temperature = temperature;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.isLoading = NO;
                                                            [self updateUIFromValue];
                                                        });
                                                    }
                                                    failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.isLoading = NO;
                                                        });
                                                    }];
    
}


-(void) setIsLoading:(BOOL)isLoading
{
    if (isLoading == _isLoading) return;
    
    _isLoading = isLoading;
    
    if (isLoading) {
        [self startRotateReloadButton];
    } else {
        [self endRotateReloadButton];
    }
}


-(CABasicAnimation *) reloadRotationAnimation
{
    if (!_reloadRotationAnimation) {
        int repeat = 99999999;
        NSTimeInterval duration = 1.0;
        
        _reloadRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        _reloadRotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * duration ];
        _reloadRotationAnimation.duration = duration;
        _reloadRotationAnimation.cumulative = YES;
        _reloadRotationAnimation.repeatCount = repeat;
    }
    return _reloadRotationAnimation;
}

-(void) startRotateReloadButton
{
    [self.reloadButton.layer addAnimation:self.reloadRotationAnimation forKey:@"rotationAnimation"];
}

-(void) endRotateReloadButton
{
    [self.reloadButton.layer removeAllAnimations];
    self.reloadRotationAnimation = nil;
}



-(void) updateUIFromSensor
{
    self.locationValueLabel.text = self.sensor.location;
    self.descriptionValueLabel.text = self.sensor.sensorDescription;
}


-(void) updateUIFromValue
{
    if ([self.temperature.values count] == 0) {
        self.temperatureLabel.text = @"-";
    } else {
        float curTemp = [self.temperature.values.lastObject floatValue];
        
        float aDayAgoTemp = [UnitConverter toLocaleTemperature:[self.temperature.values[0] floatValue] ];

        float anHourAgoTemp;
        if ([self.temperature.values count] == 3) {
            anHourAgoTemp = [UnitConverter toLocaleTemperature:[self.temperature.values[1] floatValue]];
        } else {
            anHourAgoTemp = [UnitConverter toLocaleTemperature:[self.temperature.values[0] floatValue]];
        }

        if (self.temperature.measurementType == kSensorCapabilities_TEMPERATURE)
            self.temperatureLabel.text = [UnitConverter temperatureStringFromValue:curTemp];
        else if (self.temperature.measurementType == kSensorCapabilities_LUMMINOSITY)
            self.temperatureLabel.text = [UnitConverter luminosityStringFromValue:curTemp];
        else if (self.temperature.measurementType == kSensorCapabilities_HUMIDITY)
            self.temperatureLabel.text = [UnitConverter humidityStringFromValue:curTemp];
        
        TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        timeIntervalFormatter.futureDeicticExpression = @"ago";
        NSString *timeString = [timeIntervalFormatter stringForTimeIntervalFromDate:self.temperature.mostRecentDate
                                                                             toDate:[NSDate date]];
        self.lastUpdatedValueLabel.text = timeString;
        
        {
            float delta = curTemp-anHourAgoTemp;
            if (fabs(delta) < 0.1) {
                self.anHourAgoLabel.text = @"Same as an hour ago";
            } else {
                NSString *str;
                if (delta > 0) {
                    str = [NSString stringWithFormat:@"%.1f %@ warmer that an hour ago", fabs(delta), [UnitConverter temperatureUnitLetter]];
                } else {
                    str = [NSString stringWithFormat:@"%.1f %@ colder that an hour ago", fabs(delta), [UnitConverter temperatureUnitLetter]];
                }
                NSMutableAttributedString *agoString = [[NSMutableAttributedString alloc] initWithString:str];
                UIColor *color = (delta < 0) ? [UIColor blueColor] : [UIColor redColor];
                [agoString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,5)];
                self.anHourAgoLabel.attributedText = agoString;
            }
        }
        {
            float delta = curTemp-aDayAgoTemp;
            if (fabs(delta) < 0.1) {
                self.aDayAgoLabel.text = @"Same as 24 hours ago";
            } else {
                NSString *str;
                if (delta > 0) {
                    str = [NSString stringWithFormat:@"%.1f %@ warmer that 24 hours ago", fabs(delta), [UnitConverter temperatureUnitLetter]];
                } else {
                    str = [NSString stringWithFormat:@"%.1f %@ colder that 24 hours ago", fabs(delta), [UnitConverter temperatureUnitLetter]];
                }
                NSMutableAttributedString *agoString = [[NSMutableAttributedString alloc] initWithString:str];
                UIColor *color = (delta < 0) ? [UIColor blueColor] : [UIColor redColor];
                [agoString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,5)];
                self.aDayAgoLabel.attributedText = agoString;
            }
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    if (-[self.temperature.mostRecentDate timeIntervalSinceNow] > 120) {
        // if the data we are showing is older than 2 minutes old, trigger automatically a rest call.
        [self fetchLastValue];
    }
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setSensor:self.sensor];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

@end
