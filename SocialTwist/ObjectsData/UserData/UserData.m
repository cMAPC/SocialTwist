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
             @"firstName" : @"first_name",
             @"userId" : @"id",
             @"lastName" : @"last_name",
             @"userPicture" : @"picture",
             @"sex" : @"sex"
             };
}

@end
