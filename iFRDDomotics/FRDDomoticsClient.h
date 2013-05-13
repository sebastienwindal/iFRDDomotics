//
//  FRDDomoticsClient.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/12/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "Temperature.h"

@interface FRDDomoticsClient : AFHTTPClient

typedef enum {
    kSensorCapabilities_TEMPERATURE     = 0x00000001,
    kSensorCapabilities_HUMIDITY        = 0x00000002,
    kSensorCapabilities_LUMMINOSITY     = 0x00000004,
    kSensorCapabilities_ALL             = 0xFFFFFFFF
} kSensorCapabilities;

-(void) getSensors:(kSensorCapabilities)capabilities
           success:(void(^)(FRDDomoticsClient *domoClient, NSArray *sensors))onSuccess
           failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure;

-(void) getLastTemperatureForSensor:(int) sensorID
                            success:(void(^)(FRDDomoticsClient *domoClient, Temperature *temperature))onSuccess
                            failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure;

- (void)setUsername:(NSString *)username andPassword:(NSString *)password;

+ (FRDDomoticsClient *)sharedClient;


@end
