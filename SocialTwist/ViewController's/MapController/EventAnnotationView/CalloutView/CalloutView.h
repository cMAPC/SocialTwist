//
//  CalloutView.h
//  SocialTwist
//
//  Created by Marcel  on 6/17/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalloutView : UIView

@property (strong, nonatomic) IBOutlet UIView *calloutView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightEventImageViewConstraint;

@end
