//
//  PopoverViewController.h
//  MortgageCalculator
//
//  Created by loaner on 5/9/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mortgage.h"

@interface PopoverViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *propertyType;
@property (weak, nonatomic) IBOutlet UITextView *streetAddress;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *loanAmount;
@property (weak, nonatomic) IBOutlet UITextField *apr;
@property (weak, nonatomic) IBOutlet UITextField *monthlyPayment;
@property (nonatomic,retain) Mortgage *mortgage;
- (IBAction)deleteMortgage:(id)sender;
- (IBAction)editMortgage:(id)sender;

@end
