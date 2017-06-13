//
//  MapViewController.m
//  MapModule
//

#import "MapViewController.h"

#import "CustomAnnotation.h"
#import <QuartzCore/QuartzCore.h>

@interface MapViewController () {
    CLLocationManager* locationManager;
    MKPointAnnotation* pointAnnotation;
    CLLocationCoordinate2D touchCoordinate;
    AnnotationDescriptionView* annotationDescriptionView;
    PostEventView* postEventView;
    PinView* pinView;
    
    NSArray* pinImageArray;
    BOOL isPosting;
    
    NSInteger eventCategoryIndex;
    
    SMVisualEffectView* blurView;
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
    self.selectedCategories = [[NSMutableArray alloc] init];
    
    pinView = [[[NSBundle mainBundle] loadNibNamed:@"PinView" owner:self options:nil] firstObject];
}

#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    MKMapCamera* mapCamera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:userLocation.coordinate eyeAltitude:3000];
    [self.mapView setCamera:mapCamera animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    /* varianta initiala
    CalloutView* calloutView = [[[NSBundle mainBundle] loadNibNamed:@"CalloutView" owner:self options:nil] firstObject];
    
    PinView *pinView = [[[NSBundle mainBundle] loadNibNamed:@"PinView" owner:self options:nil] firstObject];
    pinView.categoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mapPinIcons/%@",
                                                           pinImageArray[[self.eventCategoryKeyboard selectedIndex].integerValue]]];


    calloutView.subtitleLabel.text = @"Subtitle";
    
    DXAnnotationView *annotationView = (DXAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([DXAnnotationView class])];
    if (!annotationView) {
        annotationView = [[DXAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:NSStringFromClass([DXAnnotationView class])
                                                              pinView:pinView
                                                          calloutView:calloutView
                                                             settings:[DXAnnotationSettings defaultSettings]];
    }


    return annotationView;
    */
    
    // varianta cu sortare
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

#pragma mark - Action
-(IBAction)longPressAddPinAction:(UILongPressGestureRecognizer*) sender {
    CGPoint touchView = [sender locationInView:self.mapView];
    touchCoordinate = [self.mapView convertPoint:touchView toCoordinateFromView:self.mapView];
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        /*
        annotationDescriptionView = [[[NSBundle mainBundle]
                                      loadNibNamed:@"AnnotationDescriptionView"
                                      owner:self
                                      options:nil] firstObject];
        
        annotationDescriptionView.center = self.mapView.center; 
         */

//        [self.view addSubview:annotationDescriptionView];
//        [self.view bringSubviewToFront:_eventCategoryKeyboard.view];
        
        postEventView = [[PostEventView alloc] initWithFrame:CGRectMake(20,
                                                                        ([UIScreen mainScreen].bounds.size.height - 244) / 2,
                                                                        [UIScreen mainScreen].bounds.size.width - 40, 244)];
        [self getReverseGeocodeForCoordinates:touchCoordinate];
        [self addBlurEffect];
    }
    
    [postEventView.postButton addTarget:self
                                 action:@selector(postNewEventAction)
                       forControlEvents:UIControlEventTouchUpInside];
    
    [postEventView.eventCategoryButton addTarget:self
                                          action:@selector(selectEventCategoryAction)
                                forControlEvents:UIControlEventTouchUpInside];
    
    [postEventView.eventCameraButton addTarget:self
                                        action:@selector(selectEventImageAction)
                              forControlEvents:UIControlEventTouchUpInside];
    
    /*
    [annotationDescriptionView.addAnnotationDescriptionButton addTarget:self
                                                                 action:@selector(addAnnotationDescriptionAction)
                                                       forControlEvents:UIControlEventTouchUpInside];
    
    [annotationDescriptionView.selectPinCategoryButton addTarget:self
                                                          action:@selector(selectPinCategoryAction)
                                                forControlEvents:UIControlEventTouchUpInside];
     */
}

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
        postEventView.placeLabel.text = place;
    }];
}

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
//    [blurView removeFromSuperview];
    [UIView animateWithDuration:0.8f animations:^{
        [blurView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [blurView removeFromSuperview];
    }];
}

-(BOOL)isPosting {
    return isPosting;
}

-(void)dismissPostAnnotationView {
    isPosting = NO;
    [annotationDescriptionView removeFromSuperview];
}

