//
//  CustomAnnotation.h
//  SocialTwist
//
//  Created by Marcel  on 5/2/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* image;

-(id)initWithTitle:(NSString *)title location:(CLLocationCoordinate2D)location;
-(MKAnnotationView *)annotationView;

@end
