//
//  SensorTableViewCell.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/13/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "SensorTableViewCell.h"
#import "UILabel+NUI.h"

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
