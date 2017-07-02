//
//  TableViewController.m
//  TableViewDynamicSize
//


#import "TimelineTableController.h"

@interface TimelineTableController () {
    
    CLLocationManager* locationManager;
    NSMutableArray* categoriesArray;
    
    UIRefreshControl *refreshController;
    
    UIView* footerView;
}

@property (strong, nonatomic) NSMutableArray* eventsArray;

@end



@implementation TimelineTableController

static NSInteger eventsInRequest = 5;
static NSInteger eventsInRadius = 1;
static NSInteger loadingCell = 1;
static BOOL hasMoredData = YES;

- (void)viewDidLoad {
    [super viewDidLoad];
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    [imageCache clearMemory];
//    [imageCache clearDisk];
    
    [self initTableWithCustomCell];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-55.0f, 0.f, 44.f, 0.f)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:385];
    
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self
                          action:@selector(handleRefresh:)
                forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshController];

    self.eventCategoryKeyboard = [[KeyboardViewController alloc] initOnViewController:self];
    
    locationManager = [[CLLocationManager alloc] init];
    
    NSArray *temp =@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",
                     @"19",@"20",@"21",@"22",@"23"];
    categoriesArray = [temp copy];
    
    self.eventsArray = [NSMutableArray array];
    [self getEventsFromServerV2];
    
//    [self initFooterView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tableView reloadData];
}

/* version 2
-(void)initFooterView
{
    footerView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x,
                                                          [UIScreen mainScreen].bounds.origin.y,
                                                          [UIScreen mainScreen].bounds.size.width,
                                                          20)];
    
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.tag = 10;
    
    activityIndicator.frame = CGRectMake([UIScreen mainScreen].bounds.origin.x,
                                        [UIScreen mainScreen].bounds.origin.y,
                                        [UIScreen mainScreen].bounds.size.width,
                                        20);
    
    activityIndicator.hidesWhenStopped = YES;
    
    [footerView addSubview:activityIndicator];
    
//    activityIndicator = nil;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    BOOL endOfTable = (scrollView.contentOffset.y >= ((self.eventsArray.count + 1  * 380) - scrollView.frame.size.height)); // Here 40 is row height
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self getEventsFromServerV2];
    });

    if (hasMoredData == YES && endOfTable && !scrollView.dragging && !scrollView.decelerating)
    {
        self.tableView.tableFooterView = footerView;
        
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
            }
    
}
*/

#pragma mark - API
-(void)refreshEvents {
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,
                                                                    locationManager.location.coordinate.longitude);
    
    [[RequestManager sharedManager]
     getEventsFromCoordinates:coordinates
     withRadius:eventsInRadius
     filteredByCategories:categoriesArray
     offset:0
     count:eventsInRequest
     success:^(id responseObject) {
         
         NSMutableArray* newPath = [NSMutableArray array];
         NSMutableArray* newEvents = [NSMutableArray arrayWithArray:responseObject];
         for (int i = 0; i < eventsInRequest; i++) {
             [newPath addObject:[NSIndexPath indexPathForRow:i + 1 inSection:0]];
             EventData* event = newEvents[i];
             [self.eventsArray removeObjectAtIndex:i];
             [self.eventsArray insertObject:event atIndex:i];
         }
         
         [self.tableView beginUpdates];
         [self.tableView reloadRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationRight];
         [self.tableView endUpdates];
         
     } fail:^(NSError *error, NSInteger statusCode) {
         
     }];
    

}

