//
//  MapViewController.h
//  MapModule
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "AnnotationDescriptionView.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)longPressAddPinAction:(UILongPressGestureRecognizer*) sender;

@end
