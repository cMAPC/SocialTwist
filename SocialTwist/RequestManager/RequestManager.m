//
//  RequestManager.m
//  SocialTwist
//

#import "RequestManager.h"


@interface RequestManager()

@property (nonatomic,strong) AFHTTPSessionManager *requestManager;

@end


@implementation RequestManager

+(RequestManager *)sharedManager
{
    static RequestManager * requestManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[RequestManager alloc]init];
    });
    
    return requestManager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:@"http://35.187.121.251/"];
        self.requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        
        
    }
    return self;
}

-(void)loginWithEmail :(NSString *)email
              username:(NSString *)username
              password:(NSString *)password
             onSuccess:(successBlock)success
                onFail:(failBlock)fail {
    
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    NSDictionary* authenticationParameters = @{@"grant_type": @"password",
                                               @"username" : username,
                                               @"password" : password,
                                               @"client_id": @"TMZfVOHHMoBC0lBniwXpa6htljw0v5topwdBcimi"
                                               };
    
    [self.requestManager POST:@"oauth/token/"
                   parameters:authenticationParameters
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          success(responseObject);
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          fail(error, 400);
                          [self printError:error task:task];
                      }];
    
}

-(void)searchForName:(NSString *)name success:(successBlock)success fail:(failBlock)fail {
    
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    
    [self.requestManager GET:[NSString stringWithFormat:@"users/search/?name=%@", name] 
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSError* error;
                         NSArray* searchResultArray = [MTLJSONAdapter modelsOfClass:[UserData class]
                                                                      fromJSONArray:responseObject
                                                                              error:&error];
                         success(searchResultArray);
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         fail(error, 400);
                         [self printError:error task:task];
                     }];
}

-(void)registerWithName:(NSString *)name
                surname:(NSString *)surname
                  email:(NSString *)email
               password:(NSString *)password
               birthday:(NSString *)date
                 gender:(NSString *)gender
                success:(successBlock)success
                   fail:(failBlock)fail {
    
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [self.requestManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary* registerParameters = @{@"device_token" : @"nil",
                                         @"username" : [NSString stringWithFormat:@"%@%@", name, surname].lowercaseString,
                                         @"last_name" : surname,
                                         @"sex" : gender,
                                         @"is_ios" : @YES,
                                         @"phone_number" : @"nil",
                                         @"location" : @"nil",
                                         @"first_name" : name,
                                         @"email" : email,
                                         @"birthday" : date,
                                         @"password" : password
                                         };
    
    [self.requestManager POST:@"oauth/register/"
                   parameters:registerParameters
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          success(responseObject);
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          fail(error, 400);
                          [self printError:error task:task];
                      }];
}

-(void)getMyProfile:(successBlock)success fail:(failBlock)fail {
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    
    [self.requestManager GET:@"profile/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSError* error;
                         UserData* userData = [MTLJSONAdapter modelOfClass:[UserData class]
                                                        fromJSONDictionary:responseObject
                                                                     error:&error];
                         success(userData);
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         [self printError:error task:task];
                     }];
}

-(void)addFriendWithId:(NSString *)userId success:(successBlock)success fail:(failBlock)fail {
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    [self.requestManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [self.requestManager POST:[NSString stringWithFormat:@"users/%@/add_friend/", userId]
                   parameters:nil
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          success(responseObject);
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          fail(error, 400);
                          [self printError:error task:task];
                      }];

}

-(void)printError:(NSError *)error task:(NSURLSessionDataTask *)task {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Error %@ %@ ", httpResponse, errorResponse);
}


-(id)getFriendRequests { 
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    
//    [self.requestManager GET:@"friends/requests/"
//                  parameters:nil
//                    progress:nil
//                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                         success(responseObject);
//                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                         fail(error, 400);
//                         [self printError:error task:task];
//                     }];
    
    NSMutableArray* friendRequestArray = [[NSMutableArray alloc] init];
    
    [self.requestManager setCompletionQueue:dispatch_queue_create("AFNetworking+Synchronous", NULL)];
    
    NSError* error = nil;
    friendRequestArray = [self.requestManager syncGET:@"friends/requests/"
                                           parameters:nil
                                                 task:NULL
                                                error:&error];
    
    return friendRequestArray;
}



-(id)getUsersWithID:(NSArray *)userIDArray {
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];

//    [self.requestManager GET:[NSString stringWithFormat:@"users/%@/", userId]
//                  parameters:nil
//                    progress:nil
//                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                         success(responseObject);
//                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                         fail(error, 400);
//                         [self printError:error task:task];
//                     }];
    
    NSMutableArray* userContent = [[NSMutableArray alloc] init];
    NSError* error = nil;
    
    [self.requestManager setCompletionQueue:dispatch_queue_create("AFNetworking+Synchronous", NULL)];
    
    for (NSString* userID in userIDArray) {
        NSDictionary* temp = [self.requestManager syncGET:[NSString stringWithFormat:@"users/%@/", userID]
                                               parameters:nil
                                                     task:NULL
                                                    error:&error];
        
        UserData* userData = [MTLJSONAdapter modelOfClass:[UserData class]
                                       fromJSONDictionary:temp
                                                    error:&error];
        [userContent addObject:userData];
    }
    
    return userContent;
}

