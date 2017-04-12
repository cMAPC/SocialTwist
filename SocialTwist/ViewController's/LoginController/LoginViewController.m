//
//  Created by Mihaela Pacalau on 8/24/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () {

    NSString* usernameString;
    NSString* passwordString;
    NSDictionary* loginDictionary;
    
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loginDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"user", nil]
                                                  forKeys:[NSArray arrayWithObjects:@"user", nil]];
    
    [Utilities setGradientForImage:self.singInImage];
    [KeyboardAvoiding avoidKeyboardForViewController:self];
    
}


#pragma mark - Navigation Bar

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - Actions

- (IBAction)logInButton:(UIButton *)sender {
    
    
    if ([[loginDictionary objectForKey: self.passwordField.text] isEqualToString:self.usernameField.text]) {
        UIViewController* mainController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainControllerID"];
        [self presentViewController:mainController animated:YES completion:nil];
        NSLog(@"Succes");
    }
    else {
        NSLog(@"Unsucces");
        
        UIAlertController* loginErrorAlertController = [UIAlertController alertControllerWithTitle:@"Error Signing In"
                                                                    message:@"The user name or password is incorrect"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* loginErrorAlertAction = [UIAlertAction actionWithTitle:@"OK"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:nil];
        
        [loginErrorAlertController addAction:loginErrorAlertAction];
        [self presentViewController:loginErrorAlertController animated:YES completion:nil];
    }
}

- (IBAction)registerButton:(UIButton *)sender {
    
    RegisterViewController* registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewControllerID"];
    [self presentViewController:registerViewController animated:YES completion:nil];
//    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
