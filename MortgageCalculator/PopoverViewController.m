//
//  PopoverViewController.m
//  MortgageCalculator
//
//  Created by loaner on 5/9/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "PopoverViewController.h"

@interface PopoverViewController ()

@end

@implementation PopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.streetAddress.layer.borderWidth = 0.5f;
    self.streetAddress.layer.cornerRadius = 10;
    self.streetAddress.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)deleteMortgage:(id)sender {
}

- (IBAction)editMortgage:(id)sender {
}
@end
