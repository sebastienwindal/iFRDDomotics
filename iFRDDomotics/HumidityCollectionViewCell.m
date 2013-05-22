//
//  HumidityCollectionViewCell.m
//  iFRDDomotics
//
//  Created by Sebastien on 5/21/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "HumidityCollectionViewCell.h"
#import "UnitConverter.h"


@implementation HumidityCollectionViewCell

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
 
    self.unitLabel.text = @"%";
}

-(void) setValue:(float)value
{
    self.valueLabel.text = [UnitConverter humidityStringFromValue:value];
}


@end
