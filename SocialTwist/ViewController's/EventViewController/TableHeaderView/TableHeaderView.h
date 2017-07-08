//
//  TableHeaderView.h
//  SocialTwist
//
//  Created by Marcel  on 7/3/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *attendersLabel;

@property (weak, nonatomic) IBOutlet UIButton *attendButton;

@property (weak, nonatomic) IBOutlet UIView *bottomDelimiterView;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;

@end
