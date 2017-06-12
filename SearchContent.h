//
//  SearchContent.h
//  SocialTwist
//
//  Created by Marcel  on 6/7/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SearchContent : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (assign, nonatomic) NSInteger userId;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) UIImage* userImage;
@property (strong, nonatomic) NSString* sex;

@end
