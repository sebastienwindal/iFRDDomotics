//
//  UILabel+FadeInTextTransition.m
//  iFRDDomotics
//
//  Created by Sebastien Windal on 5/13/13.
//  Copyright (c) 2013 Sebastien. All rights reserved.
//

#import "UILabel+FadeInTextTransition.h"
#import <QuartzCore/QuartzCore.h>

@implementation UILabel (FadeInTextTransition)

-(void) enableFadeInTransitionWithDuration:(NSTimeInterval)interval {
    CATransition *animation = [CATransition animation];
    animation.duration = interval;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:@"changeTextTransition"];
}

@end
