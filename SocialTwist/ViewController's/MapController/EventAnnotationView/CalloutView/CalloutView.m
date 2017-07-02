//
//  CalloutView.m
//  SocialTwist
//
//  Created by Marcel  on 6/17/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "CalloutView.h"

@implementation CalloutView {
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    CGFloat calloutViewHeight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CalloutView" owner:self options:nil];
        [self addSubview:self.calloutView];
        
        x = frame.origin.x;
        y = frame.origin.y;
        width = frame.size.width;
        height = frame.size.height;
        calloutViewHeight = 174;
        
        [self.calloutView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraintRelateToSuperview];

    }
    return self;
}

-(void)updateConstraints {
    [super updateConstraints];
    NSLog(@"updateConstraints");
    
    if (self.eventImageView.image != nil) {
        CGFloat correctedHeight = (width - 40)/ self.eventImageView.image.size.width * self.eventImageView.image.size.height;
        
        if (correctedHeight + calloutViewHeight > height) {
            [self setFrame:CGRectMake(x, y, width, height)];
            [self.eventImageView setContentMode:UIViewContentModeScaleAspectFill];
            
            [self.eventImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.eventImageView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:height - calloutViewHeight]];
            
        }
        else
        {
            [self setFrame:CGRectMake(x, (y - calloutViewHeight + correctedHeight)/2, width, calloutViewHeight + correctedHeight)];
            [self.eventImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.eventImageView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:correctedHeight]];
        }
    }
    else {
        [self setFrame:CGRectMake(x, (y + calloutViewHeight)/2, width, calloutViewHeight)];
    }
}

-(void)addConstraintRelateToSuperview {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.calloutView
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.calloutView
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1
                                                      constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.calloutView
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.calloutView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
}

#pragma mark - Actions
- (IBAction)closeButtonAction:(id)sender {
    [self removeFromSuperview];
}
@end
