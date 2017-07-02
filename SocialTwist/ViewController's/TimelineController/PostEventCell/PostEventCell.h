//
//  PostEventCell.h
//  SocialTwist
//

#import <UIKit/UIKit.h>
#import "TimelineTableController.h"
#import "KeyboardViewController.h"

@interface PostEventCell : UITableViewCell <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, KeyboardControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *subtitleTextView;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UIButton *eventCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *eventCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventImageViewHeighLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeightLayoutConstraint;

@property (weak, nonatomic) UITableView* tableView;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) BOOL isEmpty;

-(void)setEmpty;

@end
