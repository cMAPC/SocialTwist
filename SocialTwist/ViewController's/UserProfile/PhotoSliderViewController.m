//
//  PhotoSliderViewController.m
//  SocialTwist
//
//  Created by Vadim on 6/15/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "PhotoSliderViewController.h"

#define VIEW_FOR_ZOOM_TAG (1)
#define VIEW_FOR_ZOOM_TAG (1)


@interface PhotoSliderViewController ()

@end

@implementation PhotoSliderViewController
{
    UIImageView * _imageView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
#pragma Works
 
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    CGRect innerScrollFrame = self.scrollView.bounds;

    
    for (NSInteger i = 0; i < _images.count; i++) {
        
      _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.images[i]]];
        ;
        _imageView.tag = VIEW_FOR_ZOOM_TAG;
        
        UIScrollView *pageScrollView = [[UIScrollView alloc] initWithFrame:innerScrollFrame];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        _imageView.frame = CGRectMake(0,0
                                           
                                           , self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        pageScrollView.minimumZoomScale = 1.0f;
        pageScrollView.maximumZoomScale = 2.0f;
        pageScrollView.zoomScale = 1.0f;
        pageScrollView.contentSize = _imageView.frame.size;
        pageScrollView.delegate = self;
        pageScrollView.scrollEnabled = NO;
        pageScrollView.showsHorizontalScrollIndicator = NO;
        pageScrollView.showsVerticalScrollIndicator = NO;
        [pageScrollView addSubview:_imageView];
        
        [self.scrollView addSubview:pageScrollView];
        
        if (i < _images.count-1) {
            innerScrollFrame.origin.x += innerScrollFrame.size.width;
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(innerScrollFrame.origin.x + innerScrollFrame.size.width, self.scrollView.bounds.size.height);
    
}

//
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
//    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
//    
//    _drawingView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
//                                      scrollView.contentSize.height * 0.5 + offsetY);
//    
//    
//    return _drawingView;
//}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return [[self.scrollView.subviews firstObject]viewWithTag:VIEW_FOR_ZOOM_TAG];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"Did Scroll");

//    [self.scrollView setContentSize:CGSizeZero];
     [[self.scrollView.subviews firstObject] setContentSize:CGSizeZero];
 
    

}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
      UIView *subView = [scrollView.subviews objectAtIndex:0];
        
        CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
        CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
        
        subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                     scrollView.contentSize.height * 0.5 + offsetY);
}

@end
