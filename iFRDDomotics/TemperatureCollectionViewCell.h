//
//  TemperatureCollectionViewCell.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/18/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
