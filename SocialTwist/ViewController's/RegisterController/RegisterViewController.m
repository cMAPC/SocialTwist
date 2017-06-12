//
//  Created by Mihaela Pacalau on 9/2/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    UIDatePicker* datePicker;
    UIPickerView* genderPickerView;
    NSMutableArray* genderPickerViewDataArray;
    NSDateFormatter* dateFormatter;
    NSNotificationCenter* notificationCenter;
    UITextField* selectedTextField;
    
    LoginViewController *loginViewController;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerID"];
    
    genderPickerView = [[UIPickerView alloc] init];
    genderPickerView.delegate = self;
    
    genderPickerViewDataArray = [[NSMutableArray alloc] initWithObjects:
                                 @"Male",
                                 @"Female",
                                 @"It's complicated",
                                 nil];
    [self.genderTextField setInputView:genderPickerView];
    [self.genderTextField setInputAccessoryView:[self createPickerToolbar:0]];
    
    datePicker = [[UIDatePicker alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    NSDate* theMinimumDate = [dateFormatter dateFromString: @"01-Jan-1966"];
    [datePicker setMinimumDate:theMinimumDate];
    [datePicker setMaximumDate:[NSDate date]];
    
    [datePicker addTarget:self
                   action:@selector(updateDateOfBirthTextFieldAction:)
         forControlEvents:UIControlEventValueChanged];
    
    [self.dateOfBirthTextField setInputView:datePicker];
    [self.dateOfBirthTextField setInputAccessoryView:[self createPickerToolbar:1]];
    
    [Utilities setGradientForImage:self.singUpImage];
    [KeyboardAvoiding avoidKeyboardForScrollView:self.scrollView onViewController:self];
}


#pragma mark - Actions

- (void)updateDateOfBirthTextFieldAction:(id) sender {
//    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString* formattedStringDate = [dateFormatter stringFromDate:datePicker.date];
    self.dateOfBirthTextField.text = formattedStringDate;
}


- (void)pickerToolbarDoneButtonAction:(id)sender {
    
    [self.genderTextField resignFirstResponder];
    [self.dateOfBirthTextField resignFirstResponder];
    if(selectedTextField == self.genderTextField) {
        selectedTextField.text = genderPickerViewDataArray.firstObject;
    }
}

- (void)pickerToolbarNextButtonAction:(id)sender {
    
    [self.genderTextField becomeFirstResponder];
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return genderPickerViewDataArray.count;
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [genderPickerViewDataArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.genderTextField.text = genderPickerViewDataArray[row];
}

#pragma mark - UITextFieldDelegate

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    
//    selectedTextField = textField;
//    notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter addObserver:self
//                           selector:@selector(keyboardWillShowAction:)
//                               name:UIKeyboardWillShowNotification
//                             object:nil];
//    return YES;
//}
//
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    
//    notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter addObserver:self
//                           selector:@selector(keyboardWillHideAction:)
//                               name:UIKeyboardWillHideNotification
//                             object:nil];
//    return YES;
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//
//    NSInteger nextTag = textField.tag + 1;
//    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//
//    if (nextResponder) {
//        [nextResponder becomeFirstResponder];
//    } else {
//        [textField resignFirstResponder];
//    }
//    
//    if (textField == self.confirmPasswordTextField){
//        [self.dateOfBirthTextField becomeFirstResponder];
//    }
//    
//    return NO;
//}


#pragma mark - Utilities

- (UIToolbar*)createPickerToolbar:(BOOL)nextButton {
    NSNotification* notification = [[NSNotification alloc] initWithName:UIKeyboardWillShowNotification object:nil userInfo:nil];
    CGRect keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIToolbar* pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, keyboardSize.size.width, 44)];
    [pickerToolbar setTintColor:[UIColor grayColor]];
    
    UIBarButtonItem* doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(pickerToolbarDoneButtonAction:)];
    
    UIBarButtonItem* nextButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(pickerToolbarNextButtonAction:)];
    
    UIBarButtonItem* spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    if (nextButton) {
        [pickerToolbar setItems:[NSArray arrayWithObjects: doneButtonItem, spaceButtonItem, nextButtonItem, nil]];
    } else {
        [pickerToolbar setItems:[NSArray arrayWithObjects:spaceButtonItem, doneButtonItem, nil]];
    }
    return pickerToolbar;
}



- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action's
- (IBAction)backToLoginAction:(id)sender {
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (IBAction)signUpAction:(id)sender {
    
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [Utilities showAlertControllerWithTitle:@"Try again"
                                        message:@"\rPasswords don't match"
                                   cancelAction:NO
                               onViewController:self];
    }
    else
    {
        [[RequestManager sharedManager] registerWithName:self.firstNameTextField.text
                                                 surname:self.lastNameTextField.text
                                                   email:self.emailTextField.text
                                                password:self.passwordTextField.text
                                                birthday:self.dateOfBirthTextField.text
                                                  gender:@"M" // ??????????????????????
                                                 success:^(id responseObject) {
                                                     NSLog(@"Register response object : %@", responseObject);
                                                     
                                                     [Utilities showAlertControllerWithTitle:@"Congratulations"
                                                                                     message:@"\rYou've just create new account. Press OK to sign in"
                                                                                  buttonType:UIAlertButtonOK
                                                                               buttonHandler:^{
                                                                                   [self presentViewController:loginViewController
                                                                                                      animated:YES
                                                                                                    completion:nil];
                                                                               }
                                                                            onViewController:self];
                                                     
                                                 } fail:^(NSError *error, NSInteger statusCode) {
                                                     
                                                 }];
    }
    
}


@end