#pragma mark - AnnotationDescriptionView Action
-(void)selectEventCategoryAction
{
    if ([self.eventCategoryKeyboard isHidden]) {
        [self.eventCategoryKeyboard showAnimated:YES];
    }
    else {
        [self.eventCategoryKeyboard hideAnimated:YES];
    }
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
        
        // varianta initiala
//        pointAnnotation = [[MKPointAnnotation alloc] init];
//        pointAnnotation.coordinate = touchCoordinate;
//        pointAnnotation.title = @"Title";
//        pointAnnotation.subtitle = @"Subtitle";
//        eventCategoryIndex = [[_eventCategoryKeyboard selectedIndex] integerValue];
//        [self.mapView addAnnotation:pointAnnotation];
//        [annotationDescriptionView removeFromSuperview];
        
        // varianta cu sortare
        CustomAnnotation* customAnnotation = [[CustomAnnotation alloc] initWithTitle:@"Title" location:touchCoordinate];
        eventCategoryIndex = [[_eventCategoryKeyboard selectedIndex] integerValue];
        customAnnotation.image = [NSString stringWithFormat:@"mapPinIcons/%@",
                            pinImageArray[[[_eventCategoryKeyboard selectedIndex] integerValue]]];
        
//        PinView* pinView = [[[NSBundle mainBundle] loadNibNamed:@"PinView" owner:self options:nil] firstObject];
        pinView.categoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mapPinIcons/%@",
                                           pinImageArray[[[_eventCategoryKeyboard selectedIndex] integerValue]]]];
        pinView.profileImageView.image = [UIImage imageNamed:@"cat.jpg"];
        
        customAnnotation.pinImage = [Utilities imageFromView:pinView];
        customAnnotation.eventCategory = [[_eventCategoryKeyboard selectedIndex] integerValue];

        [self.mapView addAnnotation:customAnnotation];
//        [annotationDescriptionView removeFromSuperview];
        [self.eventCategoryKeyboard hideAnimated:YES];
        
        isPosting = NO;
        
        
        EventContent* obj = [[EventContent alloc] init];
        [obj setEventCoordinate:touchCoordinate];
        [obj setTitle:@"Title"];
        [obj setSubtitle:@"Subtitle"];
        [obj setEventCategory:[_eventCategoryKeyboard selectedIndex].integerValue];
        [[[EventContent sharedEventContent] eventsArray] addObject:obj];
        
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

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"Observer");
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        [postEventView.eventCategoryButton setTitle:nil forState:UIControlStateNormal];
        [postEventView.eventCategoryButton setImage:[self.eventCategoryKeyboard selectedIndexImage]
                                                           forState:UIControlStateNormal];
        
        NSLog(@"selected index : %ld", (long)[self.eventCategoryKeyboard selectedIndex].integerValue);
        isPosting = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.eventCategoryKeyboard hideAnimated:YES];
        });
        
    }
}

#pragma mark - BottomBarButton's Action
- (IBAction)cameraButtonAction:(UIButton *)sender {
    NSLog(@"Camera button pressed");
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    NSLog(@"%f", locationManager.location.coordinate.latitude);
    [[RequestManager sharedManager] getEventsFromCoordinates:coordinates
                                                  withRadius:1
                                                     success:^(id responseObject) {
                                                         NSLog(@"%@", responseObject);
                                                     } fail:^(NSError *error, NSInteger statusCode) {
                                                         
                                                     }];
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

-(void)filterEventsByCategories {
    
    for (CustomAnnotation* annotation in self.mapView.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            if (![self.selectedCategories containsObject:[NSNumber numberWithInteger:annotation.eventCategory]]
                && [self.selectedCategories count] != 0)
                [[self.mapView viewForAnnotation:annotation] setHidden:YES];
            else
                [[self.mapView viewForAnnotation:annotation] setHidden:NO];
        }
    }

    /* remove alternative
    [self.mapView removeAnnotations:[self.mapView annotations]];
    NSMutableArray* array = [NSMutableArray new];
    
    for (EventContent* obj in [[EventContent sharedEventContent] eventsArray]) {
        if ([self.selectedCategories containsObject:[NSNumber numberWithInteger:obj.eventCategory]]) {
            CustomAnnotation* annotatino = [[CustomAnnotation alloc] initWithTitle:@"Title" location:obj.eventCoordinate];
            eventCategoryIndex = obj.eventCategory;
            
            //annotatino.image = [NSString stringWithFormat:@"mapPinIcons/%@", pinImageArray[obj.eventCategory]];
            //PinView* pinView = [[[NSBundle mainBundle] loadNibNamed:@"PinView" owner:self options:nil] firstObject];
            
            pinView.categoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mapPinIcons/%@", pinImageArray[obj.eventCategory]]];
            pinView.profileImageView.image = [UIImage imageNamed:@"cat.jpg"];
            annotatino.pinImage = [Utilities imageFromView:pinView];
            [array addObject:annotatino];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addAnnotations:array];
    });
    */
}

@end
