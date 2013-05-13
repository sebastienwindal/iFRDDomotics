//
//  FRDDomoticsClient.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/12/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "FRDDomoticsClient.h"
#import "AFJSONRequestOperation.h"
#import "Sensor.h"
#import "MTLJSONAdapter.h"


NSString *kFRDDomoticsAPIBaseURLString = @"https://98.192.11.52:8000/api";

@implementation FRDDomoticsClient


- (id)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    return self;
}

- (void)setUsername:(NSString *)username andPassword:(NSString *)password
{
    [self clearAuthorizationHeader];
    [self setAuthorizationHeaderWithUsername:username password:password];
}


-(void) getSensors:(kSensorCapabilities)capabilities
           success:(void(^)(FRDDomoticsClient *domoClient, NSArray *sensors))onSuccess
           failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure
{ 
    [self getPath:@"sensors"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (![responseObject isKindOfClass:[NSArray class]]) {
                  if (onFailure)
                      onFailure(self, @"Failed to get sensors. Unexpected response.");
                  return;
              }
              
              NSArray *sensorArray = [[NSArray alloc] init];
              
              for (id sensorObject in responseObject) {
                  if ([sensorObject isKindOfClass:[NSDictionary class]]) {
                      NSError *error;
                      MTLJSONAdapter *jsonAdapter = [[MTLJSONAdapter alloc] initWithJSONDictionary:sensorObject modelClass:[Sensor class] error:&error];
                      if (error) {
                          NSLog(@"Failed to parse a sensor. Error: %@", [error localizedDescription]);
                          // skip that one...
                          continue;
                      }
                      
                      sensorArray = [sensorArray arrayByAddingObject:jsonAdapter.model];
                  }
              }
              onSuccess(self, sensorArray);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (onFailure) {
                  onFailure(self, @"Failed to get sensor");
              }
          }];
}

-(void) getLastTemperatureForSensor:(int)sensorID
                            success:(void(^)(FRDDomoticsClient *domoClient, Temperature *temperature))onSuccess
                            failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure;
{
    [self getPath:[NSString stringWithFormat:@"temperature/raw/%d?numberPoints=1", sensorID]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (![responseObject isKindOfClass:[NSDictionary class]]) {
                  if (onFailure)
                      onFailure(self, @"Failed to get temperature. Unexpected response.");
                  return;
              }
              
              NSError *error;
              MTLJSONAdapter *jsonAdapter = [[MTLJSONAdapter alloc] initWithJSONDictionary:responseObject modelClass:[Temperature class] error:&error];
              if (error) {
                  NSLog(@"Failed to parse temperature value. Error: %@", [error localizedDescription]);
                  onFailure(self, [error localizedDescription]);
              }
              onSuccess(self, (Temperature *)jsonAdapter.model);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (onFailure) {
                  onFailure(self, @"Failed to get sensor");
              }
          }];
}


+ (FRDDomoticsClient *)sharedClient {
    static FRDDomoticsClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[FRDDomoticsClient alloc] initWithBaseURL:[NSURL URLWithString:kFRDDomoticsAPIBaseURLString]];
    });
    
    return _sharedClient;
}



@end
