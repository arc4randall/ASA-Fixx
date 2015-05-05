//
//  Reminder.h
//  Fixx2.0
//
//  Created by Randall Spence on 5/5/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder : NSObject
@property (strong,nonatomic) NSString* name;
@property (weak,nonatomic) NSNumber* days;
@property (strong,nonatomic) NSDate* startDate;
@property (strong,nonatomic) NSDate* endDate;
@end
