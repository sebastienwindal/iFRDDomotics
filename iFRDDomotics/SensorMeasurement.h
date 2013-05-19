//
//  Temperature.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/12/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"


@interface SensorMeasurement : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray *dateOffsets;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSString *measurementType;
@property (nonatomic, strong) NSDate *mostRecentDate;
@property (nonatomic, strong) NSDate *oldestDate;
@property (nonatomic) int sensorID;
@property (nonatomic, strong) NSString *location;
@end

