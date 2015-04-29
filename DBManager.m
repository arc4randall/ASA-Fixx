//
//  DBManager.m
//  Fixx2.0
//
//  Created by Randall Spence on 3/26/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import "DBManager.h"
#import "Income.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"ASAFixxDB.sqlite"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt ="create table if not exists IncomeDataTable (ID integer primary key AUTOINCREMENT  NOT NULL  UNIQUE, Name text, Amount double, Duration text, Category text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

-(BOOL) saveDataWithName:(NSString*)name Amount:(double)amount Duration:(NSString*)duration Category:(NSString*)category
{
    const char *dbpath = [databasePath UTF8String];
    const char *errorMsg;
    BOOL toReturn = NO;
    NSString *insertSQL;
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        if (amount > 0) {
            insertSQL = [NSString stringWithFormat:@"INSERT INTO IncomeDataTable(Name, Amount, Duration, Category) SELECT \"%@\", \"%f\", \"%@\", \"%@\" WHERE NOT EXISTS(SELECT * FROM IncomeDataTable WHERE Name = \"%@\" AND Amount > 0)", name, amount, duration, category, name];
        } else {
            insertSQL = [NSString stringWithFormat:@"INSERT INTO IncomeDataTable(Name, Amount, Duration, Category) SELECT \"%@\", \"%f\", \"%@\", \"%@\" WHERE NOT EXISTS(SELECT * FROM IncomeDataTable WHERE Name = \"%@\" AND Amount < 0)", name, amount, duration, category, name];
        }
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, &errorMsg);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            int rowAffected = sqlite3_changes(database);
            if (rowAffected > 0) {
                toReturn = YES;
            }
        }
        else {
            NSLog(@"saveData Error: %s", errorMsg);
            
        }
    }
    sqlite3_reset(statement);
    return toReturn;
}

-(NSMutableArray *)getAllIncome {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from IncomeDataTable where Amount > 0"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [resultArray addObject:[self getAnIncomeFromDB]];
            }
            sqlite3_reset(statement);
            return resultArray;
        }
    }
    return nil;
}

-(NSMutableArray *)getAllExpense {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from IncomeDataTable where Amount < 0"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [resultArray addObject:[self getAnIncomeFromDB]];
            }
            sqlite3_reset(statement);
            
            return resultArray;
        }
    }
    return nil;
}

-(BOOL)updateByID:(Income *) incomeObj
{
    const char *dbpath = [databasePath UTF8String];
    BOOL toReturn = NO;
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"update  from IncomeDataTable where ID=\"%d\"", pkey];
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE IncomeDataTable SET Name = \"%@\", Amount = %0.2f, Duration = \"%@\", Category = \"%@\" WHERE ID = \"%d\";", incomeObj.name, incomeObj.amount, incomeObj.duration, incomeObj.category, incomeObj.incomeID];
        const char *query_stmt = [updateSQL UTF8String];
        char * errMsg;
        
        if (sqlite3_exec(database, query_stmt ,NULL,NULL,&errMsg) == SQLITE_OK) {
            toReturn = YES;
            NSLog(@"row number updated = %d", sqlite3_changes(database));
        }
        else{
            NSLog(@"Failed to update record, msg=%s", errMsg);
        }
    }
    sqlite3_reset(statement);
    return toReturn;
}

-(BOOL)deleteByID: (Income *) incomeObj{
    const char *dbpath = [databasePath UTF8String];
    BOOL toReturn = NO;
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSLog(@"THE ID: %d",incomeObj.incomeID);
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE From IncomeDataTable where ID = \"%d\"", incomeObj.incomeID];
        NSLog(@"UPDATE: %@",updateSQL);
        const char *query_stmt = [updateSQL UTF8String];
        char * errMsg;
        
        if (sqlite3_exec(database, query_stmt ,NULL,NULL,&errMsg) == SQLITE_OK) {
            toReturn = YES;
        }
        else{
            NSLog(@"Failed to update record, msg=%s", errMsg);
        }
    }
    sqlite3_reset(statement);
    return toReturn;
}
-(NSMutableDictionary *)returnAllByType: (NSString *) type {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL;
        if ([type isEqualToString:@"income"]) {
            querySQL= [NSString stringWithFormat:@"select * from IncomeDataTable where Amount > 0 ORDER by Category DESC"];
        } else if([type isEqualToString:@"expense"]){
            querySQL= [NSString stringWithFormat:@"select * from IncomeDataTable where Amount < 0 ORDER by Category DESC"];
        }
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                Income *income = [self getAnIncomeFromDB];
                NSMutableArray *itemsArray = [dictionary objectForKey:income.category];
                if (!itemsArray){
                    itemsArray = [[NSMutableArray alloc]init];
                }
                [itemsArray addObject:income];
                [dictionary setObject:itemsArray forKey:income.category];
            }
        }
    }
    sqlite3_reset(statement);
    return dictionary;
}
-(Income *)getAnIncomeFromDB {
    Income *income = [[Income alloc] init];
    income.incomeID = [[[NSString alloc] initWithUTF8String:
                        (const char *) sqlite3_column_text(statement, 0)] intValue];
    income.name = [[NSString alloc] initWithUTF8String:
                   (const char *) sqlite3_column_text(statement, 1)];
    income.amount = [[[NSString alloc] initWithUTF8String:
                      (const char *) sqlite3_column_text(statement, 2)] doubleValue];
    income.duration = [[NSString alloc]initWithUTF8String:
                       (const char *) sqlite3_column_text(statement, 3)];
    income.category =[[NSString alloc]initWithUTF8String:
                      (const char *) sqlite3_column_text(statement, 4)];
    return income;
}
@end