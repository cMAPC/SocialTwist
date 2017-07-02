//
//  GalleryViewController.h
//  SocialTwist
//
//  Created by Vadim on 6/14/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong) NSArray *photos;
@property (strong) NSMutableArray *photosArray;
@end
