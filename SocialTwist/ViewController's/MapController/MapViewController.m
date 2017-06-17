//
//  MapViewController.m
//  MapModule
//

#import "MapViewController.h"

@interface MapViewController () {
    CLLocationManager* locationManager;
    CLLocationCoordinate2D touchCoordinate;

    PostEventView* postEventView;
    SMVisualEffectView* blurView;
    PinView* pinView;
    CalloutView* calloutView;
    
    NSArray* pinImageArray;
    NSInteger eventCategoryIndex;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    pinImageArray = @[ @"Eating",
                       @"Sport",
                       @"Coffee",
                       @"Drink",
                       @"Thinking",
                       @"Traveling",
                       @"Watching",
                       @"Celebrating",
                       @"Celebrating1",
                       @"Meeting",
                       @"Listen",
                       @"Shopping",
                       @"Reading",
                       @"Supporting",
                       @"Attending",
                       @"Making",
                       @"Sad",
                       @"Happy",
                       @"Loved",
                       @"Amused",
                       @"Wonderful",
                       @"Energized",
                       @"Alone",
                       @"Hungry"];
    
//    [KeyboardAvoiding avoidKeyboardForViewController:self];
    
    self.eventCategoryKeyboard = [[KeyboardViewController alloc] initOnViewController:self];
    pinView = [[[NSBundle mainBundle] loadNibNamed:@"PinView" owner:self options:nil] firstObject];
    
    self.selectedCategories = [[NSMutableArray alloc] initWithArray:
                               [[NSUserDefaults standardUserDefaults] arrayForKey:@"eventCategories"]];
}

#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    MKMapCamera* mapCamera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:userLocation.coordinate eyeAltitude:3000];
    [self.mapView setCamera:mapCamera animated:YES];
}


-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    NSLog(@"mapViewDidFinishRenderingMap");
    [self parseEvents];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    CGRect calloutViewFrame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, self.mapView.frame.size.height - 40);
    calloutView = [[CalloutView alloc] initWithFrame:calloutViewFrame];
    


    [[RequestManager sharedManager] getEventWithID:view.annotation.title
                                           success:^(id responseObject) {
                                               NSLog(@"get event by id response - %@", responseObject);
                                               EventData* event = responseObject;
                                               calloutView.nameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                                                             event.creator.firstName,
                                                                             event.creator.lastName
                                                                             ];
                                               
                                               calloutView.eventContentLabel.text = [NSString stringWithFormat:@"\r %@ \r %@ \r",
                                                                                     event.title,
                                                                                     event.subtitle
                                                                                     ];
                                               
                                               [[DLImageLoader sharedInstance] imageFromUrl:event.creator.picture
                                                                                  completed:^(NSError *error, UIImage *image) {
                                                                                      [calloutView.userImageView setImage:image];
                                                                                  }];
                                               
                                               [[DLImageLoader sharedInstance] imageFromUrl:event.picture
                                                                                  completed:^(NSError *error, UIImage *image) {
                                                                                      [calloutView.eventImageView setImage:image];
                                                                                  }];
                                               
                                               [self.view addSubview:calloutView];
                                           } fail:^(NSError *error, NSInteger statusCode) {
                                               
                                           }];
    
    
    
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [calloutView removeFromSuperview];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation* customAnnotation = (CustomAnnotation *)annotation;
    
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        if (annotationView == nil)
        {
            annotationView = customAnnotation.annotationView;
        }
        else
        {
            annotationView.annotation = annotation;
        }
        
        annotationView.image = customAnnotation.pinImage;
        return annotationView;
    }
    else
        return nil;
}