-(void)getEventsFromServer {
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,
                                                                    locationManager.location.coordinate.longitude);
    
    [[RequestManager sharedManager]
     getEventsFromCoordinates:coordinates
                   withRadius:eventsInRadius
         filteredByCategories:categoriesArray
                       offset:[self.eventsArray count]
                        count:eventsInRequest
                      success:^(id responseObject) {
                          [self.eventsArray addObjectsFromArray:responseObject];
                          
                          NSMutableArray* newPaths = [NSMutableArray array];
                          
                          for (int i = (int)[self.eventsArray count] - (int)[responseObject count]; i < [self.eventsArray count]; i++) {
                              [newPaths addObject:[NSIndexPath indexPathForRow:i + 1 inSection:0]];
                              
//                              EventData* event = self.eventsArray[i];
//                              [[DLImageLoader sharedInstance] imageFromUrl:event.picture completed:nil];
                          }
                          
                          [self.tableView beginUpdates];
                          [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
                          [self.tableView endUpdates];
                          
                          
                          /*
                          dispatch_group_t serviceGroup = dispatch_group_create();
                          dispatch_group_enter(serviceGroup);
                          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                              for (int i = (int)[self.eventsArray count] - (int)[responseObject count]; i < [self.eventsArray count]; i++) {
                                  [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                  
                                  EventData* event = self.eventsArray[i];
                                  dispatch_group_enter(serviceGroup);
                                  [[DLImageLoader sharedInstance] imageFromUrl:event.picture completed:^(NSError *error, UIImage *image) {
                                      dispatch_group_leave(serviceGroup);
                                  }];
                              }
                              NSLog(@"Finish");
                               dispatch_group_leave(serviceGroup);
                          });
                          
                          
                         
                          
                          dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
                              NSLog(@"All done");
                              [self.tableView beginUpdates];
                              [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
                              [self.tableView endUpdates];
                          });
                          */
                          
                      } fail:^(NSError *error, NSInteger statusCode) {
                          
                      }];

}

-(void)getEventsFromServerV2 {
    
    NSUInteger oldCount = [self.eventsArray count];
    
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,
                                                                    locationManager.location.coordinate.longitude);
    
    [[RequestManager sharedManager]
     getEventsFromCoordinates:coordinates
     withRadius:eventsInRadius
     filteredByCategories:categoriesArray
     offset:[self.eventsArray count]
     count:eventsInRequest
     success:^(id responseObject) {
         [self.eventsArray addObjectsFromArray:responseObject];
         
         [self.tableView reloadData];
         
         for (int i = (int)[self.eventsArray count] - (int)[responseObject count]; i < [self.eventsArray count]; i++) {
             EventData* event = self.eventsArray[i];
             
             // Version 1
//             [[DLImageLoader sharedInstance] imageFromUrl:event.picture completed:^(NSError *error, UIImage *image) {
//                 [self.tableView beginUpdates];
//                 [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i + 1 inSection:0]]
//                                       withRowAnimation:UITableViewRowAnimationFade];
//                 [self.tableView endUpdates];
//             }];
             
             // Version 2
//             [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:event.picture] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////                 dispatch_async(dispatch_get_main_queue(), ^{
//                     [self.tableView beginUpdates];
//                     [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i + 1 inSection:0]]
//                                           withRowAnimation:UITableViewRowAnimationFade];
//                     [self.tableView endUpdates];
////                 });
//                
//             }];
            
             
         }
         if (oldCount != [self.eventsArray count]) {
             hasMoredData = YES;
         }
         else {
             hasMoredData = NO;
             loadingCell = 0;
             [self.tableView reloadData];
         }
         
     } fail:^(NSError *error, NSInteger statusCode) {
         
     }];

    /*
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     dispatch_async(dispatch_get_main_queue(), ^{
     
     });
     });
     */
}

-(void)handleRefresh:(id)sender {
    [self refreshEvents];
    [refreshController endRefreshing];
}

-(void)initTableWithCustomCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"EventCell" bundle:nil] forCellReuseIdentifier:@"EventCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PostEventCell" bundle:nil] forCellReuseIdentifier:@"PostEventCell"];
}

