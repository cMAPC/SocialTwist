//
//  CommentData.h
//  SocialTwist
//
//  Created by Marcel  on 7/3/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <Mantle/Mantle.h>
#import "UserData.h"

@interface CommentData : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) UserData* author;
@property (strong, nonatomic) NSNumber* commentID;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* timestamp;

@end
