//
//  KeyboardController.m
//  PopUpView
//

#import "KeyboardAvoiding.h"

#pragma mark - Global's
UIViewController* destinationViewController;
UIScrollView* destinationScrollView;
UITapGestureRecognizer *tapGesture;
BOOL isViewController;
NSInteger tagCount;
__strong KeyboardAvoiding* keyboardAvoidingObject;

CGFloat yPositionOffset = 0;

UIView* subview;


@implementation KeyboardAvoiding

#pragma mark - Main Methods
+(void)disableGestureRecognizerOnView:(UIView *)view{
    subview = view;
}

+(void)avoidKeyboardForViewController:(UIViewController *) viewController
{
    keyboardAvoidingObject = [[KeyboardAvoiding alloc] init];
    destinationViewController = viewController;
    isViewController = YES;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.delegate = keyboardAvoidingObject;
    [destinationViewController.view addGestureRecognizer:tapGesture];
    
    [self observeKeyboardEvents];
    [self setTextFieldsTag];
}

+(void)avoidKeyboardForScrollView:(UIScrollView *) scrollView onViewController:(UIViewController *) viewController {
    keyboardAvoidingObject = [[KeyboardAvoiding alloc] init];
    destinationScrollView = scrollView;
    destinationViewController = viewController;
    isViewController = NO;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [destinationScrollView addGestureRecognizer:tapGesture];
    
    [self observeKeyboardEvents];
    [self setTextFieldsTag];
}

+(void)observeKeyboardEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Helper Methods
+(void)dismissKeyboard
{
    if (isViewController) {
        [self resignFirstRespondersInView:destinationViewController.view];
    }
    else
    {
        [self resignFirstRespondersInScrollView:destinationScrollView];
    }
}

+(void)resignFirstRespondersInView:(UIView *) view {
    for (UIView* view1 in view.subviews) {
        if (([view1 isKindOfClass:[UITextField class]] && [view1 isFirstResponder]) ||
            ([view1 isKindOfClass:[UITextView class]] && [view1 isFirstResponder]))
        {
            [view1 resignFirstResponder];
            
        }
        
        if ([view1 isKindOfClass:[UIView class]]) {
            for (UIView *view2 in view1.subviews) {
                if (([view2 isKindOfClass:[UITextField class]] && [view2 isFirstResponder]) ||
                    ([view2 isKindOfClass:[UITextView class]] && [view2 isFirstResponder]))
                {
                    [view2 resignFirstResponder];
                    
                }
                
            }
        }
    }

}

+(void)resignFirstRespondersInScrollView:(UIScrollView *) view {
    for (UIView* view1 in view.subviews) {
        if (([view1 isKindOfClass:[UITextField class]] && [view1 isFirstResponder]) ||
            ([view1 isKindOfClass:[UITextView class]] && [view1 isFirstResponder]))
        {
            [view1 resignFirstResponder];
            
        }
        
        if ([view1 isKindOfClass:[UIView class]]) {
            for (UIView *view2 in view1.subviews) {
                if (([view2 isKindOfClass:[UITextField class]] && [view2 isFirstResponder]) ||
                    ([view2 isKindOfClass:[UITextView class]] && [view2 isFirstResponder]))
                {
                    [view2 resignFirstResponder];
                    
                }
                
            }
        }
    }
    
}

+(void)setTextFieldsTag {
    if (isViewController) {
        for (UIView* view in destinationViewController.view.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                [(UITextField *)view setDelegate:keyboardAvoidingObject];
                //                [(UITextField *)view setReturnKeyType:UIReturnKeyNext];
                //
                //                view.tag = tagCount;
                //                tagCount ++;
                
            }
            
            if ([view isKindOfClass:[UIView class]]) {
                for (UIView *view1 in view.subviews) {
                    if ([view1 isKindOfClass:[UITextField class]]) {
                        [(UITextField *)view1 setDelegate:keyboardAvoidingObject];
                        //                        [(UITextField *)view1 setReturnKeyType:UIReturnKeyNext];
                        
                        //                        view1.tag = tagCount;
                        //                        tagCount ++;
                    }
                    
                }
            }
        }
        
        //        [(UITextField *)[destinationViewController.view.subviews objectAtIndex:tagCount - 2] setReturnKeyType:UIReturnKeyDone];
        
    }
    else
    {
        for (UIView* view in destinationScrollView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                [(UITextField *)view setDelegate:keyboardAvoidingObject];
            }
            
            if ([view isKindOfClass:[UIView class]]) {
                for (UIView *view1 in view.subviews) {
                    if ([view1 isKindOfClass:[UITextField class]]) {
                        [(UITextField *)view1 setDelegate:keyboardAvoidingObject];
                    }
                    
                }
            }
        }
        
    }
}

