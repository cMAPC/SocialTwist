//
//  RequestManager.h
//  SocialTwist
//
//  Created by Marcel  on 6/5/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <AFHTTPSessionManager+Synchronous.h>

#import "TokenManager.h"
#import "UserData.h"
#import "FriendsData.h"
#import "EventData.h"
#import "CommentData.h"

#import <CoreLocation/CoreLocation.h>

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

-(void)getMyProfile:(successBlock)success fail:(failBlock)fail;
-(void)searchForName:(NSString *)name success:(successBlock)success fail:(failBlock)fail;
-(void)addFriendWithId:(NSString *)userId success:(successBlock)success fail:(failBlock)fail;

-(id)getFriendRequests;
-(id)getSyncUsersWithID:(NSArray *)userIDArray;
-(void)getUserWithID:(NSString *)userID success:(successBlock)success fail:(failBlock)fail;

-(void)acceptUserFriendRequestWithID:(NSString *)userId success:(successBlock)success fail:(failBlock)fail;
-(void)getFriendsOnSuccess:(successBlock)success fail:(failBlock)fail; //??????????????????????????
-(void)rejectFriendRequestWithID:(NSString *)userId success:(successBlock)success fail:(failBlock)fail;
-(void)deleteFriendWithID:(NSString *)userID success:(successBlock)success fail:(failBlock)fail;

-(void)getEventWithID:(NSString *)eventID success:(successBlock)success fail:(failBlock)fail;
-(void)getEventsFromCoordinates:(CLLocationCoordinate2D)coordinates
                     withRadius:(NSUInteger)radius
           filteredByCategories:(NSArray *)categoriesArray
                         offset:(NSInteger)offset
                          count:(NSInteger)count
                        success:(successBlock)success
                           fail:(failBlock)fail;

-(void)postEventWithTitle:(NSString *)title
                 subtitle:(NSString *)subtitle
                    image:(UIImage *)image
                 category:(NSString *)category
              coordinates:(CLLocationCoordinate2D)coordinate
                  success:(successBlock)success
                     fail:(failBlock)fail;


////////////////////////////////////////////////
-(id)getSyncEventsFromCoordinates:(CLLocationCoordinate2D)coordinates
                       withRadius:(NSUInteger)radius
             filteredByCategories:(NSArray *)categoriesArray;

-(void)postLikeOnEventWithID:(NSString *)eventID success:(successBlock)success fail:(failBlock)fail;
-(void)postDislikeOnEventWithID:(NSString *)eventID success:(successBlock)success fail:(failBlock)fail;
-(void)attendOnEventWithID:(NSString *)eventID success:(successBlock)success fail:(failBlock)fail;

-(void)getAttendersForEventWithID:(NSString *)eventID success:(successBlock)success fail:(failBlock)fail;

-(void)postComment:(NSString *)text onEventWithID:(NSString *)eventID success:(successBlock)success fail:(failBlock)fail;
-(void)getCommentsForEventWithID:(NSString *)eventID success:(successBlock)success fail:(failBlock)fail;

@end
