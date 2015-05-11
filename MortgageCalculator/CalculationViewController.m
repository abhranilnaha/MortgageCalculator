//
//  CalculationViewController.m
//  MortgageCalculator
//
//  Created by anaha on 4/21/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "CalculationViewController.h"
#import "DBManager.h"

@interface CalculationViewController ()
{
    NSArray *statePickerData;
    int mortgageId;
}
@end

@implementation CalculationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(320, 800)];
    
    self.propertyType.layer.borderWidth = 0.5f;
    self.propertyType.layer.cornerRadius = 10;
    self.propertyType.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.streetAddress.layer.borderWidth = 0.5f;
    self.streetAddress.layer.cornerRadius = 10;
    self.streetAddress.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.monthlyPayment.layer.borderWidth = 0.5f;
    self.monthlyPayment.layer.cornerRadius = 10;
    self.monthlyPayment.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    // Initialize Data
    statePickerData = @[@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
    
    // Connect data
    self.statePicker.dataSource = self;
    self.statePicker.delegate = self;
    
    [self.cityName setText:@"Cupertino"];
    [self.statePicker selectRow:4 inComponent:0 animated:YES];
    [self.zipCode setText:@"95014"];
    [self.loanAmount setText:@"100000"];
    [self.downPayment setText:@"20000"];
    [self.payYear setText:@"30"];    
}

- (void)initWithMortgage:(Mortgage*)mortgage {
    mortgageId = [mortgage.id intValue];
    [self.propertyType setTitle:mortgage.propertyType forState:UIControlStateNormal];
    [self.streetAddress setText:mortgage.streetAddress];
    [self.cityName setText:mortgage.cityName];
    [self.statePicker selectRow:[statePickerData indexOfObject:mortgage.stateName] inComponent:0 animated:YES];
    [self.zipCode setText:mortgage.zipCode];
    [self.loanAmount setText:[mortgage.loanAmount stringValue]];
    [self.downPayment setText:[mortgage.downPayment stringValue]];
    [self.annualRate setText:[mortgage.annualRate stringValue]];
    [self.payYear setText:[mortgage.payYear stringValue]];
    [self.monthlyPayment setText:mortgage.mortgageAmount];
    
    [self.propertyType setUserInteractionEnabled:YES];
    [self.streetAddress setUserInteractionEnabled:YES];
    [self.cityName setEnabled:YES];
    [self.statePicker setUserInteractionEnabled:YES];
    [self.zipCode setEnabled:YES];
    [self.loanAmount setEnabled:YES];
    [self.downPayment setEnabled:YES];
    [self.annualRate setEnabled:YES];
    [self.payYear setEnabled:YES];
    [self.saveButton setEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"House"]) {
        [self.propertyType setTitle:@"House" forState:UIControlStateNormal];
    }
    if ([buttonTitle isEqualToString:@"Apartment"]) {
        [self.propertyType setTitle:@"Apartment" forState:UIControlStateNormal];
    }
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return statePickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return statePickerData[row];
}

- (IBAction)createMortgage:(id)sender {
    mortgageId = 0;
    [self.propertyType setTitle:@"House" forState:UIControlStateNormal];
    [self.streetAddress setText:@""];
    [self.cityName setText:@"Cupertino"];
    [self.statePicker selectRow:4 inComponent:0 animated:YES];
    [self.zipCode setText:@"95014"];
    [self.loanAmount setText:@"100000"];
    [self.downPayment setText:@"20000"];
    [self.annualRate setText:@""];
    [self.payYear setText:@"30"];
    [self.monthlyPayment setText:@""];
    
    [self.propertyType setUserInteractionEnabled:YES];
    [self.streetAddress setUserInteractionEnabled:YES];
    [self.cityName setEnabled:YES];
    [self.statePicker setUserInteractionEnabled:YES];
    [self.zipCode setEnabled:YES];
    [self.loanAmount setEnabled:YES];
    [self.downPayment setEnabled:YES];
    [self.annualRate setEnabled:YES];
    [self.payYear setEnabled:YES];
    [self.saveButton setEnabled:YES];
}

- (IBAction)saveMortgage:(id)sender {
    if (![self validateInputs:@"save"])
        return;
    
    // Save Data
    NSString* propertyType = self.propertyType.titleLabel.text;
    NSString* address = self.streetAddress.text;
    NSString* city = self.cityName.text;
    NSString* state = statePickerData[[self.statePicker selectedRowInComponent:0]];
    NSString* zipCode = self.zipCode.text;
    int loanAmount = [self.loanAmount.text intValue];
    int downPayment = [self.downPayment.text intValue];
    double annualRate = [self.annualRate.text doubleValue];
    int payYear = [self.payYear.text intValue];
    NSString* mortgageAmount = self.monthlyPayment.text;
    
    DBManager* dbManager = [DBManager getSharedInstance];
    BOOL success;
    NSString *message;
    
    if (mortgageId == 0) {
        success = [dbManager createData:propertyType address:address city:city state:state zipCode:zipCode loanAmount:loanAmount downPayment:downPayment annualRate:annualRate payYear:payYear mortgageAmount:mortgageAmount];
    } else {
        success = [dbManager updateData:mortgageId propertyType:propertyType address:address city:city state:state zipCode:zipCode loanAmount:loanAmount downPayment:downPayment annualRate:annualRate payYear:payYear mortgageAmount:mortgageAmount];
    }
    
    if (success == YES) {
        [self.propertyType setUserInteractionEnabled:NO];
        [self.streetAddress setUserInteractionEnabled:NO];
        [self.cityName setEnabled:NO];
        [self.statePicker setUserInteractionEnabled:NO];
        [self.zipCode setEnabled:NO];
        [self.loanAmount setEnabled:NO];
        [self.downPayment setEnabled:NO];
        [self.annualRate setEnabled:NO];
        [self.payYear setEnabled:NO];        
        [self.saveButton setEnabled:NO];
        
        if (mortgageId == 0) {
            message = @"Data saved successfully.";
        } else {
            message = @"Data updated successfully.";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message
                             delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        if (mortgageId == 0) {
            message = @"Data save failed.";
        } else {
            message = @"Data update failed.";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message
                             delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)showPropertyType:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"House", @"Apartment", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)calculateMortgage:(id)sender {
    int termInYears = [self.payYear.text intValue];
    int loanAmount = [self.loanAmount.text intValue];
    
    if (![self validateInputs:@"calculate"])
        return;
    
    double interestRate = [self.annualRate.text doubleValue] / 100.0;
    double monthlyRate = interestRate / 12.0;
    
    int termInMonths = termInYears * 12;
    
    // M = P[i(1+i)^n]/[(1+i)^n -1]
    double monthlyPayment = loanAmount * ((monthlyRate * pow(1 + monthlyRate, termInMonths)) / (pow(1 + monthlyRate, termInMonths) - 1));
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:monthlyPayment]];
    
    [self.monthlyPayment setText:numberAsString];
}

-(BOOL)validateInputs:(NSString*)action {
    if ([action  isEqual: @"save"]) {
        if (self.streetAddress.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Street Address is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    if ([action  isEqual: @"calculate"]) {
        if (self.annualRate.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"APR is required."
                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }    
    return YES;
}

@end
