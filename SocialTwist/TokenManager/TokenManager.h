//
//  TokenManager.h
//  SocialTwist
//
//  Created by Marcel  on 6/5/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenManager : NSObject

@property(strong, nonatomic) NSString* token;

+(TokenManager *)sharedToken;

@end
