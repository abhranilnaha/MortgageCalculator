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

@interface MapViewViewController () <WYPopoverControllerDelegate>

@property (nonatomic,retain) WYPopoverController *popoverController;

@end

@implementation MapViewViewController
@synthesize mapView;
@synthesize locationManager;
@synthesize geocoder;
@synthesize popoverController;

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

- (void)mapView:(MKMapView *)mapViewParam didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 200000, 200000);
    [mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    NSArray *data = [[DBManager getSharedInstance] getData];
    
    for (NSMutableDictionary *resultDictionary in data) {
        NSNumber *id = [resultDictionary objectForKey:@"id"];
        NSString *propertyType = [resultDictionary objectForKey:@"propertyType"];
        NSString *address = [resultDictionary objectForKey:@"address"];
        NSString *city = [resultDictionary objectForKey:@"city"];
        NSString *zipCode = [resultDictionary objectForKey:@"zipCode"];
        NSNumber *loanAmount = [resultDictionary objectForKey:@"loanAmount"];
        NSNumber *downPayment = [resultDictionary objectForKey:@"downPayment"];
        NSNumber *annualRate = [resultDictionary objectForKey:@"annualRate"];
        NSNumber *payYear = [resultDictionary objectForKey:@"payYear"];
        NSString *mortgageAmount = [resultDictionary objectForKey:@"mortgageAmount"];
        
        NSString *geocodeAddressString = [NSString stringWithFormat:@"%@ %@ %@", address, city, zipCode];
        
        geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:geocodeAddressString completionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                CLLocation *location = placemark.location;
                CLLocationCoordinate2D coordinate = location.coordinate;
            
                // Add an annotation
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = coordinate;
                point.title = [NSString stringWithFormat:@"Loan Amount: %@", loanAmount];
                point.subtitle = [NSString stringWithFormat:@"Mortgage Amount: %@", mortgageAmount];
                
                [mapView addAnnotation:point];
            }
        }];
    }
}

-(void)mapView:(MKMapView *)mapViewParam didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    PopoverViewController *popoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverViewController"];
    popoverViewController.title = @"Mortgage";
    [popoverViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteMortgage:)]];
    [popoverViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editMortgage:)]];
    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:popoverViewController];
    
    popoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
    popoverController.popoverContentSize = CGSizeMake(350, 350);
    [popoverController presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:WYPopoverArrowDirectionDown animated:YES];
}

- (void)editMortgage:(id)sender
{
    
}

- (void)deleteMortgage:(id)sender
{
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