#pragma mark - Keyboard Show/Hide event Methods
+(void)keyboardWillShow:(NSNotification *) notification {
    
    if (isViewController) {
        for (UIView* view in destinationViewController.view.subviews) {
            if (([view isKindOfClass:[UITextField class]] && [view isFirstResponder]) || ([view isKindOfClass:[UITextView class]] && [view isFirstResponder])) {
                [self adjustViewForKeyboardNotification:notification target:view offset:8.0f];
                
            }
            
            if ([view isKindOfClass:[UIView class]]) {
                for (UIView *view1 in view.subviews) {
                    if (([view1 isKindOfClass:[UITextField class]] && [view1 isFirstResponder]) || ([view1 isKindOfClass:[UITextView class]] && [view1 isFirstResponder])) {
                        CGPoint point = [view1.superview convertPoint:view1.frame.origin toView:destinationViewController.view];
                        UIView* temp = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, view1.frame.size.width, view1.frame.size.height)];
                        
                        [self adjustViewForKeyboardNotification:notification target:temp offset:8.0f];
                        
                    }
                    
                }
            }
        }
        
    }
    else
    {
        for (UIView* view in destinationScrollView.subviews) {
            if ([view isKindOfClass:[UITextField class]] && [view isFirstResponder]) {
                [self adjustViewForKeyboardNotification:notification target:view offset:8.0f];
                
            }
            
            if ([view isKindOfClass:[UIView class]]) {
                for (UIView *view1 in view.subviews) {
                    if ([view1 isKindOfClass:[UITextField class]] && [view1 isFirstResponder]) {
                        [self adjustViewForKeyboardNotification:notification target:view1 offset:8.0f];
                        
                    }
                    
                }
            }
        }
        
        
    }
}


+(void)keyboardWillHide:(NSNotification *) notification {
    [self adjustViewForKeyboardNotification:notification target:nil offset:0];
}


+(void)adjustViewForKeyboardNotification:(NSNotification *)notification target:(UIView *)target offset:(CGFloat)offset
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (isViewController) {
        if ([notification.name isEqual:UIKeyboardWillShowNotification]) {
            
            CGFloat screenOverlap = destinationViewController.view.frame.size.height - keyboardSize.height;
            
            if (target.frame.origin.y + target.frame.size.height > screenOverlap) {
                if (  target.frame.origin.y + target.frame.size.height + yPositionOffset > screenOverlap)
                    yPositionOffset = screenOverlap - target.frame.origin.y - target.frame.size.height - offset;
            }
        }
        else {
            yPositionOffset = 0;
        }
        
        // slide the view up/down to coincide with the keyboard slide
        [UIView animateWithDuration:0.2f animations:^{
            CGRect frame = destinationViewController.view.frame;
            frame.origin.y = yPositionOffset;
            destinationViewController.view.frame = frame;
        }];
        
    }
    else
    {
        if ([notification.name isEqual:UIKeyboardWillShowNotification]) {
            // scroll view above keyboard
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
            destinationScrollView.contentInset = contentInsets;
            destinationScrollView.scrollIndicatorInsets = contentInsets;
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            CGRect aRect = destinationViewController.view.frame;
            aRect.size.height -= keyboardSize.height;
            if (!CGRectContainsPoint(aRect, target.frame.origin) ) {
                CGPoint scrollPoint = CGPointMake(0.0, target.frame.origin.y-keyboardSize.height);
                [destinationScrollView setContentOffset:scrollPoint animated:NO];
            }
            
        } else {
            
            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            destinationScrollView.contentInset = contentInsets;
            destinationScrollView.scrollIndicatorInsets = contentInsets;
        }
    }
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"Delegate");
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    }
    else
    {
        [nextResponder resignFirstResponder];
        [textField resignFirstResponder];
        return YES;
    }
    
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"%ld", (long)textField.tag);
    
}
#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:subview]) {
        return NO;
    }
    return YES;
}

@end
