//
//  TimelineCellController.h
//  TableViewDynamicSize
//

#import <UIKit/UIKit.h>

@interface TimelineCellController : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *label;


@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;

@property (assign, nonatomic) NSInteger likeCount;
@property (assign, nonatomic) NSInteger dislikeCount;

@end
