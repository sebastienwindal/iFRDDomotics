//
//  UnitConverter.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/15/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "UnitConverter.h"
#import "PersistentStorage.h"


@implementation UnitConverter

+(NSString *) temperatureUnitName
{
    return [[PersistentStorage sharedInstance] celcius] ? @"celcius" : @"fahrenheit";
}

+(NSString *) temperatureUnitLetter
{
    return [[PersistentStorage sharedInstance] celcius] ? @"C" : @"F";
}


+(float) toLocaleTemperature:(float) celciusTemperature
{
    if ([[PersistentStorage sharedInstance] celcius]) return celciusTemperature;
    
    return 32.0f + 9.0f * celciusTemperature / 5.0f;
}

+(NSString *) temperatureStringFromValue:(float) celciusTemperature
{
    float localTemp = [UnitConverter toLocaleTemperature:celciusTemperature];
    if ([[PersistentStorage sharedInstance] celcius]) {
        return [NSString stringWithFormat:@"%1.1f", localTemp];
    } else {
        return [NSString stringWithFormat:@"%1.0f", roundf(localTemp)];
    }
}

+(NSString *) luminosityStringFromValue:(float) luxLuminosity
{
    return [NSString stringWithFormat:@"%1.0f", roundf(luxLuminosity)];
}

+(NSString *) humidityStringFromValue:(float) percentHumidity
{
    return [NSString stringWithFormat:@"%1.0f", roundf(percentHumidity)];
}


@end
