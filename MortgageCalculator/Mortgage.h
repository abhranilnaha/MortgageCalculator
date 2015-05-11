//
//  Mortgage.h
//  MortgageCalculator
//
//  Created by loaner on 5/10/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Mortgage : NSObject

@property NSNumber *id;
@property NSString *propertyType;
@property NSString *streetAddress;
@property NSString *cityName;
@property NSString *stateName;
@property NSString *zipCode;
@property NSNumber *loanAmount;
@property NSNumber *downPayment;
@property NSNumber *annualRate;
@property NSNumber *payYear;
@property NSString *mortgageAmount;
@property CLLocationCoordinate2D coordinate;

@end
