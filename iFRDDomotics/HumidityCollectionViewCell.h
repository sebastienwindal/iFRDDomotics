//
//  HumidityCollectionViewCell.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/21/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionViewCell.h"

@interface HumidityCollectionViewCell : BaseCollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@end
