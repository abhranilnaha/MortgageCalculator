//
//  CalculationViewController.h
//  MortgageCalculator
//
//  Created by anaha on 4/21/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculationViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIButton *propertyType;
@property (weak, nonatomic) IBOutlet UITextView *streetAddress;
@property (weak, nonatomic) IBOutlet UITextField *cityName;
@property (weak, nonatomic) IBOutlet UIPickerView *statePicker;
@property (weak, nonatomic) IBOutlet UITextField *zipCode;
@property (weak, nonatomic) IBOutlet UITextField *loanAmount;
@property (weak, nonatomic) IBOutlet UITextField *downPayment;
@property (weak, nonatomic) IBOutlet UITextField *annualRate;
@property (weak, nonatomic) IBOutlet UITextField *payYear;
@property (weak, nonatomic) IBOutlet UILabel *monthlyPayment;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)createMortgage:(id)sender;

- (IBAction)saveMortgage:(id)sender;

- (IBAction)showPropertyType:(id)sender;

- (IBAction)calculateMortgage:(id)sender;

@end
