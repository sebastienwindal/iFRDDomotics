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


@interface SensorTableViewController ()

@property (nonatomic, strong) NSArray *sensors;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) CABasicAnimation *reloadRotationAnimation;
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
    
    self.reloadButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.reloadButton.nuiClass = @"NavIconButton";
    
    self.reloadButton.frame = CGRectMake(0,0,30,20);
    [self.reloadButton setTitle:[NSString awesomeIcon:AwesomeIconRefresh] forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(fetchSensorList:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.reloadButton];

    [self fetchSensorList:self];
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

-(void) setIsLoading:(BOOL)isLoading
{
    if (isLoading == _isLoading) return;

    _isLoading = isLoading;
    
    if (isLoading) {
        [self.refreshControl beginRefreshing];
        [self startRotateReloadButton];
    } else {
        [self.refreshControl endRefreshing];
        [self endRotateReloadButton];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Sensor *sensor = [self.sensors objectAtIndex:indexPath.row];

    cell.textLabel.text = sensor.name;
    cell.detailTextLabel.text = sensor.location;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TemperatureDetailSegue"]) {
        TemperatureDetailViewController *vc = (TemperatureDetailViewController *) segue.destinationViewController;
        vc.sensor = self.sensors[0];
    }
}
@end
