//
//  WriteCommentBox.m
//  SocialTwist
//
//  Created by Marcel  on 7/3/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "WriteCommentBox.h"

static NSInteger maxCommentTextViewHeight = 150;

@implementation WriteCommentBox {
    CGRect selfFrame;
    CGFloat keyboardHeight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"WriteCommentBox" owner:self options:nil];
        [self addSubview:self.writeCommentBoxView];
        
        [self setFrame:CGRectMake(0.f,
                                  [UIScreen mainScreen].bounds.size.height - self.writeCommentBoxView.frame.size.height,
                                  [UIScreen mainScreen].bounds.size.width,
                                  self.writeCommentBoxView.frame.size.height)];
        
        selfFrame = self.frame;
        
        [self.writeCommentBoxView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraintRelateToSuperview];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillAppear:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

-(void)keyboardWillAppear:(NSNotification *) notification {
    keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;

    CGRect temp = selfFrame;
    temp.origin.y -= keyboardHeight;
    selfFrame = temp;
    [self setFrame:selfFrame];

    if (self.writeCommentTextView.text.length > 1) {
        [self adjustTextViewFrame];
        [self adjustHeightForPostCommentView];

    }
    
    NSLog(@"keyboardWillAppear %f",temp.origin.y);
}

-(void)keyboardWillHide:(NSNotification *)notification {
    CGRect temp = selfFrame;
    temp.origin.y += keyboardHeight;
    selfFrame = temp;
    [self setFrame:selfFrame];
    
    NSLog(@"keyboardWillHide %f",temp.origin.y);
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing");
    if (textView.contentSize.height < maxCommentTextViewHeight) {
        [self adjustTextViewFrame];
        [self adjustHeightForPostCommentView];
        [textView scrollRangeToVisible:NSMakeRange(0, 0)];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Add comment here"]) {
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
    [textView becomeFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        [self setPlaceholderOnTextView:textView];
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - Adjustments
-(void)adjustTextViewFrame {
    CGRect temp = self.writeCommentTextView.frame;
    temp.size.height = self.writeCommentTextView.contentSize.height;
    self.writeCommentTextView.frame = temp;
}

-(void)adjustHeightForPostCommentView {
    CGRect temp = selfFrame;
    temp.origin.y -= self.writeCommentTextView.contentSize.height - 33;
    temp.size.height = self.writeCommentTextView.contentSize.height + 8;
    self.frame = temp;
}

-(void)setPlaceholderOnTextView:(UITextView *)textView {
    [textView setText:@"Add comment here"];
    [textView setTextColor:[UIColor colorWithRed:169/255.0
                                           green:169/255.0
                                            blue:169/255.0
                                           alpha:1]];
}

#pragma mark - Constraints
-(void)addConstraintRelateToSuperview {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.writeCommentBoxView
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.f
                                                      constant:0.f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.writeCommentBoxView
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.f
                                                      constant:0.f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.writeCommentBoxView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.f
                                                      constant:0.f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.writeCommentBoxView
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.f
                                                      constant:0.f]];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
