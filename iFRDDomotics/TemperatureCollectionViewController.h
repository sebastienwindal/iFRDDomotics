//
//  TemperatureCollectionViewController.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/18/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sensor.h"

@interface TemperatureCollectionViewController : UICollectionViewController

@property (nonatomic) kSensorCapabilities valueType;

@end
