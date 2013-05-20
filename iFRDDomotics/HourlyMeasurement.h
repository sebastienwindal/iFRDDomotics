//
//  HourlyMeasurement.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/19/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "Sensor.h"

@interface HourlyMeasurement : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray *hourOffsets;
@property (nonatomic, strong) NSArray *meanValues;
@property (nonatomic, strong) NSArray *maxValues;
@property (nonatomic, strong) NSArray *minValues;
@property (nonatomic) kSensorCapabilities measurementType;
@property (nonatomic, strong) NSDate *mostRecentDate;
@property (nonatomic, strong) NSDate *oldestDate;
@property (nonatomic) int sensorID;

@end
