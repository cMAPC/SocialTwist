//
//  ImageCollectionViewCell.h
//  SocialTwist
//
//  Created by Vadim on 6/14/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell
+ (NSString *)reuseIdentifier;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
