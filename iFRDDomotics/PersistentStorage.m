//
//  PersistentStorage.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/15/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "PersistentStorage.h"

@implementation PersistentStorage


#define PERSISTENT_STORAGE_TEMPERATURE_UNIT @"PERSISTENT_STORAGE_TEMPERATURE_UNIT"

-(BOOL) celcius
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict = [userDefaults dictionaryRepresentation];
    
    if (![dict objectForKey:PERSISTENT_STORAGE_TEMPERATURE_UNIT]) {
        // key was never set, use the locale to pick a default
        NSLocale *locale = [NSLocale currentLocale];
        
        return [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
    }
    return [[userDefaults objectForKey:PERSISTENT_STORAGE_TEMPERATURE_UNIT] boolValue];
}

-(void) setCelcius:(BOOL)celcius
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:celcius forKey:PERSISTENT_STORAGE_TEMPERATURE_UNIT];
    [userDefaults synchronize];
}


+ (PersistentStorage *)sharedInstance {
    static PersistentStorage *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PersistentStorage alloc] init];
    });
    
    return _sharedInstance;
}

@end
