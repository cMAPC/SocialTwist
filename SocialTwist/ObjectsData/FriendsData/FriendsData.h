//
//  FriendsData.h
//  SocialTwist
//
//  Created by Marcel  on 6/12/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FriendsData : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString* birthday;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSNumber* userID;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* location;
@property (strong, nonatomic) NSString* phoneNumber;
@property (strong, nonatomic) NSString* picture;
@property (strong, nonatomic) NSString* sex;

@end
