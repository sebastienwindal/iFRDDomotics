//
//  LeftMenuViewController.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/11/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kLeftMenuItem_SENSORS = 1,
    kLeftMenuItem_TEMPERATURE,
    kLeftMenuItem_HUMIDITY,
    kLeftMenuItem_ABOUT,
    kLeftMenuItem_SETTINGS
} kLeftMenuItem;

@class LeftMenuViewController;

@protocol LeftMenuViewControllerDelegate <NSObject>

@optional

-(void) leftMenuViewController:(LeftMenuViewController *)menu didSelectMenuItem:(kLeftMenuItem)menuItem;

@end

@interface LeftMenuViewController : UIViewController

@property (nonatomic, weak) id<LeftMenuViewControllerDelegate> delegate;

@end
