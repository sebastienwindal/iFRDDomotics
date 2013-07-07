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

-(void) getLastValueForSensor:(int)sensorID
              measurementType:(kSensorCapabilities)measurementType
                      success:(void(^)(FRDDomoticsClient *domoClient, SensorMeasurement *temperature))onSuccess
                      failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure
{
    
    NSString *url;
    if (measurementType == kSensorCapabilities_TEMPERATURE)
        url = [NSString stringWithFormat:@"temperature/last/%d", sensorID];
    else if (measurementType == kSensorCapabilities_HUMIDITY)
        url = [NSString stringWithFormat:@"humidity/last/%d", sensorID];
    else if (measurementType == kSensorCapabilities_LUMMINOSITY)
        url = [NSString stringWithFormat:@"luminosity/last/%d", sensorID];
    
    [self getPath:url
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (![responseObject isKindOfClass:[NSDictionary class]]) {
                  if (onFailure)
                      onFailure(self, @"Failed to get measurement value. Unexpected response.");
                  return;
              }
              
              NSError *error;
              MTLJSONAdapter *jsonAdapter = [[MTLJSONAdapter alloc] initWithJSONDictionary:responseObject modelClass:[SensorMeasurement class] error:&error];
              if (error) {
                  NSLog(@"Failed to parse measurement value. Error: %@", [error localizedDescription]);
                  onFailure(self, [error localizedDescription]);
              }
              onSuccess(self, (SensorMeasurement *)jsonAdapter.model);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (onFailure) {
                  onFailure(self, @"Failed to get measurement sensor");
              }
          }];
}

-(void) getLastValuesForAllSensors:(kSensorCapabilities) measurementType
                           success:(void(^)(FRDDomoticsClient *domoClient, NSArray *values))onSuccess
                           failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure
{
    NSString *url;
    if (measurementType == kSensorCapabilities_TEMPERATURE)
        url = @"temperature/last";
    else if (measurementType == kSensorCapabilities_HUMIDITY)
        url = @"humidity/last";
    else if (measurementType == kSensorCapabilities_LUMMINOSITY)
        url = @"luminosity/last";
    else if (measurementType == kSensorCapabilities_LEVEL)
        url = @"level/last";
    
    [self getPath:url
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (![responseObject isKindOfClass:[NSArray class]]) {
                  if (onFailure)
                      onFailure(self, @"Failed to get measurement values. Unexpected response.");
                  return;
              }
              
              NSMutableArray *values = [[NSMutableArray alloc] init];
              
              for (NSDictionary *dict in responseObject) {
                  NSError *error;
                  MTLJSONAdapter *jsonAdapter = [[MTLJSONAdapter alloc] initWithJSONDictionary:dict modelClass:[SensorMeasurement class] error:&error];
                  if (error) {
                      NSLog(@"Failed to parse measurement value. Error: %@", [error localizedDescription]);
                      onFailure(self, [error localizedDescription]);
                  }
                  [values addObject:(SensorMeasurement *)jsonAdapter.model];
              }
              
              onSuccess(self, values);

          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (onFailure) {
                  onFailure(self, @"Failed to get measurement sensor");
              }
          }
     ];
}



-(void) getRawValuesForSensor:(int) sensorID
              measurementtype:(kSensorCapabilities)measurementType
                    startDate:(NSDate *)startDate
                      endDate:(NSDate *)endDate
                      success:(void(^)(FRDDomoticsClient *domoClient, SensorMeasurement *values))onSuccess
                      failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss";
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:formatString];
    
    NSString *urlRoot;
    
    if (measurementType == kSensorCapabilities_TEMPERATURE)
        urlRoot = @"temperature";
    else if (measurementType == kSensorCapabilities_LUMMINOSITY)
        urlRoot = @"luminosity";
    else if (measurementType == kSensorCapabilities_HUMIDITY)
        urlRoot = @"humidity";
    else if (measurementType == kSensorCapabilities_LEVEL)
        urlRoot = @"level";
    
    NSString *url = [NSString stringWithFormat:@"%@/raw/%d?startDate=%@&endDate=%@",
                        urlRoot,
                        sensorID,
                        [dateFormatter stringFromDate:startDate],
                        [dateFormatter stringFromDate:endDate ]];
    
    [self getPath:url
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (![responseObject isKindOfClass:[NSDictionary class]]) {
                  if (onFailure)
                      onFailure(self, @"Failed to get temperature. Unexpected response.");
                  return;
              }
              
              NSError *error;
              MTLJSONAdapter *jsonAdapter = [[MTLJSONAdapter alloc] initWithJSONDictionary:responseObject modelClass:[SensorMeasurement class] error:&error];
              if (error) {
                  NSLog(@"Failed to parse temperature value. Error: %@", [error localizedDescription]);
                  onFailure(self, [error localizedDescription]);
              }
              onSuccess(self, (SensorMeasurement *)jsonAdapter.model);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (onFailure) {
                  onFailure(self, @"Failed to get sensor");
              }
          }];

}


-(void) getHourlyValuesForSensor:(int) sensorID
                 measurementtype:(kSensorCapabilities)measurementType
                       startDate:(NSDate *)startDate
                         endDate:(NSDate *)endDate
                         success:(void(^)(FRDDomoticsClient *domoClient, HourlyMeasurement *values))onSuccess
                         failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss";
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:formatString];
    
    NSString *urlRoot;
    
    if (measurementType == kSensorCapabilities_TEMPERATURE)
        urlRoot = @"temperature";
    else if (measurementType == kSensorCapabilities_LUMMINOSITY)
        urlRoot = @"luminosity";
    else
        urlRoot = @"humidity";
    
    NSString *url = [NSString stringWithFormat:@"%@/hourly/%d?startDate=%@&endDate=%@",
                     urlRoot,
                     sensorID,
                     [dateFormatter stringFromDate:startDate],
                     [dateFormatter stringFromDate:endDate ]];
    
    [self getPath:url
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (![responseObject isKindOfClass:[NSDictionary class]]) {
                  if (onFailure)
                      onFailure(self, @"Failed to get temperature. Unexpected response.");
                  return;
              }
              
              NSError *error;
              MTLJSONAdapter *jsonAdapter = [[MTLJSONAdapter alloc] initWithJSONDictionary:responseObject modelClass:[HourlyMeasurement class] error:&error];
              if (error) {
                  NSLog(@"Failed to parse temperature value. Error: %@", [error localizedDescription]);
                  onFailure(self, [error localizedDescription]);
              }
              onSuccess(self, (HourlyMeasurement *)jsonAdapter.model);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (onFailure) {
                  onFailure(self, @"Failed to get sensor");
              }
          }];
}

-(void) authenticateWithSuccess:(void(^)(FRDDomoticsClient *domoClient))onSuccess
                        failure:(void(^)(FRDDomoticsClient *domoClient, NSString *errorMessage))onFailure
{
    
    [self getPath:@"about"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              onSuccess(self);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              onFailure(self, [error localizedDescription]);
          }
     ];
}


+ (FRDDomoticsClient *)sharedClient {
    static FRDDomoticsClient *_sharedClient = nil;
    _sharedClient.allowsInvalidSSLCertificate = YES;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[FRDDomoticsClient alloc] initWithBaseURL:[NSURL URLWithString:kFRDDomoticsAPIBaseURLString]];
    });
    
    return _sharedClient;
}


@end
