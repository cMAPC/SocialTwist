//
//  Utilities.h
//  loginapp
//
//  Created by Mihaela Pacalau on 12/26/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ ButtonHandler)(void);
typedef enum buttonTypes {
    UIAlertButtonDefault,
    UIAlertButtonDiscard,
    UIAlertButtonOK
} ButtonType;

@interface Utilities : NSObject

+ (void)setGradientForImage:(UIImageView *)imageView;
+ (UIView *)setGradientForView:(UIView *)view;
+ (UIView *)getMainUserPin;
+(void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message cancelAction:(BOOL)value onViewController:(UIViewController *)viewController;

+(void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message buttonType:(ButtonType)type buttonHandler:(ButtonHandler)handler onViewController:(UIViewController *)viewController;

@end