#pragma mark - MapKit Action
-(IBAction)longPressAddPinAction:(UILongPressGestureRecognizer*) sender {
    CGPoint touchView = [sender locationInView:self.mapView];
    touchCoordinate = [self.mapView convertPoint:touchView toCoordinateFromView:self.mapView];
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        postEventView = [[PostEventView alloc] initWithFrame:CGRectMake(20,
                                                                        ([UIScreen mainScreen].bounds.size.height - 244) / 2,
                                                                        [UIScreen mainScreen].bounds.size.width - 40, 244)];
        [self getReverseGeocodeForCoordinates:touchCoordinate];
        [self addBlurEffect];
    }
    
    
    [[DLImageLoader sharedInstance] imageFromUrl:[[NSUserDefaults standardUserDefaults] objectForKey:@"picture"]
                                       completed:^(NSError *error, UIImage *image) {
                                           [postEventView.userImageView setImage:image];
                                       }];
    
    [postEventView.postButton addTarget:self
                                 action:@selector(postNewEventAction)
                       forControlEvents:UIControlEventTouchUpInside];
    
    [postEventView.cancelButton addTarget:self
                                   action:@selector(cancelPostAction)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [postEventView.eventCategoryButton addTarget:self
                                          action:@selector(selectEventCategoryAction)
                                forControlEvents:UIControlEventTouchUpInside];
    
    [postEventView.eventCameraButton addTarget:self
                                        action:@selector(selectEventImageAction)
                              forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - PostEvent Actions
-(void)selectEventCategoryAction {
    if ([self.eventCategoryKeyboard isHidden])
        [self.eventCategoryKeyboard showAnimated:YES];
    else
        [self.eventCategoryKeyboard hideAnimated:YES];
}

-(void)selectEventImageAction{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = postEventView;
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Choose from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)postNewEventAction
{
    if (![postEventView.eventCategoryButton.currentImage isEqual:[UIImage imageNamed:@"marker"]] &&
        postEventView.titleTextField.text.length > 0 &&
        postEventView.subtitleTextView.text.length > 0) {
        
        [[RequestManager sharedManager] postEventWithTitle:postEventView.titleTextField.text
                                                  subtitle:postEventView.subtitleTextView.text
                                                     image:postEventView.eventImageView.image
                                                  category:[[_eventCategoryKeyboard selectedIndex] stringValue]
                                               coordinates:touchCoordinate
                                                   success:^(id responseObject) {
                                                       EventData* event = responseObject;
                                                       
                                                       CustomAnnotation* annotation = [[CustomAnnotation alloc] init];
                                                       [annotation setTitle:event.eventID.stringValue];
                                                      
                                                       
                                                       [annotation setCoordinate:
                                                        [self convertParsedCoordinates:event.coordinates]];
                                                       
                                                       NSString* imageName = [NSString stringWithFormat:@"mapPinIcons/%@",
                                                                              [pinImageArray objectAtIndex:event.type.integerValue]];
                                                       [pinView.categoryImageView setImage:[UIImage imageNamed:imageName]];
                                                       
                                                       [[DLImageLoader sharedInstance] imageFromUrl:event.creator.picture
                                                                                          completed:^(NSError *error, UIImage *image) {
                                                                                              pinView.profileImageView.image = image;
                                                                                              
                                                                                              annotation.pinImage = [Utilities imageFromView:pinView];
                                                                                              
                                                                                              [self.mapView addAnnotation:annotation];
                                                                                          }];
                                                       
                                                   } fail:^(NSError *error, NSInteger statusCode) {
                                                       
                                                   }];

      
        
        [self removeBlurEffect];
        [self.eventCategoryKeyboard addToView:self.view];
    }
    else if (postEventView.titleTextField.text.length <= 0) {
        NSLog(@"Title requiered");
    }
    else if (postEventView.subtitleTextView.text.length <= 0) {
        NSLog(@"Subtitle requiered");
    }
    else if ([postEventView.eventCategoryButton.currentImage isEqual:[UIImage imageNamed:@"marker"]]) {
        NSLog(@"Pin category requiered");
    }
}

-(void)cancelPostAction {
    [self removeBlurEffect];
    [self.eventCategoryKeyboard addToView:self.view];
}

#pragma mark - EventKeyboard KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"Observer");
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        [postEventView.eventCategoryButton setTitle:nil forState:UIControlStateNormal];
        [postEventView.eventCategoryButton setImage:[self.eventCategoryKeyboard selectedIndexImage]
                                                           forState:UIControlStateNormal];
        
        NSLog(@"selected index : %ld", (long)[self.eventCategoryKeyboard selectedIndex].integerValue);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.eventCategoryKeyboard hideAnimated:YES];
        });
        
    }
}

#pragma mark - Geocoder
-(void)getReverseGeocodeForCoordinates:(CLLocationCoordinate2D)coordinates {
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    CLLocation* location = [[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks,
                                                                  NSError * _Nullable error) {
        CLPlacemark* placemark = [placemarks firstObject];
        NSDictionary* address = placemark.addressDictionary;
        
        NSString* street = [address valueForKey:@"Thoroughfare"];
        NSString* city = [address valueForKey:@"City"];
        NSString* place = [NSString stringWithFormat:@"%@, %@", street, city];
        
        postEventView.name = [NSString stringWithFormat:@"%@ %@",
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"name"],
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"lastName"]
                              ];
        postEventView.placeLabel.text = place;
    }];
}

