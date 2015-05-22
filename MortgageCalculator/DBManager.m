//
//  DBManager.m
//  MortgageCalculator
//
//  Created by anaha on 4/25/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB {
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent: @"mortgage"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "create table if not exists mortgageDetail (id integer primary key, propertyType text, address text, city text, state text, zipCode text, loanAmount integer, downPayment integer, propertyValue integer, annualRate float, payYear integer, mortgageAmount text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        } else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) createData:(NSString*)propertyType address:(NSString*)address city:(NSString*)city state:(NSString*)state zipCode:(NSString*)zipCode loanAmount:(int)loanAmount downPayment:(int)downPayment propertyValue:(int)propertyValue annualRate:(double)annualRate payYear:(int)payYear mortgageAmount:(NSString*)mortgageAmount {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into mortgageDetail (propertyType, address, city, state, zipCode, loanAmount, downPayment, propertyValue, annualRate, payYear, mortgageAmount) values (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\",\"%d\", \"%d\", \"%d\", \"%f\", \"%d\", \"%@\")", propertyType, address, city, state, zipCode, loanAmount, downPayment, propertyValue, annualRate, payYear, mortgageAmount];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_reset(statement);
            return YES;
        } else {
            sqlite3_reset(statement);
            return NO;
        }
    }
    return NO;
}

- (BOOL) updateData:(int)id propertyType:(NSString*)propertyType address:(NSString*)address city:(NSString*)city state:(NSString*)state zipCode:(NSString*)zipCode loanAmount:(int)loanAmount downPayment:(int)downPayment propertyValue:(int)propertyValue annualRate:(double)annualRate payYear:(int)payYear mortgageAmount:(NSString*)mortgageAmount {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *updateSQL = [NSString stringWithFormat:@"update mortgageDetail set propertyType = \"%@\", address = \"%@\", city = \"%@\", state = \"%@\", zipCode = \"%@\", loanAmount = \"%d\", propertyValue = \"%d\", downPayment = \"%d\", annualRate = \"%f\", payYear = \"%d\", mortgageAmount = \"%@\" where id = \"%d\"", propertyType, address, city, state, zipCode, loanAmount, downPayment, propertyValue, annualRate, payYear, mortgageAmount, id];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_reset(statement);
            return YES;
        } else {
            sqlite3_reset(statement);
            return NO;
        }
    }
    return NO;
}

-(BOOL) deleteData:(int)id
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from mortgageDetail where id = \"%d\"", id];
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(database, delete_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_reset(statement);
            return YES;
        } else {
            sqlite3_reset(statement);
            return NO;
        }
    }
    return NO;
}

- (NSArray*) getData {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select id, propertyType, address, city, state, zipCode, loanAmount, downPayment, propertyValue, annualRate, payYear, mortgageAmount from mortgageDetail"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *resultDictionary=[[NSMutableDictionary alloc] init];
                
                NSNumber *id = [NSNumber numberWithInt:(int)sqlite3_column_int(statement, 0)];
                [resultDictionary setObject:id forKey:@"id"];
                NSString *propertyType = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 1)];
                [resultDictionary setObject:propertyType forKey:@"propertyType"];
                NSString *address = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 2)];
                [resultDictionary setObject:address forKey:@"address"];
                NSString *city = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 3)];
                [resultDictionary setObject:city forKey:@"city"];
                NSString *state = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 4)];
                [resultDictionary setObject:state forKey:@"state"];
                NSString *zipCode = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 5)];
                [resultDictionary setObject:zipCode forKey:@"zipCode"];
                NSNumber *loanAmount = [NSNumber numberWithInt:(int)sqlite3_column_int(statement, 6)];
                [resultDictionary setObject:loanAmount forKey:@"loanAmount"];
                NSNumber *downPayment = [NSNumber numberWithInt:(int)sqlite3_column_int(statement, 7)];
                [resultDictionary setObject:downPayment forKey:@"downPayment"];
                NSNumber *propertyValue = [NSNumber numberWithInt:(int)sqlite3_column_int(statement, 8)];
                [resultDictionary setObject:propertyValue forKey:@"propertyValue"];
                NSNumber *annualRate = [NSNumber numberWithFloat:(double)sqlite3_column_double(statement, 9)];
                [resultDictionary setObject:annualRate forKey:@"annualRate"];
                NSNumber *payYear = [NSNumber numberWithFloat:(int)sqlite3_column_int(statement, 10)];
                [resultDictionary setObject:payYear forKey:@"payYear"];
                NSString *mortgageAmount = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 11)];
                [resultDictionary setObject:mortgageAmount forKey:@"mortgageAmount"];
                
                [resultArray addObject:resultDictionary];
            }
        } else {
            NSLog(@"No Data Found");
        }
        sqlite3_reset(statement);
        return resultArray;
    }
    return nil;
}
@end
