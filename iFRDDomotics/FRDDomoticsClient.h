//
//  FRDDomoticsClient.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/12/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "SensorMeasurement.h"
#import "HourlyMeasurement.h"
#import "Sensor.h"


@interface FRDDomoticsClient : AFHTTPClient

-(void) getSensors:(kSensorCapabilities)capabilities
           success:(void(^)(FRDDomoticsClient *domoClient, NSArray *sensors))onSuccess
           failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure;

-(void) getLastValueForSensor:(int)sensorID
              measurementType:(kSensorCapabilities)measurementType
                      success:(void(^)(FRDDomoticsClient *domoClient, SensorMeasurement *temperature))onSuccess
                      failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure;

-(void) getLastValuesForAllSensors:(kSensorCapabilities) measurementType
                           success:(void(^)(FRDDomoticsClient *domoClient, NSArray *values))onSuccess
                        failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure;

-(void) getRawValuesForSensor:(int) sensorID
              measurementtype:(kSensorCapabilities)measurementType
                    startDate:(NSDate *)startDate
                      endDate:(NSDate *)endDate
                      success:(void(^)(FRDDomoticsClient *domoClient, SensorMeasurement *values))onSuccess
                      failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure;

-(void) getHourlyValuesForSensor:(int) sensorID
              measurementtype:(kSensorCapabilities)measurementType
                    startDate:(NSDate *)startDate
                      endDate:(NSDate *)endDate
                      success:(void(^)(FRDDomoticsClient *domoClient, HourlyMeasurement *values))onSuccess
                      failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure;

-(void) authenticateWithSuccess:(void(^)(FRDDomoticsClient *domoClient))onSuccess
                        failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure;

-(void)setUsername:(NSString *)username andPassword:(NSString *)password;


+ (FRDDomoticsClient *)sharedClient;


@end
