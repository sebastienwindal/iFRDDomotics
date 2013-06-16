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
#import "Sensor.h"
#import "TemperatureCollectionViewController.h"
#import "PersistentStorage.h"
#import "MBProgressHUD.h"
#import "FRDDomoticsClient.h"
#import "LoginViewController.h"
#import "KGStatusBar.h"

@interface MainViewController ()<LeftMenuViewControllerDelegate, LoginViewControllerDelegate>


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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Authenticating";
    [KGStatusBar showWithStatus:@"Authenticating..."];
    
    [[FRDDomoticsClient sharedClient] authenticateWithSuccess:^(FRDDomoticsClient *domoClient) {
        [hud hide:YES];
        [self successLoginLoad];
        [KGStatusBar dismiss];
    } failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
        [hud hide:YES];
        [KGStatusBar showErrorWithStatus:@"Failed to authenticate."];
        [self failedLoginLoad];
    }];
}

-(NSString *) nibName
{
    return @"Splash";
}


-(void) failedLoginLoad
{
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginVC.delegate = self;
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:loginVC animated:YES completion:nil];
}

-(void) loginViewController:(LoginViewController *)loginViewController didLoginWithSuccess:(BOOL)success
{
    if (success) {
        [loginViewController dismissViewControllerAnimated:YES completion:^{
            [self successLoginLoad];
        }];
    }
}

-(void) successLoginLoad
{
    LeftMenuViewController * leftSideDrawerViewController = [[LeftMenuViewController alloc] init];
    leftSideDrawerViewController.delegate = self;
    
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:[[UINavigationController alloc] init]
                             leftDrawerViewController:leftSideDrawerViewController];
    
    [self.drawerController setMaximumRightDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:4.0f]];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         
         float originalWhite = 0x20 / 256.0f;
         
         //0      0
         //1      1.0-originalWhite
         
         UIColor *bgndC = [UIColor colorWithWhite:(originalWhite + (1.0f-originalWhite)*percentVisible)
                                            alpha:1.0f];

         UIViewController *vc;
         if ([[drawerController centerViewController] isKindOfClass:[UINavigationController class]]) {
             [[(UINavigationController *)[drawerController centerViewController] navigationBar] setTintColor:bgndC];
             vc = drawerController.centerViewController.childViewControllers[0];
         } else {
             vc = drawerController.centerViewController;
         }

     }];
    
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
    } else if (currentItem == kLeftMenuItem_TEMPERATURE || currentItem == kLeftMenuItem_HUMIDITY) {
        UIStoryboard *temperatureStoryboard = [UIStoryboard storyboardWithName:@"Sensors"
                                                                        bundle:nil];
        UINavigationController *navigationController = [temperatureStoryboard instantiateViewControllerWithIdentifier:@"TemperatureRoot"];
        
        TemperatureCollectionViewController *initialTemperatureViewController = navigationController.viewControllers[0];
        
        kSensorCapabilities capa;
        if (currentItem == kLeftMenuItem_TEMPERATURE)
            capa = kSensorCapabilities_TEMPERATURE;
        else
            capa = kSensorCapabilities_HUMIDITY;
        
        [initialTemperatureViewController setValueType:capa];
        
        [self.drawerController setCenterViewController:navigationController
                                    withCloseAnimation:YES
                                            completion:nil];
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
