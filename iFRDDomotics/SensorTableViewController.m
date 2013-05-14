//
//  SensorTableViewController.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/12/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "SensorTableViewController.h"
#import "FRDDomoticsClient.h"
#import "Sensor.h"
#import "TemperatureDetailViewController.h"
#import "UIButton+NUI.h"
#import "NSString+FontAwesome.h"
#import <QuartzCore/QuartzCore.h>
#import "SensorTableViewCell.h"

@interface SensorTableViewController ()

@property (nonatomic, strong) NSArray *sensors;
@property (nonatomic) BOOL isLoading;

@end


@implementation SensorTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchSensorList:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    
    [self fetchSensorList:self];
}


-(void) setIsLoading:(BOOL)isLoading
{
    if (isLoading == _isLoading) return;

    _isLoading = isLoading;
    
    if (isLoading) {
        [self.refreshControl beginRefreshing];
    } else {
        [self.refreshControl endRefreshing];
    }
}

-(void) fetchSensorList:(id)sender
{
    if (self.isLoading) return;
    
    self.isLoading = YES;
    
    self.sensors = [[NSArray alloc] init];
    [self.tableView reloadData];
    
    [[FRDDomoticsClient sharedClient] setUsername:@"seb" andPassword:@"password"];
    [[FRDDomoticsClient sharedClient] getSensors:kSensorCapabilities_ALL
                                         success:^(FRDDomoticsClient *domoClient, NSArray *sensors) {
                                             // perform on ui thread.
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 self.sensors = sensors;
                                                 [self.tableView reloadData];
                                                 self.isLoading = NO;
                                             });
                                         }
                                         failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
                                             dispatch_async(dispatch_get_main_queue(), ^{                                             self.isLoading = NO;
                                             });
                                         }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sensors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TemperatureCell";
    SensorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Sensor *sensor = [self.sensors objectAtIndex:indexPath.row];

    cell.sensorNameLabel.text = sensor.name;
    cell.sensorLocationLabel.text = sensor.location;
    cell.sensorLocationLabel.nuiClass = @"sensorCellLocation";
    cell.sensorNameLabel.nuiClass = @"sensorCellName";
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TemperatureDetailSegue"]) {
        TemperatureDetailViewController *vc = (TemperatureDetailViewController *) segue.destinationViewController;
        vc.sensor = self.sensors[0];
    }
}
@end
