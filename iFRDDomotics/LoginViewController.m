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

    if ([self.delegate respondsToSelector:@selector(loginViewController:didLoginWithSuccess:)])
        [self.delegate loginViewController:self didLoginWithSuccess:YES];
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
