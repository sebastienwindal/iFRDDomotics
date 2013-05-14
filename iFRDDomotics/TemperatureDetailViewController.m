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
#import "UILabel+FadeInTextTransition.h"
#import "NSString+FontAwesome.h"

@interface TemperatureDetailViewController ()

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

@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) CABasicAnimation *reloadRotationAnimation;
@property (nonatomic) BOOL isLoading;

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

    self.reloadButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.reloadButton.nuiClass = @"NavIconButton";
    
    self.reloadButton.frame = CGRectMake(0,0,30,20);
    [self.reloadButton setTitle:[NSString awesomeIcon:AwesomeIconRefresh] forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(fetchLastTemperature) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.reloadButton];
    
    self.locationLabel.nuiClass = @"sensorLegendLabel";
    self.lastUpdateLabel.nuiClass = @"sensorLegendLabel";
    self.descriptionLabel.nuiClass = @"sensorLegendLabel";

    self.unitLabel.nuiClass = @"unitSubtitleLabel";
    self.temperatureLabel.nuiClass = @"sensorValueLabel";

    self.anHourAgoLabel.text = @"";
    self.aDayAgoLabel.text = @"";
    
    [self updateUIFromSensor];
    
    [self fetchLastTemperature];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.temperatureLabel enableFadeInTransitionWithDuration:1.0];
    [self.lastUpdatedValueLabel enableFadeInTransitionWithDuration:1.0];
}

-(void) fetchLastTemperature
{
    if (self.isLoading) return;
    
    self.isLoading = YES;
    
    [[FRDDomoticsClient sharedClient] getLastTemperatureForSensor:self.sensor.sensorID
                                                          success:^(FRDDomoticsClient *domoClient, Temperature *temperature) {
                                                              self.temperature = temperature;
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  self.isLoading = NO;
                                                                  [self updateUIFromTemperature];
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

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    if (-[self.temperature.mostRecentDate timeIntervalSinceNow] > 240) {
        // if the data we are showing is older than 4 minutes old, trigger automatically a rest call.
        [self fetchLastTemperature];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

@end
