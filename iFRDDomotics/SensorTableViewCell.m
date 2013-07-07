//
//  SensorTableViewCell.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/13/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "SensorTableViewCell.h"
#import "UILabel+NUI.h"
#import "IcoMoon.h"
#import "Sensor.h"
#import "FRDDomoticsClient.h"

@implementation SensorTableViewCell


-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    self.sensorLocationLabel.nuiClass = @"sensorCellLocation";
    self.sensorNameLabel.nuiClass = @"sensorCellName";
    self.sensorTypeIconLabel.nuiClass = @"SensorTypeIconLabel";
    
    self.sensorTypeIconLabel.font = [UIFont fontWithName:@"icomoon" size:20.0];
}

-(void) setType:(kSensorCapabilities)type
{
    if (type == kSensorCapabilities_TEMPERATURE) {
        self.sensorTypeIconLabel.text = [IcoMoon iconString:ICOMOON_THERMOMETER_1 ];
    } else if (type == kSensorCapabilities_HUMIDITY) {
        self.sensorTypeIconLabel.text = [IcoMoon iconString:ICOMOON_TINT];
    } else if (type == kSensorCapabilities_LUMMINOSITY) {
        self.sensorTypeIconLabel.text = [IcoMoon iconString:ICOMOON_SUN_3];
    } else if (type == kSensorCapabilities_LEVEL) {
        self.sensorTypeIconLabel.text = [IcoMoon iconString:ICOMOON_KEY];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
