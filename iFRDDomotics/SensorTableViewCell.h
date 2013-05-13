//
//  SensorTableViewCell.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/13/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SensorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sensorLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *sensorNameLabel;

@end
