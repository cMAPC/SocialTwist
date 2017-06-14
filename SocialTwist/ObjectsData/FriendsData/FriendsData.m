//
//  FriendsData.m
//  SocialTwist
//
//  Created by Marcel  on 6/12/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "FriendsData.h"

@implementation FriendsData

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"birthday" : @"birthday",
             @"firstName" : @"first_name",
             @"userID" : @"id",
             @"lastName" : @"last_name",
             @"location" : @"location",
             @"phoneNumber" : @"phone_number",
             @"picture" : @"picture",
             @"sex" : @"sex"
             };
}

@end
