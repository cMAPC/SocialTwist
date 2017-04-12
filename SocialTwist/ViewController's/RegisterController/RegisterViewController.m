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
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
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

//- (void)keyboardWillShowAction:(NSNotification *)notification {
//    
//    CGRect keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    if (selectedTextField.frame.origin.y + 44 > keyboardSize.origin.y) {
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect viewFrame = self.view.frame;
//            viewFrame.origin.y = keyboardSize.origin.y - selectedTextField.frame.origin.y -selectedTextField.frame.size.height - 20;
//            self.view.frame = viewFrame;
//        }];
//    }
//    
//    NSLog(@"%@", [notification userInfo]);
//    NSLog(@"TextField origin y : %f", selectedTextField.frame.origin.y);
//    NSLog(@"Frame origin y : %f", self.view.frame.origin.y);
//}

//- (void)keyboardWillHideAction:(NSNotification *)notification {
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect viewFrame = self.view.frame;
//        viewFrame.origin.y = 0.f;
//        self.view.frame = viewFrame;
//    }];
//    
//    
//}

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


- (IBAction)backToLoginAction:(id)sender {
    
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerID"];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

@end



