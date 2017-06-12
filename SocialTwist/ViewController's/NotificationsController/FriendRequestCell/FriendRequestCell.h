//
//  FriendRequestCell.h
//  SocialTwist
//
//  Created by Marcel  on 6/8/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *confirmRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectRequestButton;

@end
