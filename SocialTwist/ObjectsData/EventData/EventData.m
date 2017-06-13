//
//  EventData.m
//  SocialTwist
//
//  Created by Marcel  on 6/13/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "EventData.h"

@implementation EventData

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"attenders" : @"attenders",
             @"coordinates" : @"coordinates",
             @"creator" : @"creator",
             @"subtitle" : @"description",
             @"dislikes" : @"dislikes",
             @"userID" : @"id",
             @"isPrivate" : @"is_private",
             @"likes" : @"likes",
             @"location" : @"location",
             @"picture" : @"picture",
             @"startTime" : @"start_time",
             @"title" : @"title",
             @"type" : @"type",
             @"video" : @"video",
             };
}

@end
