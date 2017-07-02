//
//  GalleryViewController.m
//  SocialTwist
//
//  Created by Vadim on 6/14/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "GalleryViewController.h"
#import "ImageCollectionViewCell.h"
#import "BIZGrid4plus1CollectionViewLayout.h"
#import "Photos.h"
#import "PhotoSliderViewController.h"
@interface GalleryViewController ()

@end

@implementation GalleryViewController
{
    NSInteger photoIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView reloadData];
    
    [self setPhotos:@[[Photos photoWithProperties:@{@"imageFile":@"cat.jpg"}],
                      [Photos photoWithProperties:@{@"imageFile":@"imageLeft.png"}],
                      [Photos photoWithProperties:@{@"imageFile":@"imageRight.png"}],
                      [Photos photoWithProperties:@{@"imageFile":@"imageRoot.png"}],
                      [Photos photoWithProperties:@{@"imageFile":@"cat.jpg"}],
                      [Photos photoWithProperties:@{@"imageFile":@"cat.jpg"}],
                      [Photos photoWithProperties:@{@"imageFile":@"cat.jpg"}],]];
    self.photosArray = [[NSMutableArray alloc]init];
     [self.photosArray addObjectsFromArray:@[@"cat.jpg",@"imageRight.png",@"imageLeft.png",@"cat.jpg",@"cat.jpg",@"imageRight.png",@"imageLeft.png"]];
 
    }

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photosArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ImageCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
//    Photos *photos = [self.photos objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_photosArray[indexPath.row]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoSliderViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoSliderViewController"];
    vc.images = [[NSMutableArray alloc]init];
    vc.images = [self.photosArray mutableCopy];
    vc.indexpath = indexPath.row;    
    [self.navigationController pushViewController:vc animated:YES];
    
//    EBPhotoPagesController *photoPagesController = [[EBPhotoPagesController alloc]initWithDataSource:self photoAtIndex:indexPath.row];
//    [self presentViewController:photoPagesController animated:YES completion:nil];
    
}

@end
