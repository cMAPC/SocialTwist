//
//  MenuCell.h
//  SocialTwist
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemTextLabel;

@property (weak, nonatomic) IBOutlet UIView *countView;

@end
