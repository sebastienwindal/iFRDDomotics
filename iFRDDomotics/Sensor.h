//
//  Sensor.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/11/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"


@interface Sensor : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *sensorDescription;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *name;
@property (nonatomic) int sensorID;
@property (nonatomic) NSArray * capabilities;


@end
