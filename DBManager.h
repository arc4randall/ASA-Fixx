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
-(BOOL)createDB;
-(BOOL) saveDataWithName:(NSString*)name Amount:(double)amount Duration:(NSString*)duration;
-(NSMutableArray *)getAllIncome;
-(NSMutableArray *)getAllExpense;
-(BOOL) updateByID:(Income *) incomeObj;
-(BOOL) deleteByID: (Income *) incomeObj;
@end