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
#import "CalloutView.h"
#import "EventContent.h"

#import "EventFilterTableController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;

@property (strong, nonatomic) KeyboardViewController* eventCategoryKeyboard;
@property (strong, nonatomic) NSMutableArray* selectedCategories;

- (IBAction)longPressAddPinAction:(UILongPressGestureRecognizer*) sender;

- (IBAction)cameraButtonAction:(UIButton *)sender;
- (IBAction)centerCameraOnUserLocationButtonAction:(UIButton *)sender;
- (IBAction)editButtonAction:(UIButton *)sender;

- (BOOL)isPosting;
- (void)dismissPostAnnotationView;

-(void)trashAction:(NSMutableArray *)array;
@property (strong, nonatomic) NSString* trash;

@end
