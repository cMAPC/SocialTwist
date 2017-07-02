//
//  KeyboardController.h
//  PopUpView
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KeyboardViewController.h"

@interface KeyboardAvoiding : NSObject <UITextFieldDelegate, UIGestureRecognizerDelegate>

+(void)avoidKeyboardForViewController:(UIViewController *) viewController;
+(void)avoidKeyboardForScrollView:(UIScrollView *) scrollView onViewController:(UIViewController *) viewController;
+(void)disableGestureRecognizerOnView:(UIView *)view;
@end
