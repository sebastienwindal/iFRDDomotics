//
//  Sensor.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/11/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"


typedef enum {
    kSensorCapabilities_TEMPERATURE     = 0x00000001,
    kSensorCapabilities_HUMIDITY        = 0x00000002,
    kSensorCapabilities_LUMMINOSITY     = 0x00000004,
    kSensorCapabilities_LEVEL           = 0x00000008,
    kSensorCapabilities_ALL             = 0xFFFFFFFF
} kSensorCapabilities;



@interface Sensor : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *sensorDescription;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *name;
@property (nonatomic) int sensorID;
@property (nonatomic) kSensorCapabilities capabilities;


@end
