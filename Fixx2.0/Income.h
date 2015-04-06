//
//  Income.h
//  Fixx2.0
//
//  Created by Randall Spence on 3/2/15.
//  Copyright (c) RDSpinz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Income : NSObject
@property int incomeID;
@property (nonatomic,strong) NSString* name;
@property double amount;
@property (nonatomic,strong) NSString* duration;

-(id)initWithName:(NSString*)itemName andAmount:(double)itemAmount andDuration:(NSString*)timeFrame;
@end
