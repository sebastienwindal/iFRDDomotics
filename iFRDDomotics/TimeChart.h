//
//  TimeChart.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/19/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeChart;

@protocol TimeChartDatasource <NSObject>

@required

-(NSArray *) timeChartTimeValues:(TimeChart *)chart;
-(int) timeChartNumberLines:(TimeChart *)chart;
-(NSArray *) timeChart:(TimeChart *)chart valuesForLine:(int)lineIndex;
-(float) convertValueToLocalUnit:(float)value;
-(NSDate *) timeChartOldestDate:(TimeChart *) chart;
@end

@interface TimeChart : UIView

@property (nonatomic, weak) id<TimeChartDatasource> datasource;

-(void) updateChart;

@end
