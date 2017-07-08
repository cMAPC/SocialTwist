//
//  TableViewCell.h
//  MapModule
//


#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIView *imageBorderView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
