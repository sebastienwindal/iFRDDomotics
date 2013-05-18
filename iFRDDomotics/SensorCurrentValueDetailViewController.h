//
//  TemperatureDetailViewController.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/12/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sensor.h"
#import "SensorMeasurement.h"

@interface SensorCurrentValueDetailViewController : UIViewController

@property (nonatomic, strong) Sensor *sensor;
@property (nonatomic, strong) SensorMeasurement *temperature;

@end
