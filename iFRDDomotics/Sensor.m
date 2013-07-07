//
//  Sensor.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/11/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "Sensor.h"
#import "MTLValueTransformer.h"

@implementation Sensor


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"sensorDescription": @"description",
             @"sensorID": @"sensor_id"
             };
}

+ (NSValueTransformer *)capabilitiesJSONTransformer {
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSArray *arr) {
        kSensorCapabilities capabilities = 0;
        if ([arr containsObject:@"temperature"]) {
            capabilities |= kSensorCapabilities_TEMPERATURE;
        }
        if ([arr containsObject:@"luminosity"]) {
            capabilities |= kSensorCapabilities_LUMMINOSITY;
        }
        if ([arr containsObject:@"humidity"]) {
            capabilities |= kSensorCapabilities_HUMIDITY;
        }
        if ([arr containsObject:@"level"]) {
            capabilities |= kSensorCapabilities_LEVEL;
        }

        return @(capabilities);
    } reverseBlock:^(NSNumber *capabilites) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        kSensorCapabilities capa = [capabilites integerValue];
        if (capa & kSensorCapabilities_TEMPERATURE) {
            [arr addObject:@"temperature"];
        }
        if (capa & kSensorCapabilities_LUMMINOSITY) {
            [arr addObject:@"luminosity"];
        }
        if (capa & kSensorCapabilities_HUMIDITY) {
            [arr addObject:@"humidity"];
        }
        if (capa & kSensorCapabilities_LEVEL) {
            [arr addObject:@"level"];
        }
        return arr;
    }];
}

@end
