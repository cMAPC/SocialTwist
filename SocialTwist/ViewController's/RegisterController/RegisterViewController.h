//
//  Created by Mihaela Pacalau on 9/2/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginViewController.h"
#import "Utilities.h"
#import "KeyboardAvoiding.h"

@interface RegisterViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *singUpImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)backToLoginAction:(id)sender;


@end