#pragma mark - BlurEffect
-(void)addBlurEffect {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    blurView = [[SMVisualEffectView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [blurView setBlurRadius:2.5f];
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:blurView];
    //    [self.view addSubview:blurView];
    [self.eventCategoryKeyboard addToView:blurView];
    
    [blurView setAlpha:0.0f];
    
    [UIView animateWithDuration:0.8f animations:^{
        [blurView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [blurView addSubview:postEventView];
        [blurView bringSubviewToFront:self.eventCategoryKeyboard.view];
    }];
    
    
}

-(void)removeBlurEffect {
    [UIView animateWithDuration:0.8f animations:^{
        [blurView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [blurView removeFromSuperview];
    }];
}

#pragma mark - Parse/Filter Events Actions
-(void)filterEventsByCategories {
    [self parseEvents];
}


-(void)parseEvents
{
    __block NSMutableArray* array = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude,
                                                                    self.mapView.centerCoordinate.longitude);
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    dispatch_group_enter(serviceGroup);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[RequestManager sharedManager]
         getEventsFromCoordinates:coordinates
         withRadius:1
         filteredByCategories:self.selectedCategories
         success:^(id responseObject) {
             
             for (EventData* event in responseObject) {
                 
                 CustomAnnotation* annotation;
                 annotation = [[CustomAnnotation alloc] init];
                 
                 [annotation setTitle:event.eventID.stringValue];
                 [annotation setCoordinate:[self convertParsedCoordinates:event.coordinates]];
                 
                 dispatch_group_enter(serviceGroup);
                 [[DLImageLoader sharedInstance] imageFromUrl:event.creator.picture
                                                    completed:^(NSError *error, UIImage *image) {
                                                        if (error == nil) {
                                                            pinView.profileImageView.image = image;
                                                            NSString* imageName = [NSString stringWithFormat:@"mapPinIcons/%@", [pinImageArray objectAtIndex:event.type.integerValue]];
                                                            [pinView.categoryImageView setImage:[UIImage imageNamed:imageName]];
                                                            
                                                            if (!image) {
                                                                pinView.profileImageView.image = [UIImage imageNamed:@"avatar.jpg"];
                                                            }
                                                            
                                                            annotation.pinImage =  [Utilities imageFromView:pinView];
                                                            [array addObject:annotation];
                                                            
                                                            dispatch_group_leave(serviceGroup);
                                                            
                                                        } else {
                                                            // if we got an error when load an image
                                                        }
                                                    }];
                 
             }
             dispatch_group_leave(serviceGroup);
             
         } fail:^(NSError *error, NSInteger statusCode) {
             
         }];
    });
    
    dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
        NSLog(@"All done");
        NSLog(@"Parsed event array count - %ld", (long)array.count);
        
        [self.mapView addAnnotations:array];
    });
}


-(CLLocationCoordinate2D)convertParsedCoordinates:(NSString *)coordinates {
    NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"()"];
    NSArray *splitString = [coordinates componentsSeparatedByCharactersInSet:delimiters];
    delimiters = [NSCharacterSet characterSetWithCharactersInString:@" "];
    splitString = [[splitString objectAtIndex:1] componentsSeparatedByCharactersInSet:delimiters];
    NSString *latitudeString = [splitString objectAtIndex:0];
    NSString *longitudeString = [splitString objectAtIndex:1];
    return CLLocationCoordinate2DMake([latitudeString floatValue], [longitudeString floatValue]);
}

#pragma mark - Bottom Bar Actions
- (IBAction)cameraButtonAction:(UIButton *)sender {
    NSLog(@"Camera button pressed");
}

- (IBAction)centerCameraOnUserLocationButtonAction:(UIButton *)sender {
    [self mapView:self.mapView didUpdateUserLocation:(MKUserLocation *)locationManager.location];
    
    NSLog(@"SelectedCategories array value %@", self.selectedCategories);
}

- (IBAction)editButtonAction:(UIButton *)sender {
    NSLog(@"Edit button pressed");

    EventFilterTableController* eventFilterController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventFilterTableControllerID"];
    
    [self.navigationController pushViewController:eventFilterController animated:YES];
}

@end
