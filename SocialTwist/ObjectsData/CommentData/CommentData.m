//
//  CommentData.m
//  SocialTwist
//
//  Created by Marcel  on 7/3/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "CommentData.h"

@implementation CommentData

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"author" : @"author",
             @"commentID" : @"id",
             @"text" : @"text",
             @"timestamp" : @"timestamp"
             };
}

@end
