//
//  DBManager.h
//  MortgageCalculator
//
//  Created by anaha on 4/25/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
-(BOOL) createData:(NSString*)propertyType address:(NSString*)address city:(NSString*)city state:(NSString*)state zipCode:(NSString*)zipCode
      loanAmount:(int)loanAmount downPayment:(int)downPayment annualRate:(double)annualRate payYear:(int)payYear mortgageAmount:(NSString*)mortgageAmount;
-(BOOL) updateData:(int)id propertType:(NSString*)propertyType address:(NSString*)address city:(NSString*)city state:(NSString*)state zipCode:(NSString*)zipCode loanAmount:(int)loanAmount downPayment:(int)downPayment annualRate:(double)annualRate payYear:(int)payYear mortgageAmount:(NSString*)mortgageAmount;
-(BOOL) deleteData:(int)id;
-(NSArray*) getData;

@end
