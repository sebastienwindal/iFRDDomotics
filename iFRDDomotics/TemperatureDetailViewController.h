//
//  TemperatureDetailViewController.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/12/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sensor.h"
#import "Temperature.h"

@interface TemperatureDetailViewController : UIViewController

@property (nonatomic, strong) Sensor *sensor;
@property (nonatomic, strong) Temperature *temperature;

@end
