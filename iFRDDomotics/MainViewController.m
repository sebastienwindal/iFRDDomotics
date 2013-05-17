//
//  MainViewController.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/11/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "MainViewController.h"
#import "UIButton+NUI.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerController.h"
#import "LeftMenuViewController.h"
#import "MMDrawerVisualState.h"
#import "AboutViewController.h"

@interface MainViewController ()<LeftMenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (nonatomic, strong) MMDrawerController *drawerController;
@property (nonatomic) kLeftMenuItem currentItem;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    LeftMenuViewController * leftSideDrawerViewController = [[LeftMenuViewController alloc] init];
    leftSideDrawerViewController.delegate = self;
    
    self.drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:[[UINavigationController alloc] init]
                                            leftDrawerViewController:leftSideDrawerViewController];
    
    [self.drawerController setMaximumRightDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:4.0f]];
    
    [self addChildViewController:self.drawerController];
    [self.drawerController.view setFrame:self.view.bounds];
    [self.view addSubview:self.drawerController.view];
    
    self.currentItem = kLeftMenuItem_SENSORS;
}


-(void) setCurrentItem:(kLeftMenuItem)currentItem
{
    if (_currentItem == currentItem) {
        [self.drawerController closeDrawerAnimated:YES completion:nil];
        return;
    }
    
    _currentItem = currentItem;
    
    if (currentItem == kLeftMenuItem_SENSORS) {
        UIStoryboard *sensorsStoryboard = [UIStoryboard storyboardWithName:@"Sensors"
                                                                        bundle:nil];
        [self.drawerController setCenterViewController:[sensorsStoryboard instantiateInitialViewController]
                                    withCloseAnimation:YES
                                            completion:nil];
    } else if (currentItem == kLeftMenuItem_TEMPERATURE) {
        UIStoryboard *temperatureStoryboard = [UIStoryboard storyboardWithName:@"Temperature"
                                                                        bundle:nil];
        [self.drawerController setCenterViewController:[temperatureStoryboard instantiateInitialViewController] withCloseAnimation:YES completion:nil];
    } else if (currentItem == kLeftMenuItem_ABOUT) {
        AboutViewController *aboutViewController = [[AboutViewController alloc] init];
        [self.drawerController setCenterViewController:aboutViewController
                                    withCloseAnimation:YES
                                            completion:nil];
    } else if (currentItem == kLeftMenuItem_SETTINGS) {
        UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
        [self.drawerController setCenterViewController:[settingsStoryboard instantiateInitialViewController]
                                    withCloseAnimation:YES
                                            completion:nil];
    }
    
    self.drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeFull;
}


-(void) leftMenuViewController:(LeftMenuViewController *)menu didSelectMenuItem:(kLeftMenuItem)menuItem
{
    [self setCurrentItem:menuItem];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