#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventsArray count] + loadingCell + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        PostEventCell* postEventCell = [tableView dequeueReusableCellWithIdentifier:@"PostEventCell"];
       
        [postEventCell.postButton addTarget:self
                                     action:@selector(postNewEventAction)
                           forControlEvents:UIControlEventTouchUpInside];
        [postEventCell.eventCategoryButton addTarget:self
                                              action:@selector(selectEventCategoryAction)
                                    forControlEvents:UIControlEventTouchUpInside];
        [postEventCell.eventCameraButton addTarget:self
                                            action:@selector(selectEventImageAction)
                                  forControlEvents:UIControlEventTouchUpInside];
        
        postEventCell.tableView = tableView;
        self.eventCategoryKeyboard.delegate = postEventCell;
        
        return postEventCell;
    }
    
    
    EventCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    
    [cell.commentButton setTag:indexPath.row];
    [cell.commentButton addTarget:self
                           action:@selector(commentAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [cell.likeButton setTag:indexPath.row];
    [cell.likeButton addTarget:self
                        action:@selector(likeAction:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [cell.dislikeButton setTag:indexPath.row];
    [cell.dislikeButton addTarget:self
                           action:@selector(dislikeAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row == [self.eventsArray count] + 1) {
        if (hasMoredData) {
            LoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
            [cell.activityIndicatorView startAnimating];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getEventsFromServerV2];
            });
            
            return cell;
            
        }
    }
    else
    {
        EventData* event = [self.eventsArray objectAtIndex:indexPath.row - 1];

        if (event.likes.intValue != 0) {
            [cell adjustLikeButtonStringFormat];
            [cell.likeButton setTitle:event.likes.stringValue forState:UIControlStateNormal];
        }
        else
            [cell adjustLikeButtonDefaultStringFormat];
            
        if (event.dislikes.intValue != 0) {
            [cell adjustDislikeButtonStringFormat];
            [cell.dislikeButton setTitle:event.dislikes.stringValue forState:UIControlStateNormal];
        }
        else
            [cell adjustDislikeButtonDefaultStringFormat];
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", event.creator.firstName, event.creator.lastName];
        cell.eventContentLabel.text = [NSString stringWithFormat:@"\r %@  %ld\r", event.subtitle, (long)indexPath.row];
        
        NSString* userImageURL = event.creator.thumbnail;
        NSString* eventImageURL = event.picture;
    
//    [[DLImageLoader sharedInstance] imageFromUrl:userImageURL
//                                       completed:^(NSError *error, UIImage *image) {
//                                           [cell.userImageView setImage:image];
//                                           [cell layoutSubviews];
//                                           [cell layoutIfNeeded];
//                                       }];
    
//    [[DLImageLoader sharedInstance] imageFromUrl:eventImageURL
//                                       completed:^(NSError *error, UIImage *image) {
//                                           [cell.eventImageView setImage:image];
//                                           [cell layoutSubviews];
//                                           [cell layoutIfNeeded];
//                                       }];
        
//        [[DLImageLoader sharedInstance] imageFromUrl:eventImageURL imageView:cell.eventImageView];
        

//        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:eventImageURL];
//        [cell.eventImageView setImage:image];
        
    
        // Version 2
        if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:userImageURL]) {
            [cell.userImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userImageURL]];
        }
        else
        {
            [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:userImageURL]
                                  placeholderImage:[UIImage imageNamed:@"avatar.jpg"]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             if (!image) {
                                                 [cell.userImageView setImage:[UIImage imageNamed:@"avatar.jpg"]];
                                             }
                                             [cell layoutSubviews];
                                             [cell layoutIfNeeded];
                                             [cell setNeedsLayout];
                                         }];
        }
        
        cell.eventImageView.image = nil;
        
        if (eventImageURL.length > 0) {
            if([[SDImageCache sharedImageCache] diskImageExistsWithKey:eventImageURL]) {
                [cell.eventImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:eventImageURL]];
                [cell layoutSubviews];
                [cell layoutIfNeeded];
                [cell setNeedsLayout];
            } else {
                [cell.eventImageView sd_setImageWithURL:[NSURL URLWithString:eventImageURL]
                                       placeholderImage:[UIImage imageNamed:@"avatar.jpg"]];
                [cell layoutSubviews];
                [cell layoutIfNeeded];
                [cell setNeedsLayout];
            }
            
        }
        
    }
    
    return cell;
}



#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PostEventCell* cell = (PostEventCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        return cell.height + UITableViewAutomaticDimension;
    }
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventViewController* eventViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventViewControllerID"];
    
    EventData* event = [self.eventsArray objectAtIndex:indexPath.row - 1];
    eventViewController.event = event;
    
    [self.navigationController pushViewController:eventViewController animated:YES];
}




