//
//  MainViewController.m
//  MapModule
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    TableViewController* leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"ContainerNavigationControllerID"];

    self.rootViewController = navigationController;
    
    self.leftViewWidth = [UIScreen mainScreen].bounds.size.width - 60;
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
    self.leftViewBackgroundImage = [UIImage imageNamed:@"name"];
    
    self.leftViewController = leftViewController;
    


    
//    UIViewController *rootViewController = [UIViewController new];
//    UITableViewController *leftViewController = [UITableViewController new];
//    UITableViewController *rightViewController = [UITableViewController new];
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
//    
//    LGSideMenuController *sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:navigationController
//                                                                                           leftViewController:leftViewController
//                                                                                          rightViewController:rightViewController];
//    
//    sideMenuController.leftViewWidth = 250.0;
//    sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;

}



@end
