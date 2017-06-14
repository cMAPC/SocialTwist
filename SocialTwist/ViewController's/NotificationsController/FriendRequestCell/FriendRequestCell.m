//
//  FriendRequestCell.m
//  SocialTwist
//
//  Created by Marcel  on 6/8/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "FriendRequestCell.h"

@implementation FriendRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.nameLabel addObserver:self
                     forKeyPath:@"text"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqual:@"text"]) {
        [self adjustStringFormat];
    }
}

#pragma mark - Adjustments
-(void)adjustStringFormat {
    NSString* name = self.nameLabel.text;
    NSString* place = @"sent you a friend request";
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]
                                                          initWithString:[NSString stringWithFormat:@"%@ %@",name,place]];
    
    [mutableAttributedString beginEditing];
    
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont boldSystemFontOfSize:13]
                                    range:NSMakeRange(0,name.length)];
    
    NSDictionary *placeAtributeDictionary = @{ NSFontAttributeName:[UIFont systemFontOfSize:13] };
    
    [mutableAttributedString addAttributes:placeAtributeDictionary
                                     range:NSMakeRange(name.length, place.length)];
    
    [mutableAttributedString endEditing];
    
    self.nameLabel.attributedText = mutableAttributedString;
}


@end
