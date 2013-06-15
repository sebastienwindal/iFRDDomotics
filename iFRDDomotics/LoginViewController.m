//
//  LoginViewController.m
//  iFRDDomotics
//
//  Created by Sebastien on 6/6/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "LoginViewController.h"
#import "BButton.h"
#import "PersistentStorage.h"
#import "FRDDomoticsClient.h"
#import "MBProgressHUD.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet BButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.userNameTextField.text = [[PersistentStorage sharedInstance] userName];
    
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.delegate = self;
    self.userNameTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender
{
    [self dismissKeyboard:sender];
    
    [[PersistentStorage sharedInstance] setUserName:self.userNameTextField.text];
    [[PersistentStorage sharedInstance] setPassword:self.passwordTextField.text];
    
    [[FRDDomoticsClient sharedClient] setUsername:[[PersistentStorage sharedInstance] userName]
                                      andPassword:[[PersistentStorage sharedInstance] password]];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Authenticating";
    
    [[FRDDomoticsClient sharedClient] authenticateWithSuccess:^(FRDDomoticsClient *domoClient) {
        [hud hide:YES];
        if ([self.delegate respondsToSelector:@selector(loginViewController:didLoginWithSuccess:)])
            [self.delegate loginViewController:self didLoginWithSuccess:YES];
    } failure:^(FRDDomoticsClient *domoClient, NSString *errorMessage) {
        [hud hide:YES];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Authentication failed" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        if ([self.delegate respondsToSelector:@selector(loginViewController:didLoginWithSuccess:)])
            [self.delegate loginViewController:self didLoginWithSuccess:NO];
        [self.passwordTextField becomeFirstResponder];
    }];
}

#pragma mark UITextFieldDelegate implementation

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self loginAction:self];
    }
    return YES;
}

@end
