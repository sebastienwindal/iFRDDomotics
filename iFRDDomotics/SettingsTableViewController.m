//
//  SettingsTableViewController.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/15/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "PersistentStorage.h"
#import "UITableViewCell+NUI.h"
#import "LoginViewController.h"
#import "FRDDomoticsClient.h"

@interface SettingsTableViewController () <LoginViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *celciusTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *fahrenheitTableViewCell;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
- (IBAction)logoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *loginStatusLabel;

@end

@implementation SettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.celciusTableViewCell.nuiClass = @"SettingsCell";
    self.fahrenheitTableViewCell.nuiClass = @"SettingsCell";
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == self.celciusTableViewCell) {
        [[PersistentStorage sharedInstance] setCelcius:YES];
    } else {
        [[PersistentStorage sharedInstance] setCelcius:NO];
    }
    
    [self updateUI];
}

-(void) updateUI
{
    BOOL isC = [[PersistentStorage sharedInstance] celcius];
    [self.celciusTableViewCell setAccessoryType:(isC ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone)];
    [self.fahrenheitTableViewCell setAccessoryType:(isC ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark)];
    if ([[PersistentStorage sharedInstance] isLoggedIn]) {
        self.loginStatusLabel.text = [NSString stringWithFormat:@"Logged in as %@", [[PersistentStorage sharedInstance] userName]];
        [self.loginButton setTitle:@"LOG OUT" forState:UIControlStateNormal];
    } else {
        self.loginStatusLabel.text = @"currently logged out.";
        [self.loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    }
}

- (IBAction)logoutAction:(id)sender {
    
    if ([[PersistentStorage sharedInstance] isLoggedIn]) {
        [[PersistentStorage sharedInstance] setPassword:@""];
        [[FRDDomoticsClient sharedClient] setUsername:@""
                                          andPassword:@""];

        [self updateUI];
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.delegate = self;
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}


-(void) loginViewController:(LoginViewController *)loginViewController didLoginWithSuccess:(BOOL)success
{
    if (success) {
        [loginViewController dismissViewControllerAnimated:YES completion:nil];
    }
    [self updateUI];
}

@end
