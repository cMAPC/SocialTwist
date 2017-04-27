//
//  EventContent.m
//  SocialTwist
//

#import "EventContent.h"

@implementation EventContent

+(EventContent *)sharedEventContent {
    static EventContent* eventContent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventContent = [[EventContent alloc] init];
    });
    return eventContent;
}


-(void)getEvents{
    [EventContent sharedEventContent].eventsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        EventContent* event = [[EventContent alloc] init];
        [event setTitle:@"Title"];
        [event setSubtitle:[NSString stringWithFormat:@"\rSunset in Rome is Wonderful %d\r", i]];
        [event setEventImage:[UIImage imageNamed:@"imageRight"]];
        [event setProfileImage:[UIImage imageNamed:@"imageLeft"]];
        [[EventContent sharedEventContent].eventsArray addObject:event];
    }
}

-(void)addNewEventWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinates:(CLLocationCoordinate2D)coordinates
              eventCategory:(NSUInteger)category profileImage:(UIImage *)profileImage eventImage:(UIImage *)eventImage {
    if (eventImage == nil) {
        NSLog(@"Image is nil");
    }
    EventContent* newEvent = [[EventContent alloc] init];
    [newEvent setTitle:title];
    if (subtitle.length > 0 && ![subtitle isEqualToString:@"What's new?"]) {
        [newEvent setSubtitle:[NSString stringWithFormat:@"\r%@\r", subtitle]];
    } else {
        [newEvent setSubtitle:@""];
    }
    [newEvent setEventCoordinate:coordinates];
    [newEvent setEventCategory:category];
    [newEvent setProfileImage:profileImage];
    [newEvent setEventImage:eventImage];
    [[EventContent sharedEventContent].eventsArray insertObject:newEvent atIndex:0];
}

@end
