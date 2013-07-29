//
//  DayCollectionViewCell.h
//  iFRDDomotics
//
//  Created by Sebastien Windal on 7/28/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayChart.h"

@interface DayCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *dayLabel;
@property (nonatomic, weak) IBOutlet DayChart *dayChart;

@end
