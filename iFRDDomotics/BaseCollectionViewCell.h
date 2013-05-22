//
//  BaseCollectionViewCell.h
//  iFRDDomotics
//
//  Created by Sebastien on 5/21/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell


-(UILabel *)valueLabel;
-(UILabel *)unitLabel;
-(UILabel *)locationLabel;
-(void) setValue:(float)value;
@end
