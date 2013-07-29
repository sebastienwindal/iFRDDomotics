//
//  DayChart.h
//  iFRDDomotics
//
//  Created by Sebastien Windal on 7/28/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayChart : UIView

-(void) highLightStateBetweenHour:(float)startHour andHour:(float)endHour;
-(void) clear;

@end
