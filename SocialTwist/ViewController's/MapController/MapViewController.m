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
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    MKMapCamera* mapCamera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:userLocation.coordinate eyeAltitude:3000];
    [self.mapView setCamera:mapCamera animated:YES];
}

#pragma mark - Action
- (IBAction)longPressAddPinAction:(UILongPressGestureRecognizer*) sender {
    CGPoint touchView = [sender locationInView:self.mapView];
    touchCoordinate = [self.mapView convertPoint:touchView toCoordinateFromView:self.mapView];
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        annotationDescriptionView = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationDescriptionView" owner:self options:nil] firstObject];
        annotationDescriptionView.center = self.view.center;
        [self.view addSubview:annotationDescriptionView];
    }
    
    [annotationDescriptionView.addAnnotationDescriptionButton addTarget:self action:@selector(addAnnotationDescriptionAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addAnnotationDescriptionAction
{
    pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = touchCoordinate;
    pointAnnotation.title = @"Title";
    pointAnnotation.subtitle = annotationDescriptionView.titleTextField.text;
    [self.mapView addAnnotation:pointAnnotation];
    
    [annotationDescriptionView removeFromSuperview];
}

@end
