//
//  MapViewController.h
//  MapModule
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "AnnotationDescriptionView.h"
#import <AKASegmentedControl.h>
#import "KeyboardViewController.h"
#import <DXAnnotationView.h>
#import <DXAnnotationSettings.h>
#import "PinView.h"
#import "KeyboardAvoiding.h"
#import "EventContent.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)longPressAddPinAction:(UILongPressGestureRecognizer*) sender;

@property (weak, nonatomic) IBOutlet UIView *bottomBarView;

- (IBAction)cameraButtonAction:(UIButton *)sender;
- (IBAction)centerCameraOnUserLocationButtonAction:(UIButton *)sender;

- (IBAction)editButtonAction:(UIButton *)sender;

@end
