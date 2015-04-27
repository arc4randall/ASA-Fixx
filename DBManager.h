//
//  DBManager.h
//  Fixx2.0
//
//  Created by Randall Spence on 3/26/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Income.h"
@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL createDB;
-(BOOL) saveDataWithName:(NSString*)name Amount:(double)amount Duration:(NSString*)duration  Category:(NSString*)category;
@property (NS_NONATOMIC_IOSONLY, getter=getAllIncome, readonly, copy) NSMutableArray *allIncome;
@property (NS_NONATOMIC_IOSONLY, getter=getAllExpense, readonly, copy) NSMutableArray *allExpense;
-(BOOL) updateByID:(Income *) incomeObj;
-(BOOL) deleteByID: (Income *) incomeObj;
-(NSMutableDictionary*)returnAllByType: (NSString *) type;
@end