//
//  FontIcon.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/15/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "FontIcon.h"




@implementation FontIcon

+(NSString *)iconString:(char *)icon
{
    //char value[4] = "\ue000";
    NSString *string = [NSString stringWithUTF8String:icon];
    return string;
}

@end
