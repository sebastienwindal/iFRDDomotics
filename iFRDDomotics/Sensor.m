//
//  Sensor.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/11/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "Sensor.h"

@implementation Sensor



+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"sensorDescription": @"description",
             @"sensorID": @"sensor_id"
             };
}

@end
