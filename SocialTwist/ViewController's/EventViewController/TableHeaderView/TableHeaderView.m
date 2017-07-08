//
//  TableHeaderView.m
//  SocialTwist
//
//  Created by Marcel  on 7/3/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "TableHeaderView.h"

@implementation TableHeaderView {
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    CGFloat eventImageHeight;
    CGFloat eventContentLabelHeight;
    CGFloat selfFrameHeight;
}

static NSInteger maxEventImageHeight = 280;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil];
        [self addSubview:self.tableHeaderView];
        
        x = [UIScreen mainScreen].bounds.origin.x;
        y = [UIScreen mainScreen].bounds.origin.y;
        width = [UIScreen mainScreen].bounds.size.width;
        eventImageHeight = self.eventImageView.frame.size.height;
        eventContentLabelHeight = self.eventContentLabel.intrinsicContentSize.height;
        selfFrameHeight = self.tableHeaderView.frame.size.height;
        
        [self setFrame:CGRectMake(x, y, width, selfFrameHeight)];
        
        [self.tableHeaderView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraintRelateToSuperview];
        
    }
    return self;
}

-(void)updateConstraints {
    [super updateConstraints];
    
    if (self.eventImageView.image != nil) {
        NSInteger newEventImageViewHeight = width/self.eventImageView.image.size.width * self.eventImageView.image.size.height;
        
        if (newEventImageViewHeight < maxEventImageHeight) {
            height = selfFrameHeight - eventImageHeight + newEventImageViewHeight + eventContentLabelHeight;
            
            [self setFrame:CGRectMake(x, y, width, height)];
            [self addHeightConstraintToImageView:self.eventImageView constant:newEventImageViewHeight];
        }
        else
        {
            height = selfFrameHeight - eventImageHeight + maxEventImageHeight + eventContentLabelHeight;
            
            [self setFrame:CGRectMake(x, y, width, height)];
            [self addHeightConstraintToImageView:self.eventImageView constant:maxEventImageHeight];
        }
        
    }
    else
    {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.eventContentLabel
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.bottomDelimiterView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:0]];
        
        height = selfFrameHeight - eventImageHeight + eventContentLabelHeight;
        [self setFrame:CGRectMake(x, y, width, height)];
    }
}


-(void)addHeightConstraintToImageView:(UIImageView *)imageView constant:(NSInteger)constant {
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:constant]];
}

-(void)addConstraintRelateToSuperview {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.tableHeaderView
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.tableHeaderView
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.tableHeaderView
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.tableHeaderView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
}

@end
