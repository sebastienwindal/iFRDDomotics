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

@interface TemperatureCollectionViewController ()

@property (nonatomic, strong) NSArray *values; // array of SensorMeasurement objects

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
	// Do any additional setup after loading the view.
    
    [[FRDDomoticsClient sharedClient] getLastValuesForAllSensors:kSensorCapabilities_TEMPERATURE
                                                         success:^(FRDDomoticsClient *domoClient, NSArray *values) {
                                                             self.values = values;
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [self.collectionView reloadData];
                                                             });
                                                         }
                                                         failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
                                                             
                                                         }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
