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
#import "Sensor.h"


@interface FRDDomoticsClient : AFHTTPClient

-(void) getSensors:(kSensorCapabilities)capabilities
           success:(void(^)(FRDDomoticsClient *domoClient, NSArray *sensors))onSuccess
           failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure;

-(void) getLastValueForSensor:(int)sensorID
              measurementType:(kSensorCapabilities)measurementType
                      success:(void(^)(FRDDomoticsClient *domoClient, SensorMeasurement *temperature))onSuccess
                      failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure;

- (void)setUsername:(NSString *)username andPassword:(NSString *)password;

+ (FRDDomoticsClient *)sharedClient;


@end
