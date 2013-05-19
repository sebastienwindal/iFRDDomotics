//
//  Temperature.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/12/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "SensorMeasurement.h"
#import "MTLValueTransformer.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"


@implementation SensorMeasurement


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"measurementType": @"measurement_type",
             @"sensorID": @"sensor_id",
             @"mostRecentDate": @"most_recent_measurement_date",
             @"oldestDate": @"oldest_measurement_date",
             @"dateOffsets": @"date_offset"
             };
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    return dateFormatter;
}

+(NSValueTransformer *)measurementTypeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        kSensorCapabilities capa = 0;
        if ([str isEqualToString:@"temperature"])
            capa = kSensorCapabilities_TEMPERATURE;
        else if ([str isEqualToString:@"humidity"])
            capa = kSensorCapabilities_HUMIDITY;
        else if ([str isEqualToString:@"luminosity"])
            capa = kSensorCapabilities_LUMMINOSITY;
        return @(capa);
        
    } reverseBlock:^(NSNumber *capaNumber) {
        kSensorCapabilities capa = [capaNumber intValue];
        if (capa == kSensorCapabilities_LUMMINOSITY)
            return @"luminosity";
        else if (capa == kSensorCapabilities_HUMIDITY)
            return @"humidity";
        else if (capa == kSensorCapabilities_TEMPERATURE)
            return @"temperature";
        return @"";
        
    }];
}


+ (NSValueTransformer *)mostRecentDateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        NSDate *date = [self.dateFormatter dateFromString:str];
        return date;
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)oldestDateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        NSDate *date = [self.dateFormatter dateFromString:str];
        return date;
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)sensorJSONTransformer {
    return [NSValueTransformer
            mtl_JSONDictionaryTransformerWithModelClass:Sensor.class];
}


@end
