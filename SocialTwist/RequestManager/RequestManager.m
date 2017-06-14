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
    
//    __block NSMutableArray* userIdArray;
//    __block NSMutableArray* userContentArray = [[NSMutableArray alloc]init];
//    __block int i = 0;
////    dispatch_group_t group = dispatch_group_create();
////    
////    dispatch_group_enter(group);
//    [self.requestManager GET:@"friends/requests/"
//                  parameters:nil
//                    progress:nil
//                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                         
//                         userIdArray = [[NSMutableArray alloc] initWithArray:[responseObject valueForKey:@"sender_id"]];
//                         
//                         NSLog(@"finished 1");
//                         
////                         dispatch_group_enter(group);
////                         dispatch_async(dispatch_get_main_queue(), ^{
//                             for (NSString* userID in userIdArray) {
//                                 
//                                 [self.requestManager GET:[NSString stringWithFormat:@"users/%@/", userID]
//                                               parameters:nil
//                                                 progress:nil
//                                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                                                      
//                                                      NSError* error;
//                                                      UserData* dict = [MTLJSONAdapter modelOfClass:[UserData class]
//                                                                                 fromJSONDictionary:responseObject
//                                                                                              error:&error];
//                                                      
//                                                      [userContentArray addObject:dict];
//                                                      
//                                                      //                                              success(userContentArray);
//                                                      
//                                                      NSLog(@"fcon %@", userContentArray);
////                                                      if (1) {
////                                                          dispatch_group_leave(group);
////                                                      }
//                                                      
//                                                      
//                                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                                                      fail(error, 400);
//                                                      [self printError:error task:task];
//                                                      
//                                                      //                                              dispatch_group_leave(group);
//                                                  }];
//                                 i++;
//                                 
//                             }
////                         if (i == 0) {
//                             NSLog(@"fconn %@", userContentArray);
//                             success(userContentArray);
////                         }
//                         
////                         });
//                         
////                         dispatch_group_leave(group);
//                         
//                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                         fail(error, 400);
//                         [self printError:error task:task];
//                         
////                         dispatch_group_leave(group);
//                     }];
    
    
    
    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"All done");
//        NSLog(@"sender array %@", userContentArray);
//        success(userContentArray);
//    });

    

    
    
//    dispatch_group_t group = dispatch_group_create();
//    
//    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
//        // block1
//        
//        [self.requestManager GET:@"friends/requests/"
//                      parameters:nil
//                        progress:nil
//                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                             
//                             userIdArray = [[NSMutableArray alloc] initWithArray:[responseObject valueForKey:@"sender_id"]];
//                             
//                             NSLog(@"finished 1");
//                             
//                             
//                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                             fail(error, 400);
//                             [self printError:error task:task];
//                             
//                             
//                         }];
//
//        
//        NSLog(@"Block1");
//        NSLog(@"Block1 End");
//    });
//    
//    
//    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
//        // block2
//          [NSThread sleepForTimeInterval:5.0];
//        for (NSString* userID in userIdArray) {
//        NSLog(@"sender id 0 %@", userIdArray[0]);
//        [self.requestManager GET:[NSString stringWithFormat:@"users/%@/", userID]
//                      parameters:nil
//                        progress:nil
//                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                             
//                             NSError* error;
//                             UserData* dict = [MTLJSONAdapter modelOfClass:[UserData class]
//                                                        fromJSONDictionary:responseObject
//                                                                     error:&error];
//                             
//                             [userContentArray addObject:dict];
//                             
//                             success(userContentArray);
//                             
//                             NSLog(@"finished 2");
//                             
//                             
//                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                             fail(error, 400);
//                             [self printError:error task:task];
//                             
//                             
//                         }];
//
//        }
//        
//        NSLog(@"Block2");
//        
//        NSLog(@"Block2 End");
//    });
//    
//    dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
//        NSLog(@"user content %@ ", userContentArray);
//        success(userContentArray);
//        NSLog(@"Block3");
//    });
    
    

}



