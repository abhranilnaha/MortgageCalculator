//
//  MapViewViewController.m
//  MortgageCalculator
//
//  Created by anaha on 4/16/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "MapViewViewController.h"
#import "DBManager.h"
#import "PopoverViewController.h"
#import "WYPopoverController.h"
#import "Mortgage.h"
#import "CalculationViewController.h"
#import "StreetViewController.h"

@interface MapViewViewController () <WYPopoverControllerDelegate>

@property (nonatomic,retain) WYPopoverController *popoverController;
@property (nonatomic,retain) PopoverViewController *popoverViewController;
@property (nonatomic,retain) NSMutableArray *mortgages;

@end

@implementation MapViewViewController
@synthesize mapView;
@synthesize locationManager;
@synthesize geocoder;
@synthesize popoverController;
@synthesize popoverViewController;
@synthesize mortgages;
@synthesize annotation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mapView.delegate = self;
    [mapView setMapType:MKMapTypeStandard];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (mortgages != nil) {
        [mapView removeAnnotations:[mapView annotations]];
        [self loadData];
    }
}

- (void)mapView:(MKMapView *)mapViewParam didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 200000, 200000);
    [mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    [self loadData];
}

- (void)loadData {
    NSArray *data = [[DBManager getSharedInstance] getData];
    mortgages = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *resultDictionary in data) {
        NSNumber *id = [resultDictionary objectForKey:@"id"];
        NSString *propertyType = [resultDictionary objectForKey:@"propertyType"];
        NSString *streetAddress = [resultDictionary objectForKey:@"address"];
        NSString *cityName = [resultDictionary objectForKey:@"city"];
        NSString *stateName = [resultDictionary objectForKey:@"state"];
        NSString *zipCode = [resultDictionary objectForKey:@"zipCode"];
        NSNumber *loanAmount = [resultDictionary objectForKey:@"loanAmount"];
        NSNumber *downPayment = [resultDictionary objectForKey:@"downPayment"];
        NSNumber *propertyValue = [resultDictionary objectForKey:@"propertyValue"];
        NSNumber *annualRate = [resultDictionary objectForKey:@"annualRate"];
        NSNumber *payYear = [resultDictionary objectForKey:@"payYear"];
        NSString *mortgageAmount = [resultDictionary objectForKey:@"mortgageAmount"];
        
        Mortgage *mortgage = [[Mortgage alloc] init];
        mortgage.id = id;
        mortgage.propertyType = propertyType;
        mortgage.streetAddress = streetAddress;
        mortgage.cityName = cityName;
        mortgage.stateName = stateName;
        mortgage.zipCode = zipCode;
        mortgage.loanAmount = loanAmount;
        mortgage.downPayment = downPayment;
        mortgage.propertyValue = propertyValue;
        mortgage.annualRate = annualRate;
        mortgage.payYear = payYear;
        mortgage.mortgageAmount =mortgageAmount;
        
        [mortgages addObject:mortgage];
        
        NSString *geocodeAddressString = [NSString stringWithFormat:@"%@ %@ %@", streetAddress, cityName, zipCode];
        
        geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:geocodeAddressString completionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                CLLocation *location = placemark.location;
                mortgage.coordinate = location.coordinate;
                
                // Add an annotation
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = mortgage.coordinate;
                NSUInteger index = [mortgages indexOfObject:mortgage];
                point.title = @(index).stringValue;
                [mapView addAnnotation:point];
            }
        }];
    }
}

-(void)mapView:(MKMapView *)mapViewParam didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    annotation = view.annotation;
    int index = [view.annotation.title intValue];
    
    popoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverViewController"];
    
    popoverViewController.mortgage = mortgages[index];
    popoverViewController.title = @"Mortgage";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(showStreetView:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show Street View" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 300.0, 160.0, 40.0);
    [popoverViewController.view addSubview:button];   
    
    [popoverViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteMortgage:)]];
    [popoverViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editMortgage:)]];
    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:popoverViewController];
    
    popoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
    popoverController.popoverContentSize = CGSizeMake(350, 400);
    [popoverController presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:WYPopoverArrowDirectionDown animated:YES];
}

- (void)showStreetView:(id)sender
{
    [popoverController dismissPopoverAnimated:YES];
    [self performSegueWithIdentifier:@"ShowStreetView" sender:sender];
}

- (void)editMortgage:(id)sender
{
    [popoverController dismissPopoverAnimated:YES];
    self.tabBarController.selectedIndex = 0;
    UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:0];
    CalculationViewController *calculationController = [navController.viewControllers objectAtIndex:0];
    int index = [annotation.title intValue];
    Mortgage *mortgage = mortgages[index];
    [calculationController initWithMortgage:mortgage];
}

- (void)deleteMortgage:(id)sender
{
    [popoverController dismissPopoverAnimated:YES];
    [mapView removeAnnotation:annotation];
    int index = [annotation.title intValue];
    Mortgage *mortgage = mortgages[index];
    int id = [mortgage.id intValue];
    
    BOOL success = [[DBManager getSharedInstance] deleteData:id];
    if (success == YES) {
        [mortgages removeObject:mortgage];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Data deleted successfully."
                             delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Data deletion failed."
                             delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowStreetView"])
    {
        StreetViewController *streetViewController = [segue destinationViewController];
        int index = [annotation.title intValue];
        Mortgage *mortgage = mortgages[index];
        streetViewController.coordinate = mortgage.coordinate;
    }
}


- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
