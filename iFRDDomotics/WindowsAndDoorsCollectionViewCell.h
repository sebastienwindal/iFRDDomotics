//
//  WindowsAndDoorsCollectionViewCell.h
//  iFRDDomotics
//
//  Created by Sebastien on 6/29/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WindowsAndDoorsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
