//
//  FontIcon.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/15/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ICON_RELOAD_1   "\ue000"
#define ICON_RELOAD_2   "\ue001"
#define ICON_RELOAD_3   "\ue002"
#define ICON_RELOAD_4   "\ue003"
#define ICON_RELOAD_5   "\uf021"
#define ICON_RELOAD_6   "\uf01e"
#define ICON_LINE_CHART "\ue004"
#define ICON_RIGHT_ARROW_1 "\ue005"
#define ICON_RIGHT_ARROW_2 "\uf0a9"
#define ICON_LEFT_ARROW_1 "\uf0a8"
#define ICON_LEFT_ARROW_2 "\ue006"
#define ICON_SUN_1 "\ue007"
#define ICON_SUN_2 "\ue008"
#define ICON_SUN_3 "\ue009"
#define ICON_SUN_4 "\ue00a"
#define ICON_SUN_5 "\ue00b"
#define ICON_SUN_6 "\ue00c"
#define ICON_WATER_1 "\ue00d"
#define ICON_WATER_2 "\ue00e"
#define ICON_WATER_3 "\ue00f"
#define ICON_WATER_4 "\uf043"
#define ICON_TEMPERATURE_1 "\ue010"
#define ICON_TEMPERATURE_2 "\ue013"
#define ICON_CELCIUS "\ue011"
#define ICON_FAHRENHEIT "\ue012"
#define ICON_SUN_7 "\ue014"
#define ICON_SUN_8 "\ue015"
#define ICON_CLOCK_1 "\ue016"
#define ICON_CLOCK_2 "\ue017"
#define ICON_CLOCK_3 "\ue018"
#define ICON_CLOCK_4 "\ue019"
#define ICON_CLOCK_5 "\uf017"
#define ICON_CLOCK_6 "\ue01a"
#define ICON_CLOCK_7 "\ue01b"
#define ICON_CALENDAR_1 "\uf073"
#define ICON_CALENDAR_2 "\ue01c"

@interface FontIcon : NSObject

+(NSString *)iconString:(char *)icon;

@end
