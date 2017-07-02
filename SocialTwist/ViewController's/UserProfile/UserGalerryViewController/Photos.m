//
//  Photos.m
//  SocialTwist
//
//  Created by Vadim on 6/15/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "Photos.h"

@implementation Photos

+ (instancetype)photoWithProperties:(NSDictionary *)photoInfo
{
    return [[Photos alloc] initWithProperties:photoInfo];
}

- (id)initWithProperties:(NSDictionary *)photoInfo;
{
    self = [super init];
    if (self) {
        
        [self setImage:[UIImage imageNamed:photoInfo[@"imageFile"]]];
        
    }
    return self;
}


@end
