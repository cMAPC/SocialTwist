//
//  MapViewController.m
//  MapModule
//

#import "MapViewController.h"

#import "CustomAnnotation.h"

@interface MapViewController () {
    CLLocationManager* locationManager;
    MKPointAnnotation* pointAnnotation;
    CLLocationCoordinate2D touchCoordinate;
    AnnotationDescriptionView* annotationDescriptionView;
    
    NSArray* pinImageArray;
    
    BOOL isPosting;
    
    NSMutableArray* postedPinsArray;
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
    
    [KeyboardAvoiding avoidKeyboardForViewController:self];
    self.eventCategoryKeyboard = [[KeyboardViewController alloc] init];
    
    postedPinsArray = [[NSMutableArray alloc] init];
    _selectedCategories = [[NSMutableArray alloc] init];
//  [_selectedCategories addObject:[NSNumber numberWithInteger:1]];
//    [[EventContent sharedEventContent] allocaArray];
}

-(void)viewDidLayoutSubviews {
    [self.eventCategoryKeyboard setViewController:self];
    [KeyboardAvoiding disableGestureRecognizerOnView:self.eventCategoryKeyboard.view];
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
    
//    
//    MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"singleAnnotationView"];
//    
//    if (!annotationView) {
//        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"singleAnnotationView"];
//    }
//    annotationView.annotation = annotation;
//    annotationView.image = nil;
//    annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mapPinIcons/%@",
//                                                pinImageArray[eventCategoryIndex]]];
//    
//    return annotationView;

//    CalloutView* calloutView = [[[NSBundle mainBundle] loadNibNamed:@"CalloutView" owner:self options:nil] firstObject];
//    
//    PinView *pinView = [[[NSBundle mainBundle] loadNibNamed:@"PinView" owner:self options:nil] firstObject];
////    pinView.categoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mapPinIcons/%@",
////                                                           pinImageArray[[self.eventCategoryKeyboard selectedIndex].integerValue]]];
//
//
//    calloutView.subtitleLabel.text = @"Subtitle";
//    
//    DXAnnotationView *annotationView = (DXAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([DXAnnotationView class])];
//    if (!annotationView) {
//        annotationView = [[DXAnnotationView alloc] initWithAnnotation:annotation
//                                                      reuseIdentifier:NSStringFromClass([DXAnnotationView class])
//                                                              pinView:pinView
//                                                          calloutView:calloutView
//                                                             settings:[DXAnnotationSettings defaultSettings]];
//    }
//    else {
//        annotationView.annotation= annotation;
//    }
//    
//    pinView.categoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mapPinIcons/%@",
//                                                           pinImageArray[eventCategoryIndex]]];
//    
//    return annotationView;
    
////    if ([annotation isKindOfClass:[MKAnnotationView class]]) {
//    
//        UIImageView *pinView = nil;
//        
//        UIView *calloutView = nil;
//        
//        DXAnnotationView *annotationView = (DXAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([DXAnnotationView class])];
//        if (!annotationView) {
//            pinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"mapPinIcons/%@",
//                                                                              pinImageArray[eventCategoryIndex]]]];
//            calloutView = [[[NSBundle mainBundle] loadNibNamed:@"CalloutView" owner:self options:nil] firstObject];
//            
//            annotationView = [[DXAnnotationView alloc] initWithAnnotation:annotation
//                                                          reuseIdentifier:NSStringFromClass([DXAnnotationView class])
//                                                                  pinView:pinView
//                                                              calloutView:calloutView
//                                                                 settings:[DXAnnotationSettings defaultSettings]];
//        }else {
//            
//            //Changing PinView's image to test the recycle
////            pinView = (UIImageView *)annotationView.pinView;
////            pinView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mapPinIcons/%@",
////                                                 pinImageArray[eventCategoryIndex]]];
//        }
////    pinView = (UIImageView *)annotationView.pinView;
//    pinView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mapPinIcons/%@",
//                                         pinImageArray[eventCategoryIndex]]];
////        annotationView.pinView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mapPinIcons/%@",
////                                             pinImageArray[eventCategoryIndex]]];
//
//        return annotationView;
////    }
//    return nil;
    
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation* location = (CustomAnnotation *)annotation;
        
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        
        if (annotationView == nil) {
            annotationView = location.annotationView;
        }
        else{
            annotationView.annotation = annotation;
        
        }
        annotationView.image =[UIImage imageNamed:location.image];

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
        annotationDescriptionView = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationDescriptionView" owner:self options:nil] firstObject];
        annotationDescriptionView.center = self.mapView.center;
        [self.view addSubview:annotationDescriptionView];
    }
    
    [annotationDescriptionView.addAnnotationDescriptionButton addTarget:self action:@selector(addAnnotationDescriptionAction) forControlEvents:UIControlEventTouchUpInside];
    [annotationDescriptionView.selectPinCategoryButton addTarget:self action:@selector(selectPinCategoryAction) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)isPosting {
    return isPosting;
}

-(void)dismissPostAnnotationView {
    isPosting = NO;
    [annotationDescriptionView removeFromSuperview];
}
#pragma mark - AnnotationDescriptionView Action
-(void)selectPinCategoryAction
{
    if ([self.eventCategoryKeyboard isHidden]) {
        [self.eventCategoryKeyboard showAnimated:YES];
    }
    else {
        [self.eventCategoryKeyboard hideAnimated:YES];
    }
}

