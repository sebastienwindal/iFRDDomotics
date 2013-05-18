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

@property (nonatomic) NSArray *dateOffsets;
@property (nonatomic) NSArray *values;
@property (nonatomic) NSString *measurementType;
@property (nonatomic) NSDate *mostRecentDate;
@property (nonatomic) NSDate *oldestDate;
@property (nonatomic) int sensorID;

@end

