//
//  TemperatureCollectionViewCell.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/18/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "TemperatureCollectionViewCell.h"
#import "UILabel+NUI.h"
#import "UnitConverter.h"
#import "UnitConverter.h"

@implementation TemperatureCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    self.unitLabel.text = [UnitConverter temperatureUnitName];
}

-(void) setValue:(float)value
{
    self.valueLabel.text = [UnitConverter temperatureStringFromValue:value];
}

@end
