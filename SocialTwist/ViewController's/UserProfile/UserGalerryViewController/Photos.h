//
//  Photos.h
//  SocialTwist
//
//  Created by Vadim on 6/15/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photos : NSObject

@property (strong, nonatomic) UIImage *image;

+ (instancetype)photoWithProperties:(NSDictionary *)photoInfo;
- (id)initWithProperties:(NSDictionary *)photoInfo;

@end
