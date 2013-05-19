//
//  TemperatureCollectionViewCell.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/18/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "TemperatureCollectionViewCell.h"
#import "UILabel+NUI.h"

@implementation TemperatureCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void) layoutSubviews
{
    [super layoutSubviews];
    
    self.temperatureLabel.nuiClass = @"sensorValueLabel";
    self.unitLabel.nuiClass = @"unitSubtitleLabel";
    self.locationLabel.nuiClass = @"unitSubtitleLabel";
}


@end
