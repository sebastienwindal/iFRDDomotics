//
//  ColorThresholds.m
//  iFRDDomotics
//
//  Created by Sebastien on 6/1/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "ColorThresholds.h"
#import "UnitConverter.h"
#import "PersistentStorage.h"

@implementation ColorThresholds


-(NSDictionary *) temperatureColorsDict {
    
    if (_temperatureColorsDict == nil) {
        
        if ([[PersistentStorage sharedInstance] celcius])
            _temperatureColorsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIColor colorWithRed:40/255.0f  green:10/255.0f   blue:70/255.0f alpha:1.0f],  @(-50.0f),
                                 [UIColor colorWithRed:37/255.0f  green:11/255.0f   blue:100/255.0f alpha:1.0f], @(-45.0f),
                                 [UIColor colorWithRed:78/255.0f  green:50/255.0f   blue:134/255.0f alpha:1.0f], @(-40.0f),
                                 [UIColor colorWithRed:120/255.0f green:91/255.0f   blue:158/255.0f alpha:1.0f], @(-35.0f),
                                 [UIColor colorWithRed:160/255.0f green:130/255.0f  blue:192/255.0f alpha:1.0f], @(-30.0f),
                                 [UIColor colorWithRed:199/255.0f green:171/255.0f  blue:219/255.0f alpha:1.0f], @(-25.0f),
                                 [UIColor colorWithRed:110/255.0f green:1/255.0f    blue:69/255.0f alpha:1.0f],  @(-20.0f),
                                 [UIColor colorWithRed:163/255.0f green:49/255.0f   blue:136/255.0f alpha:1.0f], @(-15.0f),
                                 [UIColor colorWithRed:215/255.0f green:113/255.0f  blue:206/255.0f alpha:1.0f], @(-10.0f),
                                 [UIColor colorWithRed:167/255.0f green:227/255.0f  blue:251/255.0f alpha:1.0f], @(-5.0f),
                                 [UIColor colorWithRed:89/255.0f  green:118/255.0f  blue:184/255.0f alpha:1.0f], @(0.0f),
                                 [UIColor colorWithRed:22/255.0f  green:19/255.0f   blue:150/255.0f alpha:1.0f], @(5.0f),
                                 [UIColor colorWithRed:122/255.0f green:113/255.0f  blue:98/255.0f alpha:1.0f],  @(10.0f),
                                 [UIColor colorWithRed:216/255.0f green:215/255.0f  blue:49/255.0f alpha:1.0f],  @(15.0f),
                                 [UIColor colorWithRed:217/255.0f green:151/255.0f  blue:3/255.0f alpha:1.0f],   @(20.0f),
                                 [UIColor colorWithRed:214/255.0f green:42/255.0f   blue:6/255.0f alpha:1.0f],   @(25.0f),
                                 [UIColor colorWithRed:146/255.0f green:1/255.0f    blue:0/255.0f alpha:1.0f],   @(30.0f),
                                 [UIColor colorWithRed:245/255.0f green:125/255.0f  blue:199/255.0f alpha:1.0f], @(35.0f),
                                 [UIColor colorWithRed:210/255.0f green:210/255.0f  blue:210/255.0f alpha:1.0f], @(40.0f),
                                 [UIColor colorWithRed:244/255.0f green:0/255.0f    blue:101/255.0f alpha:1.0f], @(45.0f),
                                 [UIColor colorWithRed:149/255.0f green:1/255.0f    blue:51/255.0f alpha:1.0f],  @(50.0f),
                                 nil
                                 ];
        else
            _temperatureColorsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [UIColor colorWithRed:40/255.0f  green:10/255.0f   blue:70/255.0f alpha:1.0f],  @(-70.0f),
                           [UIColor colorWithRed:37/255.0f  green:11/255.0f   blue:100/255.0f alpha:1.0f], @(-60.0f),
                           [UIColor colorWithRed:78/255.0f  green:50/255.0f   blue:134/255.0f alpha:1.0f], @(-50.0f),
                           [UIColor colorWithRed:120/255.0f green:91/255.0f   blue:158/255.0f alpha:1.0f], @(-40.0f),
                           [UIColor colorWithRed:160/255.0f green:130/255.0f  blue:192/255.0f alpha:1.0f], @(-30.0f),
                           [UIColor colorWithRed:199/255.0f green:171/255.0f  blue:219/255.0f alpha:1.0f], @(-20.0f),
                           [UIColor colorWithRed:110/255.0f green:1/255.0f    blue:69/255.0f alpha:1.0f],  @(-10.0f),
                           [UIColor colorWithRed:163/255.0f green:49/255.0f   blue:136/255.0f alpha:1.0f], @(0.0f),
                           [UIColor colorWithRed:215/255.0f green:113/255.0f  blue:206/255.0f alpha:1.0f], @(10.0f),
                           [UIColor colorWithRed:167/255.0f green:227/255.0f  blue:251/255.0f alpha:1.0f], @(20.0f),
                           [UIColor colorWithRed:89/255.0f  green:118/255.0f  blue:184/255.0f alpha:1.0f], @(30.0f),
                           [UIColor colorWithRed:22/255.0f  green:19/255.0f   blue:150/255.0f alpha:1.0f], @(40.0f),
                           [UIColor colorWithRed:122/255.0f green:113/255.0f  blue:98/255.0f alpha:1.0f],  @(50.0f),
                           [UIColor colorWithRed:216/255.0f green:215/255.0f  blue:49/255.0f alpha:1.0f],  @(60.0f),
                           [UIColor colorWithRed:217/255.0f green:151/255.0f  blue:3/255.0f alpha:1.0f],   @(70.0f),
                           [UIColor colorWithRed:214/255.0f green:42/255.0f   blue:6/255.0f alpha:1.0f],   @(80.0f),
                           [UIColor colorWithRed:146/255.0f green:1/255.0f    blue:0/255.0f alpha:1.0f],   @(90.0f),
                           [UIColor colorWithRed:245/255.0f green:125/255.0f  blue:199/255.0f alpha:1.0f], @(100.0f),
                           [UIColor colorWithRed:210/255.0f green:210/255.0f  blue:210/255.0f alpha:1.0f], @(110.0f),
                           [UIColor colorWithRed:244/255.0f green:0/255.0f    blue:101/255.0f alpha:1.0f], @(120.0f),
                           [UIColor colorWithRed:149/255.0f green:1/255.0f    blue:51/255.0f alpha:1.0f],  @(130.0f),
                           nil
                           ];

    }
    return _temperatureColorsDict;
}


@end
