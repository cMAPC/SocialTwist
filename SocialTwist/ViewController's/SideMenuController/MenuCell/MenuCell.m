//
//  MenuCell.m
//  SocialTwist
//

#import "MenuCell.h"

@implementation MenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor* countViewColor = self.countView.backgroundColor;
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.countView.backgroundColor = countViewColor;
    }
    
    UIView* selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:134.0/255 green:138.0/255 blue:165.0/255 alpha:1]];
    [self setSelectedBackgroundView:selectedBackgroundView];
}

@end
