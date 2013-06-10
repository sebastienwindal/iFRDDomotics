//
//  LeftMenuViewController.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/11/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingsAction:(id)sender {
    [self.delegate leftMenuViewController:self didSelectMenuItem:kLeftMenuItem_SETTINGS];
}

- (IBAction)sensorsAction:(id)sender {
    [self.delegate leftMenuViewController:self didSelectMenuItem:kLeftMenuItem_SENSORS];
}


- (IBAction)temperaturesAction:(id)sender {
    [self.delegate leftMenuViewController:self didSelectMenuItem:kLeftMenuItem_TEMPERATURE];
}

- (IBAction)humidityAction:(id)sender {
    [self.delegate leftMenuViewController:self didSelectMenuItem:kLeftMenuItem_HUMIDITY];
}

- (IBAction)aboutAction:(id)sender {
    [self.delegate leftMenuViewController:self didSelectMenuItem:kLeftMenuItem_ABOUT];
}

@end