/*
-(void)getFriendsRequestOnSuccess:(successBlock)success fail:(failBlock)fail {  // ???????????????????????????
    [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.requestManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestManager.requestSerializer setValue:[TokenManager sharedToken].token forHTTPHeaderField:@"Authorization"];
    __block NSMutableArray* userContentArray = [[NSMutableArray alloc]init];
    [self.requestManager GET:@"friends/requests/"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         

                         //CAM ASTA E? da multumes c
                        mult/
                         //DAR ANALIZEAZA CODUL SI FA CURAT IN EL
                         //EU AM FACUT REPEDE
                         //REDENUMESTE CE AI DE REDENUMIT CA SA FIE OK
                         // ;) ok thanks
                         NSMutableArray* userIdArray = [[NSMutableArray alloc] initWithArray:[responseObject valueForKey:@"sender_id"]];
                         
                         [self getUsersDataFrom:userIdArray done:^(id object) {
                            
                             NSLog(@"YOUR RESULT - %@",object);
                             success(object);
                             
                             
                             //EU DE UN AN SCRIUN IN SWIFT
                             //SII CAM COMPLICAT DE INTORS LA OBJC :)
                             
                         }];
                         
                         
//                         for (NSString* userId in userIdArray) {
//                             
//
//                             [[RequestManager sharedManager] getUserWithId:userId
//                                                                   success:^(id responseObject) {
//                                                                       
//                                                                       NSLog(@"Success for %@",userId);
//                                                                       
//                                                                       //SUCCESS NUMAI AICI POATE SA FIE
//                                                                      // success(userContentArray);
//                                                                       
//                                                                       NSError* error;
//                                                                       UserData* dict = [MTLJSONAdapter modelOfClass:[UserData class] fromJSONDictionary:responseObject error:&error];
//                                                                       
//                                                                       [userContentArray addObject:dict];
//                                                                       
//                                                                       if (error) {
//                                                                           NSLog(@"error %@", error);
//                                                                       }
//                                                                       NSLog(@"user content array 1 %@", userContentArray);
//                                                                       
//                                                                   } fail:^(NSError *error, NSInteger statusCode) {
//                                                                       
//                                                                   }];
//                             
//                         }
//                         
//                         //aici in mod normal trebuie sa ai un serviciu carui ii dai aceste IDURI
//                         //SI FACI NUMAI UN SINGUR REQUEST
//                         
//                         NSLog(@"%@",userContentArray);//aici este null
//                         
//                         //AICI E PREA DEVREME, SAU DACA AI AICI TREBUIE SA FACI CANCEL LA REQUEST intelegi ca
//                         // server sidul pentru a obtine friend requesturie da un serviciu care returenreaz id persoanei care mia trimis
//                         //cerere de prietenie, iar eu ca sa populez tabela mea cu date am nevoi de numele si prenumele perosanei, care deja il obtin prin alt serviciu - getUserWithId, nu pot sa fac intrun singur request
//                         //OK
//                         //INSEAMNA CA SI TU TREBUIE SA LUCREZI ASYCRON :)
//            //ACUS
                         
                         //success(userContentArray);
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         fail(error, 400);
                         [self printError:error task:task];
                     }];
}




typedef void(^doneBlock)(id object);
typedef void(^always)(void);

-(void)processGetUserByID:(NSString*)userID done:(doneBlock)done fail:(failBlock)fail always:(always)always {
    
    [[RequestManager sharedManager] getUserWithId:userID
                                          success:^(id responseObject) {
                                              
                                              NSError* error;
                                              UserData* dict = [MTLJSONAdapter modelOfClass:[UserData class] fromJSONDictionary:responseObject error:&error];
                                              
                                              if (error) {
                                                  
                                                  //treb fixat
                                                  fail(error,0);
                                                  
                                                  NSLog(@"error %@", error);
                                              } else {
                                                  done(dict);
                                              }
                                              
                                              always();
                                              
                                          } fail:^(NSError *error, NSInteger statusCode) {
                                              
                                              fail(error,statusCode);
                                              always();
                                              
                                          }];
    
}

-(void)getUsersDataFrom:(NSArray*)usersID done:(doneBlock)done {
    
    NSMutableArray* userContentArray = [[NSMutableArray alloc] init];
    __block int operations = usersID.count;
    __block int doneOperations = 0;
    //nui nici un nslog de asta nu afiseaza nimic
    for (NSString* userId in usersID) {
        
        [self processGetUserByID:userId done:^(UserData *user) {
            
            [userContentArray addObject:user];
            
        } fail:^(NSError *error, NSInteger statusCode) {
            
            //do something
            
        } always:^{
            
            doneOperations++; //indiferent daca a fost cu succes sau fail
            //de asta am adaugat acest block aditional
            
            if (operations == doneOperations) {
                done(userContentArray);
            }
            
        }];
    }
    
}

*/

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
                         NSLog(@"get events response - %@", responseObject);
                         NSLog(@"selected categories %@", categoriesArray);
                         
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
        NSLog(@"Response: %@", responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end





