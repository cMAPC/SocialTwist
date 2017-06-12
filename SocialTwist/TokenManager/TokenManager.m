
//  TokenManager.m
//  SocialTwist
//
//  Created by Marcel  on 6/5/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "TokenManager.h"

@implementation TokenManager

@synthesize token;

+(TokenManager *)sharedToken {
    static TokenManager* tokenManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tokenManager = [[TokenManager alloc] init];
    });
    return tokenManager;
}

-(void)setToken:(NSString *)value {
    token = [NSString stringWithFormat:@"Bearer %@", value];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    NSLog(@"Set token is : %@", self.token);
}

-(NSString *)token {
    token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSLog(@"Get token is : %@", token);
    return token;
}

@end
