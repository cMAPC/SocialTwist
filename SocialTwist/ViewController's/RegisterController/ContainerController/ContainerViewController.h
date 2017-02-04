//
//  ContainerViewController.h
//  MapModule
//

#import <UIKit/UIKit.h>
#import "AKASegmentedControl.h"

@interface ContainerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *mapViewChild;
@property (weak, nonatomic) IBOutlet UIView *timelineViewChild;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;

@end
