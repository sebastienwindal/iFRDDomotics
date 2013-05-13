//
//  Temperature.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/12/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "Temperature.h"
#import "MTLValueTransformer.h"

@implementation Temperature


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


@end
