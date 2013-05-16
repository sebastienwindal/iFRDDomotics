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

@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *celciusTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *fahrenheitTableViewCell;
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

}
@end
