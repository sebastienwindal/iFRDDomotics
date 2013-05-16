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


@end
