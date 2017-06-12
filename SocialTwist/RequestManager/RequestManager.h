//
//  RequestManager.h
//  SocialTwist
//
//  Created by Marcel  on 6/5/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

#import "TokenManager.h"

typedef void(^successBlock)(id responseObject);
typedef void(^failBlock)(NSError* error, NSInteger statusCode);

@interface RequestManager : NSObject

+(RequestManager *)sharedManager;

-(void)loginWithEmail :(NSString *)email
              username:(NSString *)username
              password:(NSString *)password onSuccess:(successBlock)success onFail:(failBlock)fail;

-(void)registerWithName:(NSString *)name
                surname:(NSString *)surname
                  email:(NSString *)email
               password:(NSString *)password
               birthday:(NSString *)date
                 gender:(NSString *)gender
                success:(successBlock)success
                   fail:(failBlock)fail;

-(void)searchForName:(NSString *)name success:(successBlock)success fail:(failBlock)fail;
-(void)addFriendWithId:(NSString *)userId success:(successBlock)success fail:(failBlock)fail;
-(void)getFriendsRequestOnSuccess:(successBlock)success fail:(failBlock)fail; // ???????????????????????????
-(void)getUserWithId:(NSString *)id success:(successBlock)success fail:(failBlock)fail;
-(void)acceptUserFriendRequestWithId:(NSString *)userId success:(successBlock)success fail:(failBlock)fail;
-(void)getFriendsOnSuccess:(successBlock)success fail:(failBlock)fail; //??????????????????????????
-(void)rejectFriendRequestWithId:(NSString *)userId success:(successBlock)success fail:(failBlock)fail;

@end
