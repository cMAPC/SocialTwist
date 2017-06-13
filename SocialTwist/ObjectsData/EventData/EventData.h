//
//  EventData.h
//  SocialTwist
//
//  Created by Marcel  on 6/13/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <Mantle/Mantle.h>
#import "UserData.h"

@interface EventData : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSNumber* attenders;
@property (strong, nonatomic) NSString* coordinates;
@property (strong, nonatomic) UserData* creator;
@property (strong, nonatomic) NSString* subtitle;
@property (strong, nonatomic) NSNumber* dislikes;
@property (strong, nonatomic) NSNumber* userID;
@property (assign, nonatomic) NSNumber* isPrivate;
@property (strong, nonatomic) NSNumber* likes;
@property (strong, nonatomic) NSString* location;
@property (strong, nonatomic) NSString* picture;
@property (strong, nonatomic) NSString* startTime;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* video;

+(NSDictionary *)JSONKeyPathsByPropertyKey;

@end
