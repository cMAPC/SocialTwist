//
//  CustomAnnotation.m
//  SocialTwist
//
//  Created by Marcel  on 5/2/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import "CustomAnnotation.h"


@implementation CustomAnnotation

- (id)initWithTitle:(NSString *)title location:(CLLocationCoordinate2D)location
{
    self = [super init];
    if (self) {
        _title = title;
        _coordinate = location;
    }
    return self;
}

-(MKAnnotationView *)annotationView {
    
    MKAnnotationView* annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.image = nil;
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
//    annotationView.image = [UIImage imageNamed:self.image];
    
//    annotationView.image = self.pinImage;
//    [annotationView.superview addSubview:self.pinView];
    
    return annotationView;
}

@end
