//
//  OpenClosePoint.h
//  iFRDDomotics
//
//  Created by Sebastien on 7/4/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenClosePoint : NSObject

@property (nonatomic) NSTimeInterval relativeDate; // the time since the the oldest point in the sample
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSTimeInterval stateDuration; // how long we were closed or open
@property (nonatomic) BOOL isOpen; // state of the window/door

+(OpenClosePoint *) openClosePointForState:(BOOL)state relativeDate:(NSTimeInterval)relativeDate;

@end
