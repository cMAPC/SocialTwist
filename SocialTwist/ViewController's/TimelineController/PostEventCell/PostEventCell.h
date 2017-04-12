//
//  PostEventCell.h
//  SocialTwist
//

#import <UIKit/UIKit.h>
#import "TimelineTableController.h"

@interface PostEventCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *subtitleTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTextViewConstraint;

@end
