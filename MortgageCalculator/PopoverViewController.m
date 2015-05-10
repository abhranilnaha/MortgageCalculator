//
//  PopoverViewController.m
//  MortgageCalculator
//
//  Created by loaner on 5/9/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "PopoverViewController.h"
#import "CalculationViewController.h"

@interface PopoverViewController ()

@end

@implementation PopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.streetAddress.layer.borderWidth = 0.5f;
    self.streetAddress.layer.cornerRadius = 10;
    self.streetAddress.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [self.propertyType setText:self.mortgage.propertyType];
    [self.streetAddress setText:self.mortgage.streetAddress];
    [self.city setText:self.mortgage.cityName];
    [self.loanAmount setText:[self.mortgage.loanAmount stringValue]];
    [self.apr setText:[self.mortgage.annualRate stringValue]];
    [self.monthlyPayment setText:self.mortgage.mortgageAmount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
