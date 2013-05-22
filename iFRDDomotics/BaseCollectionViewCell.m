//
//  BaseCollectionViewCell.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/21/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "UILabel+NUI.h"

@implementation BaseCollectionViewCell


-(void) layoutSubviews
{
    [super layoutSubviews];
    
    self.valueLabel.nuiClass = @"sensorValueLabel";
    self.unitLabel.nuiClass = @"unitSubtitleLabel";
    self.locationLabel.nuiClass = @"unitSubtitleLabel";
}


-(void) setValue:(float)value
{
    
}

@end
