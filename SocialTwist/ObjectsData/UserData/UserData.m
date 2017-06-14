//
//  UserData.m
//  SocialTwist
//
//  Created by Marcel  on 6/12/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "UserData.h"

@implementation UserData

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"birthday" : @"birthday",
             @"firstName" : @"first_name",
             @"userID" : @"id",
             @"lastName" : @"last_name",
             @"picture" : @"picture",
             @"sex" : @"sex"
             };
}

@end
