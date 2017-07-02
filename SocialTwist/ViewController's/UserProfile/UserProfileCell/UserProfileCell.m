//
//  UserProfileCell.m
//  SocialTwist
//
//  Created by Vadim on 6/13/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "UserProfileCell.h"

@implementation UserProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.userProfileView.layer.cornerRadius = 5.f;
        self.profilePhotoimageView.layer.cornerRadius = self.profilePhotoimageView.frame.size.width / 2;
        
        NSLog(@"h %f", self.profilePhotoimageView.frame.size.height);
        NSLog(@"h/2 %f", self.profilePhotoimageView.frame.size.height / 2);
        NSLog(@"w %f", self.profilePhotoimageView.frame.size.width / 2);
        self.profilePhotoimageView.clipsToBounds = YES;
        
        
    });
   }


- (IBAction)userSendMessageAction:(id)sender {
    
    NSLog(@"Button pressed");
}
-(void)userAddFriendAction:(id)sender
{
    
}

@end
