//
//  PostEventCell.m
//  SocialTwist
//

#import "PostEventCell.h"

@implementation PostEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setIsEmpty:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - KeyboardControllerDelegate
-(void)didTapKeyboard:(KeyboardViewController *)keyboard item:(NSInteger)item itemImage:(UIImage *)image {
    NSLog(@"Tapped category - %ld", (long)item);
    
    [self.eventCategoryButton setImage:image
                              forState:UIControlStateNormal];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [keyboard hideAnimated:YES];
    });
    
    [self setIsEmpty:NO];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.eventImageViewHeighLayoutConstraint.constant = 60;
    self.height = 180;
    self.eventImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self adjustCellHeight];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self setIsEmpty:NO];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self adjustTextViewFrame];
    [self adjustCellHeight];
    [self.subtitleTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    
    [self setIsEmpty:NO];
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"What's new?"]) {
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
-(void)adjustTextViewFrame {
    CGRect textFrame = self.subtitleTextView.frame;
    textFrame.size.height = self.subtitleTextView.contentSize.height;
    self.subtitleTextView.frame = textFrame;
}

-(void)adjustCellHeight {
    [self.tableView beginUpdates];
    CGFloat paddingForTextView;
    if (self.eventImageView.image)
        paddingForTextView = 155;
    else
        paddingForTextView = 98; //Padding varies depending on your cell design
    
    self.height = self.subtitleTextView.contentSize.height + paddingForTextView;
    self.cellHeightLayoutConstraint.constant = self.height - 21;
    [self.tableView endUpdates];
}

#pragma mark - Setter's
-(void)setPlaceholderOnTextView:(UITextView *)textView {
    [textView setText:@"What's new?"];
    [textView setTextColor:[UIColor colorWithRed:169/255.0
                                           green:169/255.0
                                            blue:169/255.0
                                           alpha:1]];
}

-(void)setEmpty {
    [self setIsEmpty:YES];
    [self.tableView endEditing:YES];
    //[self.eventCategoryKeyboard hideAnimated:YES];
    
    [self.eventCategoryButton setImage:[UIImage imageNamed:@"marker"] forState:UIControlStateNormal];
    [self.eventImageView setImage:nil];
    self.eventImageViewHeighLayoutConstraint.constant = 2;
    [self setPlaceholderOnTextView:self.subtitleTextView];
    [self adjustCellHeight];
}


@end
