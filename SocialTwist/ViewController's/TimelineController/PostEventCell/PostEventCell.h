//
//  PostEventCell.h
//  SocialTwist
//

#import <UIKit/UIKit.h>
#import "TimelineTableController.h"

@interface PostEventCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *subtitleTextView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *eventCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *eventCameraButton;
@property (weak, nonatomic) IBOutlet UIImageView *eventImag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventImageViewHeighLayoutConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTextViewConstraint;

@end
