//
//  ControlView.m
//  AutolayoutXib
//
//  Created by Marcel  on 5/26/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "PostEventView.h"

@implementation PostEventView {
    CGRect postEvenViewFrame;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"PostEventView" owner:self options:nil];
        [self addSubview:self.secondView];
        
        [self.secondView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraintRelateToSuperview];
        
        [self adjustTitleTextFieldInsets];
        postEvenViewFrame = self.frame;
        [self.placeLabel addObserver:self
                          forKeyPath:@"text"
                             options:NSKeyValueObservingOptionNew
                             context:nil];
    }
    return self;
}



#pragma mark - KVO 
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqual:@"text"]) {
        [self adjustStringFormat];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.eventImageViewHeighLayoutConstraint.constant = 60;
    //    testView.eventImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGRect tempFrame = self.frame;
    if (self.eventImageView.image == nil) {
        tempFrame.size.height += 60;
    }
    self.eventImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.frame = tempFrame;
    tempFrame.size.height -= self.subtitleTextView.contentSize.height - 33;
    postEvenViewFrame = tempFrame;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate
- (void)textViewDidChange:(UITextView *)textView {
    [self adjustTextViewFrame];
    [self adjustHeightForPostEventView];
    
    [self.subtitleTextView scrollRangeToVisible:NSMakeRange(0, 0)];
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Add a note"]) {
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

#pragma mark - Adjustments
-(void)setPlaceholderOnTextView:(UITextView *)textView {
    [textView setText:@"Add a note"];
    [textView setTextColor:[UIColor colorWithRed:169/255.0
                                           green:169/255.0
                                            blue:169/255.0
                                           alpha:1]];
}

-(void)adjustTextViewFrame {
    CGRect textFrame = self.subtitleTextView.frame;
    textFrame.size.height = self.subtitleTextView.contentSize.height;
    self.subtitleTextView.frame = textFrame;
}

-(void)adjustHeightForPostEventView {
    CGRect tempFrame = postEvenViewFrame;
    tempFrame.size.height += self.subtitleTextView.contentSize.height - 33;
    self.frame = tempFrame;
}

-(void)adjustTitleTextFieldInsets {
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 0)];
    [self.titleTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.titleTextField setLeftView:spacerView];
    
    //placeholder color
    UILabel* placeholderLabel = [self.titleTextField valueForKey:@"placeholderLabel"];
    [placeholderLabel setTextColor:[UIColor colorWithRed:169/255.0
                                                   green:169/255.0
                                                    blue:169/255.0
                                                   alpha:1]];
}

-(void)adjustStringFormat {
    
    NSString* name = @"Spinu Marcel";
    NSString* at = @"at";
    NSString* place = self.placeLabel.text;//@"Chisinau Chisinau Chisinau Chisinau";
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]
                                                          initWithString:[NSString stringWithFormat:@"%@ %@    %@",name,at,place]];
    
    NSTextAttachment* textAttachment = [[NSTextAttachment alloc] init];
    [textAttachment setImage:[UIImage imageNamed:@"pin"]];
    
    CGFloat scaleFactor = textAttachment.image.size.height / 9;
    textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage
                                               scale:scaleFactor orientation:UIImageOrientationUp];
    
    
    [mutableAttributedString beginEditing];
    
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont boldSystemFontOfSize:13]
                                    range:NSMakeRange(0,name.length)];
    
    
    NSDictionary *atAtributeDictionary = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],
                                            NSForegroundColorAttributeName:[UIColor colorWithRed:(169/255.0)
                                                                                           green:(169/255.0)
                                                                                            blue:(169/255.0)
                                                                                           alpha:1]
                                            };
    [mutableAttributedString addAttributes:atAtributeDictionary
                                     range:NSMakeRange(name.length+1,at.length)];
    
    
    NSDictionary *placeAtributeDictionary = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                               NSForegroundColorAttributeName:[UIColor colorWithRed:(155/255.0)
                                                                                              green:(186/255.0)
                                                                                               blue:(205/255.0)
                                                                                              alpha:1]
                                               };
    
    [mutableAttributedString addAttributes:placeAtributeDictionary
                                     range:NSMakeRange(name.length + 7, place.length)];
    
    [mutableAttributedString endEditing];
    
    
    NSAttributedString* attributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(name.length + 5, 1)
                                 withAttributedString:attributedString];
    
    self.placeLabel.attributedText = mutableAttributedString;
}


-(void)addConstraintRelateToSuperview {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.secondView
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.secondView
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1
                                                      constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.secondView
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.secondView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
}

#pragma mark - Action's
- (IBAction)cancelButtonAction:(id)sender {
    [self removeFromSuperview];
}

-(void)dealloc {
    [self.placeLabel removeObserver:self forKeyPath:@"text"];
}
@end
