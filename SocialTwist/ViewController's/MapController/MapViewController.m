//
//  MapViewController.m
//  MapModule
//

#import "MapViewController.h"

@interface MapViewController () {
    CLLocationManager* locationManager;
    MKPointAnnotation* pointAnnotation;
    CLLocationCoordinate2D touchCoordinate;
    AnnotationDescriptionView* annotationDescriptionView;
    
    NSArray* pinImageArray;
    
    BOOL isPosting;
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
        
        pointAnnotation = [[MKPointAnnotation alloc] init];
        pointAnnotation.coordinate = touchCoordinate;
        pointAnnotation.title = @"Title";
        pointAnnotation.subtitle = @"Subtitle";
        [self.mapView addAnnotation:pointAnnotation];
        
        [annotationDescriptionView removeFromSuperview];
        [self.eventCategoryKeyboard hideAnimated:YES];
        
        isPosting = NO;
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
}

- (IBAction)centerCameraOnUserLocationButtonAction:(UIButton *)sender {
    [self mapView:self.mapView didUpdateUserLocation:(MKUserLocation *)locationManager.location];
}

- (IBAction)editButtonAction:(UIButton *)sender {
    NSLog(@"Edit button pressed");
}
@end
