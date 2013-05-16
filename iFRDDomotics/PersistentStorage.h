//
//  PersistentStorage.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/15/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PersistentStorage : NSObject

@property (nonatomic) BOOL celcius;

+ (PersistentStorage *)sharedInstance;

@end