-(void)addAnnotationDescriptionAction
{
    if (annotationDescriptionView.selectPinCategoryButton.imageView.image &&
        annotationDescriptionView.titleTextField.text.length > 0 &&
        annotationDescriptionView.subtitleTextView.text.length > 0) {
        
//        pointAnnotation = [[MKPointAnnotation alloc] init];
//        pointAnnotation.coordinate = touchCoordinate;
//        pointAnnotation.title = @"Title";
//        pointAnnotation.subtitle = @"Subtitle";
//        eventCategoryIndex = [[_eventCategoryKeyboard selectedIndex] integerValue];
//        [self.mapView addAnnotation:pointAnnotation];
        
        CustomAnnotation* annotatino = [[CustomAnnotation alloc] initWithTitle:@"Title" location:touchCoordinate];
        eventCategoryIndex = [[_eventCategoryKeyboard selectedIndex] integerValue];
        annotatino.image = [NSString stringWithFormat:@"mapPinIcons/%@",
                                                              pinImageArray[[[_eventCategoryKeyboard selectedIndex] integerValue]]];

         [self.mapView addAnnotation:annotatino];
        [annotationDescriptionView removeFromSuperview];
        [self.eventCategoryKeyboard hideAnimated:YES];
        
        isPosting = NO;
        
        
        EventContent* obj = [[EventContent alloc] init];
        [obj setEventCoordinate:touchCoordinate];
        [obj setTitle:@"Title"];
        [obj setSubtitle:@"Subtitle"];
        [obj setEventCategory:[_eventCategoryKeyboard selectedIndex].integerValue];
        [[[EventContent sharedEventContent] eventsArray] addObject:obj];
    }
    else if (annotationDescriptionView.titleTextField.text.length <= 0) {
        NSLog(@"Title requiered");
    }
    else if (annotationDescriptionView.subtitleTextView.text.length <= 0) {
        NSLog(@"Subtitle requiered");
    }
    else if (!annotationDescriptionView.selectPinCategoryButton.imageView.image) {
        NSLog(@"Pin category requiered");
    }
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"Observer");
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        [annotationDescriptionView.selectPinCategoryButton setTitle:nil forState:UIControlStateNormal];
        [annotationDescriptionView.selectPinCategoryButton setImage:[self.eventCategoryKeyboard selectedIndexImage]
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
   [self.mapView removeAnnotations:[self.mapView annotations]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
 
//    for (EventContent* obj in [[EventContent sharedEventContent] eventsArray]) {
////        if ([selectedCategorys containsObject:[NSNumber numberWithInteger:obj.eventCategory]]) {
//        
//        
//                    pointAnnotation = [[MKPointAnnotation alloc] init];
//            eventCategoryIndex = obj.eventCategory;
//            pointAnnotation.coordinate = obj.eventCoordinate;
//            pointAnnotation.title = obj.title;
//            pointAnnotation.subtitle = obj.subtitle;
//            NSLog(@"category %d", obj.eventCategory);
//        
//            [self.mapView addAnnotation:pointAnnotation];
//            [self.mapView setNeedsLayout];
//            [self.mapView setNeedsDisplay];
//   
//      
//
////        }
//       
//
//    }
    });

    NSLog(@"Selected categories %@", self.trash);
    
    NSMutableArray* array = [NSMutableArray new];
        for (EventContent* obj in [[EventContent sharedEventContent] eventsArray]) {
            if ([self.selectedCategories containsObject:[NSNumber numberWithInteger:obj.eventCategory]]) {
            CustomAnnotation* annotatino = [[CustomAnnotation alloc] initWithTitle:@"Title" location:obj.eventCoordinate];
            eventCategoryIndex = obj.eventCategory;
            annotatino.image = [NSString stringWithFormat:@"mapPinIcons/%@", pinImageArray[obj.eventCategory]];
//            pointAnnotation.coordinate = obj.eventCoordinate;
//            pointAnnotation.title = obj.title;
//            pointAnnotation.subtitle = obj.subtitle;
//            NSLog(@"category %d", obj.eventCategory);

                [array addObject:annotatino]; }
//            [self.mapView addAnnotation:annotatino];
        }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.mapView addAnnotations:array];
        
    });
}

- (IBAction)centerCameraOnUserLocationButtonAction:(UIButton *)sender {
//    NSLog(@"nav contro %@", self.navigationController.viewControllers );
    [self mapView:self.mapView didUpdateUserLocation:(MKUserLocation *)locationManager.location];
}

- (IBAction)editButtonAction:(UIButton *)sender {
    NSLog(@"Edit button pressed");
  
    [_selectedCategories addObject:[NSNumber numberWithInteger:0]];
    [_selectedCategories addObject:[NSNumber numberWithInteger:3]];
    [_selectedCategories addObject:[NSNumber numberWithInteger:6]];
    
    EventFilterTableController* eventFilterController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventFilterViewControllerID"];
    
    [self.navigationController pushViewController:eventFilterController animated:YES];
//    [self presentViewController:eventFilterController animated:YES completion:nil];
}

-(void)trashAction:(NSMutableArray *)array{
    NSLog(@"Trash %@", array);
//    self.navigationController.navigationBar.topItem.title = @"Title";
//    [self.navigationItem setTitleView:nil];
//    [self.navigationItem setTitle:@"News"];
//    [self.navigationItem set:@"News"];
}

-(void)viewWillAppear:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *navCon  = (UINavigationController*) [self.navigationController.viewControllers objectAtIndex:0];
        navCon.navigationItem.title = @"News";
    });
//    UINavigationController *navCon  = (UINavigationController*) [self.navigationController.viewControllers objectAtIndex:0];
//    navCon.navigationItem.title = @"News";
//self.navigationController.navigationBar.topItem.title = @"News";
}
@end
