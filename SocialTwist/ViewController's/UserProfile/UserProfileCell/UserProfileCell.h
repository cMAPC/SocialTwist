//
//  UserProfileCell.h
//  SocialTwist
//
//  Created by Vadim on 6/13/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *userProfileView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoimageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageAndLocationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *uploadPictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picture2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPhoto;

@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;

@property (strong, nonatomic) IBOutlet UIButton *addToFriendButton;

@property (strong, nonatomic) IBOutlet UIButton *numberOFFriends;

@end
