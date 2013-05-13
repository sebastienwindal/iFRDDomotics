//
//  main.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/10/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "NUISettings.h"


int main(int argc, char *argv[])
{
    @autoreleasepool {
        [NUISettings initWithStylesheet:@"theme"];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
