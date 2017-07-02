//
//  FriendListCell.m
//  SocialTwist
//
//  Created by Marcel  on 6/12/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "FriendListCell.h"

@implementation FriendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
