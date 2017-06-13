//
//  UserData.h
//  SocialTwist
//
//  Created by Marcel  on 6/12/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface UserData : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSNumber* userId;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* userPicture;
@property (strong, nonatomic) NSString* sex;

+(NSDictionary *)JSONKeyPathsByPropertyKey;

@end