-(void)acceptUserFriendRequestWithID:(NSString *)userId success:(successBlock)success fail:(failBlock)fail {
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    
    [self.requestManager POST:[NSString stringWithFormat:@"friends/%@/accept/", userId]
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         success(responseObject);
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         fail(error, 400);
                         [self printError:error task:task];
                     }];

}

-(void)rejectFriendRequestWithID:(NSString *)userId success:(successBlock)success fail:(failBlock)fail {
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    
    [self.requestManager POST:[NSString stringWithFormat:@"friends/%@/reject/", userId]
                   parameters:nil
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          success(responseObject);
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          fail(error, 400);
                          [self printError:error task:task];
                      }];
}

-(void)getFriendsOnSuccess:(successBlock)success fail:(failBlock)fail {
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    
    [self.requestManager GET:@"friends/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSError* error;
                         NSArray* friendContentArray = [MTLJSONAdapter modelsOfClass:[FriendsData class]
                                                                       fromJSONArray:responseObject
                                                                               error:&error];
                         success(friendContentArray);

                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         fail(error, 400);
                         [self printError:error task:task];
                     }];
}

-(void)deleteFriendWithID:(NSString *)userID success:(successBlock)success fail:(failBlock)fail {
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    
    [self.requestManager DELETE:[NSString stringWithFormat:@"friends/%@/delete/", userID]
                     parameters:nil
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            success(responseObject);
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            fail(error, 400);
                            [self printError:error task:task];
                        }];
}

#pragma mark - Event Services
-(void)getEventsFromCoordinates:(CLLocationCoordinate2D)coordinates
                     withRadius:(NSUInteger)radius
           filteredByCategories:(NSArray *)categoriesArray
                        success:(successBlock)success
                           fail:(failBlock)fail
{
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary* parameters = @{
                                 @"lat" : [[NSNumber numberWithDouble:coordinates.latitude] stringValue],
                                 @"lon" : [[NSNumber numberWithDouble:coordinates.longitude] stringValue],
                                 @"radius" : [[NSNumber numberWithInteger:radius] stringValue],
                                 @"categories" : categoriesArray
                                 };
    
    [self.requestManager GET:@"events/"
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                         NSLog(@"get events response - %@", responseObject);
//                         NSLog(@"selected categories %@", categoriesArray);
                         
                         NSError* error;
                         NSArray* eventContentArray = [MTLJSONAdapter modelsOfClass:[EventData class]
                                                                      fromJSONArray:responseObject
                                                                              error:&error];
                         if (error) {
                             NSLog(@"Mantle error %@", error);
                         }
                         success(eventContentArray);
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         fail(error, 400);
                         [self printError:error task:task];
                     }];
}

-(id)getSyncEventsFromCoordinates:(CLLocationCoordinate2D)coordinates
                       withRadius:(NSUInteger)radius
             filteredByCategories:(NSArray *)categoriesArray
{
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary* parameters = @{
                                 @"lat" : [[NSNumber numberWithDouble:coordinates.latitude] stringValue],
                                 @"lon" : [[NSNumber numberWithDouble:coordinates.longitude] stringValue],
                                 @"radius" : [[NSNumber numberWithInteger:radius] stringValue],
                                 @"categories" : categoriesArray
                                 };
    
    NSError* error = nil;
    
    [self.requestManager setCompletionQueue:dispatch_queue_create("AFNetworking+Synchronous", NULL)];
    
    NSArray* temp = [self.requestManager syncGET:@"events/"
                                      parameters:parameters
                                            task:NULL
                                           error:&error];
    
    NSArray* eventContentArray = [MTLJSONAdapter modelsOfClass:[EventData class]
                                                 fromJSONArray:temp
                                                         error:&error];
    
    return eventContentArray;
}

-(void)postEventWithTitle:(NSString *)title
                 subtitle:(NSString *)subtitle
                    image:(UIImage *)image
                 category:(NSString *)category
              coordinates:(CLLocationCoordinate2D)coordinate
                  success:(successBlock)success
                     fail:(failBlock)fail
{
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    
    NSString* tempCoordinate = [NSString stringWithFormat:@"POINT(%f %f)", coordinate.latitude, coordinate.longitude];
    
    NSDateFormatter* dateFormmater = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSString* tempStartTime = [dateFormmater stringFromDate:[NSDate date]];
    
    NSDictionary* parameters = @{
                                 @"title": title,
                                 @"coordinates": tempCoordinate,
                                 @"start_time": tempStartTime,
                                 @"type": category,
                                 @"dislikes": @0,
                                 @"likes": @0,
                                 @"location": @"nil",
                                 @"is_private": @NO,
                                 @"description": subtitle
                                 };
    
    
//    UIImage *image1 = [UIImage imageNamed:@"image5.png"];
//    NSData *imageData =  UIImagePNGRepresentation(image, 0.2);
    NSData* imageData = UIImageJPEGRepresentation(image, 0.2);
    
    
    NSString *urlString = [NSString stringWithFormat:@"events/"];
    
    
    [self.requestManager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {  // POST DATA USING MULTIPART CONTENT TYPE
        [formData appendPartWithFileData:imageData
                                    name:@"picture"
                                fileName:@"image.jpg" mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response object %@", responseObject);
        NSError* error;
        EventData* eventContent = [MTLJSONAdapter modelOfClass:[EventData class]
                                            fromJSONDictionary:responseObject
                                                         error:&error];
        success(eventContent);
        
        if (error) {
            NSLog(@"Mantle error - %@", error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}




@end





