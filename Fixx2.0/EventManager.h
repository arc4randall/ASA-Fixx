//
//  EventManager.h
//  Fixx2.0
//
//  Created by Randall Spence on 5/5/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventManager : NSObject
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;
@end
