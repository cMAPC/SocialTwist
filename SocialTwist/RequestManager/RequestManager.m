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
                         success(responseObject);
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

-(void)getFriendsRequestOnSuccess:(successBlock)success fail:(failBlock)fail {  // ???????????????????????????
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    
    [self.requestManager GET:@"friends/requests/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         success(responseObject);
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         fail(error, 400);
                         [self printError:error task:task];
                     }];
}

-(void)getUserWithId:(NSString *)userId success:(successBlock)success fail:(failBlock)fail {
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];

    [self.requestManager GET:[NSString stringWithFormat:@"users/%@/", userId]
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         success(responseObject);
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         fail(error, 400);
                         [self printError:error task:task];
                     }];
}

-(void)acceptUserFriendRequestWithId:(NSString *)userId success:(successBlock)success fail:(failBlock)fail {
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

-(void)getFriendsOnSuccess:(successBlock)success fail:(failBlock)fail {
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    
    [self.requestManager GET:@"friends/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         success(responseObject);
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         fail(error, 400);
                         [self printError:error task:task];
                     }];
}

-(void)rejectFriendRequestWithId:(NSString *)userId success:(successBlock)success fail:(failBlock)fail {
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

@end