/*
#pragma mark - ServerSide
-(void)getEvents {
    
    //    trash = 0;
    //    offset = 0;
    //    [self.tableView reloadData];
 
    CLLocationCoordinate2D currentCoordinates = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,
                                                                           locationManager.location.coordinate.longitude);
    NSLog (@"Pull To Refresh Method Called");
    [[RequestManager sharedManager] getEventsFromCoordinates:currentCoordinates
                                                  withRadius:1
                                        filteredByCategories:selectedCategories
                                                      offset:offset
                                                       limit:limit
                                                     success:^(id responseObject) {
                                                         eventContentArray = [NSMutableArray arrayWithArray:responseObject];
                                                         
                                                         //                                                         for(int i = 0; i < 10; i ++) {
                                                         //                                                             [eventContentArray insertObject:[responseObject objectAtIndex:i] atIndex:i];
                                                         //                                                         }
                                                         
                                                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                                             for (int i = 0; i < eventContentArray.count; i++) {
                                                                 EventData* event = eventContentArray[i];
                                                                 [[DLImageLoader sharedInstance] imageFromUrl:event.picture
                                                                                                    completed:^(NSError *error, UIImage *image) {
                                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                            //                                                   NSIndexPath *index = [NSIndexPath indexPathForRow:i + 1 inSection:0];
                                                                                                            [self.tableView beginUpdates];
                                                                                                            
                                                                                                            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i+1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                                                                                                            [self.tableView endUpdates];
                                                                                                            
                                                                                                        });
                                                                                                    }];
                                                                 
                                                             }
                                                         });
                                                         
                                                         
                                                         NSLog(@"Response timeline count %ld", (long)[responseObject count]);
                                                     } fail:^(NSError *error, NSInteger statusCode) {
                                                         
                                                     }];
    
    
}


-(void)insertNext {
    CLLocationCoordinate2D currentCoordinates = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,
                                                                           locationManager.location.coordinate.longitude);
    NSLog (@"Pull To Refresh Method Called");
    [[RequestManager sharedManager] getEventsFromCoordinates:currentCoordinates
                                                  withRadius:1
                                        filteredByCategories:selectedCategories
                                                      offset:trash+=10
                                                       limit:limit
                                                     success:^(id responseObject) {
//                                                         eventContentArray = responseObject;
                                                         
                                                         [eventContentArray addObjectsFromArray:responseObject];
                                                         NSLog(@"Event count %ld", eventContentArray.count);
//
                                                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                                            
                                                             for (long int i = eventContentArray.count - [responseObject count] ; i < eventContentArray.count; i++) {
                                                                 
                                                                 EventData* event = eventContentArray[i];
                                                                 [[DLImageLoader sharedInstance] imageFromUrl:event.picture
                                                                                                    completed:^(NSError *error, UIImage *image) {
                                                                                                                                                                                                          }];
                                                                 
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     offset+=1;
                                                                     [self.tableView beginUpdates];
                                                                     [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                                                                     [self.tableView endUpdates];
                                                                     
                                                                 });

                                                                 
                                                             }
                                                         });
                                                         
                                                         
                                                         NSLog(@"Response timeline count %ld", (long)[responseObject count]);
                                                     } fail:^(NSError *error, NSInteger statusCode) {
                                                         
                                                     }];
    

}
*/














#pragma mark - EventCell Action
-(void)likeAction:(UIButton *)sender {
    EventData* event = self.eventsArray[sender.tag - 1];
    [[RequestManager sharedManager] postLikeOnEventWithID:event.eventID.stringValue
                                                  success:^(id responseObject) {
                                                      NSLog(@"Post Like response object %@", responseObject);
                                                  } fail:^(NSError *error, NSInteger statusCode) {
                                                      
                                                  }];
}

-(void)dislikeAction:(UIButton *)sender {
    EventData* event = self.eventsArray[sender.tag - 1];
    [[RequestManager sharedManager] postDislikeOnEventWithID:event.eventID.stringValue
                                                     success:^(id responseObject) {
                                                         NSLog(@"Post Dislike response object %@", responseObject);
                                                     } fail:^(NSError *error, NSInteger statusCode) {
                                                         
                                                     }];
}

