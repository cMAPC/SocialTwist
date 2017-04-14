//
//  EventContent.h
//  SocialTwist
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface EventContent : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* subtitle;
@property (assign, nonatomic) NSInteger eventCategory;

@property (strong, nonatomic) UIImage* eventImage;
@property (strong, nonatomic) UIImage* profileImage;

@property (assign, nonatomic) CLLocationCoordinate2D eventCoordinate;

@property (strong, nonatomic) NSMutableArray* eventsArray;

+(EventContent *)sharedEventContent;

-(void)getEvents;
-(void)addNewEventWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinates:(CLLocationCoordinate2D)coordinates
              eventCategory:(NSUInteger)category profileImage:(UIImage *)profileImage eventImage:(UIImage *)eventImage;

@end
