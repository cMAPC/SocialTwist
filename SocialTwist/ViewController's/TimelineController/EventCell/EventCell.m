//
//  TimelineCellController.m
//  TableViewDynamicSize
//

#import "EventCell.h"

@implementation EventCell {
    //    NSUInteger correctedHeight;
}

static void *LikeButtonContext = &LikeButtonContext;
static void *DislikeButtonContext = &DislikeButtonContext;
static void *NameLabelContext = &NameLabelContext;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.nameLabel addObserver:self
                     forKeyPath:@"text"
                        options:NSKeyValueObservingOptionNew
                        context:NameLabelContext];
    
    [self.likeButton.titleLabel addObserver:self
                                 forKeyPath:@"text"
                                    options:NSKeyValueObservingOptionNew
                                    context:LikeButtonContext];
    
    [self.dislikeButton.titleLabel addObserver:self
                                    forKeyPath:@"text"
                                       options:NSKeyValueObservingOptionNew
                                       context:DislikeButtonContext];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
//-(void)layoutSubviews {
//    [super layoutSubviews];
//    [self.contentView layoutIfNeeded];
//}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == NameLabelContext) {
        [self adjustNameLabelStringFormat];
    }
    if (context == LikeButtonContext) {
        [self adjustLikeButtonStringFormat];
    }
    if (context == DislikeButtonContext) {
        [self adjustDislikeButtonStringFormat];
    }
}

#pragma mark - Adjustments
-(void)adjustLikeButtonStringFormat {
    [self.likeButton setImage:[UIImage imageNamed:@"like-icon-higtlighted"]
                     forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor colorWithRed:(155/255.0) green:186/255.0 blue:205/255.0 alpha:1.0]
                          forState:UIControlStateNormal];
}

-(void)adjustDislikeButtonStringFormat {
    [self.dislikeButton setImage:[UIImage imageNamed:@"dislike-icon-hightlighted"]
                        forState:UIControlStateNormal];
    [self.dislikeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

-(void)adjustLikeButtonDefaultStringFormat {
    [self.likeButton setImage:[UIImage imageNamed:@"like-icon"]
                     forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
}

-(void)adjustDislikeButtonDefaultStringFormat {
    [self.dislikeButton setImage:[UIImage imageNamed:@"dislike-icon"]
                        forState:UIControlStateNormal];
    [self.dislikeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)adjustNameLabelStringFormat {
    
    NSString* name = self.nameLabel.text;
    NSString* at = @"at";
    NSString* place = @"Chisinau";
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]
                                                          initWithString:[NSString stringWithFormat:@"%@ %@    %@",name,at,place]];
    
    NSTextAttachment* textAttachment = [[NSTextAttachment alloc] init];
    [textAttachment setImage:[UIImage imageNamed:@"pin"]];
    
    CGFloat scaleFactor = textAttachment.image.size.height / 9;
    textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage
                                               scale:scaleFactor orientation:UIImageOrientationUp];
    
    
    [mutableAttributedString beginEditing];
    
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont boldSystemFontOfSize:13]
                                    range:NSMakeRange(0,name.length)];
    
    
    NSDictionary *atAtributeDictionary = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],
                                            NSForegroundColorAttributeName:[UIColor colorWithRed:(169/255.0)
                                                                                           green:(169/255.0)
                                                                                            blue:(169/255.0)
                                                                                           alpha:1]
                                            };
    [mutableAttributedString addAttributes:atAtributeDictionary
                                     range:NSMakeRange(name.length+1,at.length)];
    
    
    NSDictionary *placeAtributeDictionary = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                               NSForegroundColorAttributeName:[UIColor colorWithRed:(155/255.0)
                                                                                              green:(186/255.0)
                                                                                               blue:(205/255.0)
                                                                                              alpha:1]
                                               };
    
    [mutableAttributedString addAttributes:placeAtributeDictionary
                                     range:NSMakeRange(name.length + 7, place.length)];
    
    [mutableAttributedString endEditing];
    
    
    NSAttributedString* attributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(name.length + 5, 1)
                                 withAttributedString:attributedString];
    
    self.nameLabel.attributedText = mutableAttributedString;
}


-(void)updateConstraints {
//[self adjustEventImageViewHeight];
    [super updateConstraints];
//        [self adjustEventImageViewHeight];
}

-(void)adjustEventImageViewHeight {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSLog(@"Witdh %f", width);
//    [self.eventImageView removeConstraint: self.eventImageView.constraints.lastObject];
    CGFloat correctedHeight = ((width - 40)/ self.eventImageView.image.size.width * self.eventImageView.image.size.height);
//    NSLog(@"corrected Height %f", correctedHeight);
    if (self.eventImageView.image != nil) {
        
        
        [self.eventImageView removeConstraint:_evetImageViewHeightConstraint];
        
        [self.eventImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.eventImageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:[NSNumber numberWithFloat:correctedHeight].integerValue]];
        
        self.eventImageView.translatesAutoresizingMaskIntoConstraints=false;
//        [self.eventImageView removeConstraint: self.eventImageView.constraints.lastObject];
//        self.evetImageViewHeightConstraint.constant = correctedHeight;
//        [self layoutSubviews];
    }
    else
    {
//                [self.eventImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.eventImageView
//                                                                           attribute:NSLayoutAttributeHeight
//                                                                           relatedBy:NSLayoutRelationEqual
//                                                                              toItem:nil
//                                                                           attribute:NSLayoutAttributeNotAnAttribute
//                                                                          multiplier:1.0
//                                                                            constant:1.0]];
    }
    
    
    /*
     CGFloat width = [UIScreen mainScreen].bounds.size.width;
     //    [self.cellImage removeConstraint: self.cellImage.constraints.lastObject];
     if (self.cellImage.image != nil) {
     correctedHeight = (width - 40)/ self.cellImage.image.size.width * self.cellImage.image.size.height;
     if(self.cellImage.image.size.width >= width) {
     
     [self.cellImage setTranslatesAutoresizingMaskIntoConstraints:NO];
     //            [cell.cellImage removeConstraint: cell.cellImage.constraints.lastObject];
     [self.cellImage addConstraint:[NSLayoutConstraint constraintWithItem:self.cellImage
     attribute:NSLayoutAttributeHeight
     relatedBy:NSLayoutRelationEqual
     toItem:nil
     attribute:NSLayoutAttributeNotAnAttribute
     multiplier:1.0
     constant:correctedHeight]];
     }
     }
     
     else {
     //        [self.cellImage addConstraint:[NSLayoutConstraint constraintWithItem:self.cellImage
     //                                                                   attribute:NSLayoutAttributeHeight
     //                                                                   relatedBy:NSLayoutRelationEqual
     //                                                                      toItem:nil
     //                                                                   attribute:NSLayoutAttributeNotAnAttribute
     //                                                                  multiplier:1.0
     //                                                                    constant:0]];
     }
     */

}

-(void)dealloc {
    [self.nameLabel removeObserver:self forKeyPath:@"text"];
    [self.likeButton.titleLabel removeObserver:self forKeyPath:@"text"];
    [self.dislikeButton.titleLabel removeObserver:self forKeyPath:@"text"];
}

@end
