//
//  CalculationViewController.m
//  MortgageCalculator
//
//  Created by anaha on 4/21/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "CalculationViewController.h"

@interface CalculationViewController ()
{
    NSArray *statePickerData;
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
    
    [self.statePicker selectRow:4 inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"House"]) {
        [self.propertyType setTitle:@"House" forState:UIControlStateNormal];
    }
    if ([buttonTitle isEqualToString:@"Apartment"]) {
        [self.propertyType setTitle:@"Apartment" forState:UIControlStateNormal];
    }
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return statePickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return statePickerData[row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)createMortgage:(id)sender {
}

- (IBAction)saveMortgage:(id)sender {
}

- (IBAction)showPropertyType:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"House", @"Apartment", nil];
    
    [actionSheet showInView:self.view];
}

@end
