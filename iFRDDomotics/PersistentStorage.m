//
//  PersistentStorage.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/15/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "PersistentStorage.h"
#import "UICKeyChainStore.h"

@implementation PersistentStorage


#define PERSISTENT_STORAGE_TEMPERATURE_UNIT @"PERSISTENT_STORAGE_TEMPERATURE_UNIT"
#define PERSISTENT_STORAGE_USERNAME @"PERSISTENT_STORAGE_USERNAME"
#define PERSISTENT_STORAGE_PASSWORD @"PERSISTENT_STORAGE_PASSWORD"


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

-(void) setPassword:(NSString *)password
{
    [UICKeyChainStore setString:password forKey:PERSISTENT_STORAGE_PASSWORD];
}

-(NSString *) password {
    return [UICKeyChainStore stringForKey:PERSISTENT_STORAGE_PASSWORD];
}


-(void) setUserName:(NSString *)userName
{
    [UICKeyChainStore setString:userName forKey:PERSISTENT_STORAGE_USERNAME];
}

-(NSString *) userName {
    return [UICKeyChainStore stringForKey:PERSISTENT_STORAGE_USERNAME];
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
