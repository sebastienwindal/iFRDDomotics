//
//  LoginViewController.h
//  iFRDDomotics
//
//  Created by Sebastien on 6/6/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

@optional

-(void) loginViewController:(LoginViewController *)loginViewController didLoginWithSuccess:(BOOL)success;

@end

@interface LoginViewController : UIViewController

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;

@end
