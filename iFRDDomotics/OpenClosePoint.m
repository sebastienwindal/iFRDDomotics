//
//  OpenClosePoint.m
//  iFRDDomotics
//
//  Created by Sebastien on 7/4/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "OpenClosePoint.h"

@implementation OpenClosePoint

+(OpenClosePoint *) openClosePointForState:(BOOL)state relativeDate:(NSTimeInterval)relativeDate;
{
    OpenClosePoint *point = [[OpenClosePoint alloc] init];
    point.isOpen = state;
    point.relativeDate = relativeDate;
    point.stateDuration = 0;
    
    return point;
}

-(NSString *) debugDescription
{
    return [NSString stringWithFormat:@"%@ - %@ - %f sec - date %@",
            [super debugDescription],
            self.isOpen ? @"open" : @"closed",
            self.stateDuration,
            self.date];
}
@end
