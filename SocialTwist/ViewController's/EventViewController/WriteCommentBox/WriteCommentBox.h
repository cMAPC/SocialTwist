//
//  WriteCommentBox.h
//  SocialTwist
//
//  Created by Marcel  on 7/3/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteCommentBox : UIView <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *writeCommentBoxView;
@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;
@property (weak, nonatomic) IBOutlet UITextView *writeCommentTextView;

-(void)setPlaceholderOnTextView:(UITextView *)textView;

@end
