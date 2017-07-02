//
//  TimelineCellController.h
//  TableViewDynamicSize
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;

-(void)adjustLikeButtonStringFormat;
-(void)adjustDislikeButtonStringFormat;
-(void)adjustLikeButtonDefaultStringFormat;
-(void)adjustDislikeButtonDefaultStringFormat;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evetImageViewHeightConstraint;

-(void)adjustEventImageViewHeight;

@end
