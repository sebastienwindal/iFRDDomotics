//
//  UnitConverter.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/15/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitConverter : NSObject

+(NSString *) temperatureUnitName;
+(NSString *) temperatureUnitLetter;
+(float) toLocaleTemperature:(float) celciusTemperature;

+(NSString *) temperatureStringFromValue:(float) celciusTemperature;
+(NSString *) luminosityStringFromValue:(float) luxLuminosity;
+(NSString *) humidityStringFromValue:(float) percentHumidity;

@end
