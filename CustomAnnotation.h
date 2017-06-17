//
//  CustomAnnotation.h
//  SocialTwist
//
//  Created by Marcel  on 5/2/17.
//  Copyright © 2017 Marcel . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "UserData.h"

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* subtitle;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@property (strong, nonatomic) NSString* image;
@property (assign, nonatomic) NSInteger eventCategory;

-(id)initWithTitle:(NSString *)title location:(CLLocationCoordinate2D)location;
-(MKAnnotationView *)annotationView;

@property (strong, nonatomic) UIImage* pinImage;

@end
