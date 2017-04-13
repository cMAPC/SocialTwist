//
//  EventContent.m
//  SocialTwist
//

#import "EventContent.h"

@implementation EventContent

-(void)getEvents{
    self.eventsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        EventContent* event = [[EventContent alloc] init];
        [event setTitle:@"Title"];
        [event setSubtitle:[NSString stringWithFormat:@"\rSunset in Rome is Wonderful %d\r", i]];
        [event setEventImage:[UIImage imageNamed:@"imageRight"]];
        [event setProfileImage:[UIImage imageNamed:@"imageLeft"]];
        [self.eventsArray addObject:event];
    }
}

-(void)addNewEventWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinates:(CLLocationCoordinate2D)coordinates
              eventCategory:(NSUInteger)category profileImage:(UIImage *)profileImage eventImage:(UIImage *)eventImage {
    EventContent* newEvent = [[EventContent alloc] init];
    [newEvent setTitle:title];
    [newEvent setSubtitle:[NSString stringWithFormat:@"\r%@\r", subtitle]];
    [newEvent setEventCoordinate:coordinates];
    [newEvent setEventCategory:category];
    [newEvent setProfileImage:profileImage];
    [newEvent setEventImage:eventImage];
    [self.eventsArray insertObject:newEvent atIndex:0];
}

@end