-(void)commentAction:(UIButton *)sender {
    EventViewController* eventViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventViewControllerID"];
    
    EventData* event = [self.eventsArray objectAtIndex:[sender tag] - 1];
    eventViewController.event = event;
    
    [self.navigationController pushViewController:eventViewController animated:YES];
}



#pragma mark - PostEventCell Action
-(void)selectEventCategoryAction{
    if ([self.eventCategoryKeyboard isHidden])
        [self.eventCategoryKeyboard showAnimated:YES];
    else
        [self.eventCategoryKeyboard hideAnimated:YES];
}

-(void)selectEventImageAction{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Take a photo"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
                                                          [self presentViewController:imagePickerController animated:YES completion:nil];
                                                      }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Choose from Gallery"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                                                          [self presentViewController:imagePickerController animated:YES completion:nil];
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)postNewEventAction{
    PostEventCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedString = [cell.subtitleTextView.text stringByTrimmingCharactersInSet:charSet];
    
//    if (prototypePostCell.eventImag.image != nil ||
//        (![prototypePostCell.subtitleTextView.text isEqualToString:@"What's new?"] && ![trimmedString isEqualToString:@""])
//        ) {
//   
//    }
//    else
//    {
//        [Utilities showAlertControllerWithTitle:@"Invalid input" message:@"You have entered an invalid event description or image" onViewController:self];
//    }
    
    if (cell.eventImageView.image == nil &&
        ([cell.subtitleTextView.text isEqualToString:@"What's new?"] || [trimmedString isEqualToString:@""])
        ){
        [Utilities showAlertControllerWithTitle:@"Invalid input" message:@"You have entered an invalid event description or image" cancelAction:NO onViewController:self];
    }
    else if (([cell.eventCategoryButton.currentImage isEqual:[UIImage imageNamed:@"marker"]])){
        [Utilities showAlertControllerWithTitle:@"Invalid category" message:@"You must enter event category" cancelAction:NO onViewController:self];
    }
    else
    {
//        [[EventContent sharedEventContent] addNewEventWithTitle:@""
//                                                       subtitle:cell.subtitleTextView.text
//                                                    coordinates:CLLocationCoordinate2DMake(0, 0)
//                                                  eventCategory:[self.eventCategoryKeyboard selectedIndex].integerValue
//                                                   profileImage:[UIImage imageNamed:@"imageRight"]
//                                                     eventImage:cell.eventImageView.image];
        
        CLLocationCoordinate2D currentCoordinates = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,
                                                                               locationManager.location.coordinate.longitude);

        
        [[RequestManager sharedManager] postEventWithTitle:@"Title"
                                                  subtitle:cell.subtitleTextView.text
                                                     image:cell.eventImageView.image
                                                  category:[self.eventCategoryKeyboard selectedIndex].stringValue
                                               coordinates:currentCoordinates
                                                   success:^(id responseObject) {
                                                       EventData* event = responseObject;
                                                       
                                                       NSMutableArray* temp = [NSMutableArray array];
                                                       [temp insertObject:event atIndex:0];
                                                       [temp addObjectsFromArray:self.eventsArray];
                                                       self.eventsArray = [NSMutableArray arrayWithArray:temp];
                                                       
//                                                       [self.eventsArray addObject:event];
//                                                       EventData* lastEvent = [self.eventsArray lastObject];
//                                                       [self.eventsArray replaceObjectAtIndex:0 withObject:lastEvent];
//                                                       [self.tableView reloadData];
                                                       
                                                       [self.tableView beginUpdates];
                                                       [cell setEmpty];
                                                       NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                                                       [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                                                             withRowAnimation:UITableViewRowAnimationFade];
                                                       [self.tableView endUpdates];
                                                       
                                                   } fail:^(NSError *error, NSInteger statusCode) {
                                                       
                                                   }];

        
        
        
        
    }
    
    [cell setIsEmpty:YES];
}


#pragma mark - Custom Keyboard KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

}

@end
