//
//  ControlView.h
//  AutolayoutXib
//
//  Created by Marcel  on 5/26/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostEventView : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *subtitleTextView;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) NSString* name;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventImageViewHeighLayoutConstraint;

@property (weak, nonatomic) IBOutlet UIButton *eventCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *eventCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@end
