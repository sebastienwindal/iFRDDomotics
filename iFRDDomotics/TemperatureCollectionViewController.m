//
//  TemperatureCollectionViewController.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/18/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "TemperatureCollectionViewController.h"
#import "TemperatureCollectionViewCell.h"
#import "SensorCurrentValueDetailViewController.h"
#import "SensorMeasurement.h"
#import "FRDDomoticsClient.h"
#import "UnitConverter.h"
#import "UIButton+NUI.h"
#import "FontIcon.h"


@interface TemperatureCollectionViewController ()

@property (nonatomic, strong) NSArray *values; // array of SensorMeasurement objects

@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) CABasicAnimation *reloadRotationAnimation;
@property (nonatomic) BOOL isLoading;

@end

@implementation TemperatureCollectionViewController

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
    [self.reloadButton setTitle:[FontIcon iconString:ICON_RELOAD_4] forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(fetchValues) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.reloadButton];
    
    [self fetchValues];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) applicationDidBecomeActive:(UIApplication *)application
{
    BOOL updateRequired = self.values.count == 0; // force an update no matter what if we don't have any values yet...
    
    for (SensorMeasurement *measurement in self.values) {
        
        if (-[measurement.mostRecentDate timeIntervalSinceNow] > 120) {
            // if the data we are showing is older than 2 minutes old, trigger automatically a rest call.
            updateRequired = YES;
            break;
        }
    }
    
    if (updateRequired)
        [self fetchValues]; // (re) fetch values.

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


-(void) fetchValues
{
    if (self.isLoading) return;
    
    self.isLoading = YES;
    self.values = nil;
    [self.collectionView reloadData];
    
    [[FRDDomoticsClient sharedClient] getLastValuesForAllSensors:kSensorCapabilities_TEMPERATURE
                                                         success:^(FRDDomoticsClient *domoClient, NSArray *values) {
                                                             self.values = values;
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [self.collectionView reloadData];
                                                                 self.isLoading = NO;
                                                             });
                                                         }
                                                         failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self.isLoading = NO;
                                                             });
                                                         }];

}

-(int) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.values count];
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TemperatureCollectionViewCell *cell = [self.collectionView
                                                dequeueReusableCellWithReuseIdentifier:@"TemperatureCollectionViewCell"
                                                                          forIndexPath:indexPath];
    
    SensorMeasurement *measurement = self.values[indexPath.row];
    
    cell.temperatureLabel.text = [NSString  stringWithFormat:@"%1.1f", [[measurement.values lastObject] floatValue]];
    cell.unitLabel.text = [UnitConverter temperatureUnitName];
    cell.locationLabel.text = measurement.sensor.location;
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TemperatureCollectionToDetails"]) {
        SensorCurrentValueDetailViewController *vc = (SensorCurrentValueDetailViewController *) segue.destinationViewController;
        
        NSIndexPath* pathOfTheCell = [self.collectionView indexPathForCell:sender];
        NSInteger rowOfTheCell = [pathOfTheCell row];
        
        vc.temperature = self.values[rowOfTheCell];
        vc.sensor = vc.temperature.sensor;
        // the destination view controller only cares that we support a sepcific measrement type.
        vc.sensor.capabilities = vc.temperature.measurementType;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

@end
