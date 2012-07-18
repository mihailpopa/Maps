//
//  ViewController.m
//  Maps
//
//  Created by Mihai Popa on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize scrollView;
@synthesize mapView;
@synthesize tableView,textField,myAnnotations;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.layer.borderColor = [UIColor redColor].CGColor;
    self.mapView.layer.borderWidth = 2.0f;
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    CGRect bigFrame = self.view.frame;
    bigFrame.size.width *= 2;
    scrollView.contentSize = bigFrame.size;
    [scrollView setPagingEnabled:YES];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPin:)];
    [recognizer setNumberOfTapsRequired:1];
    [mapView addGestureRecognizer:recognizer];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setTableView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark - Implemented action methods

- (void)addPin:(UITapGestureRecognizer*)recognizer
{
    if (!myAnnotations) myAnnotations = [NSMutableArray array];
    CGPoint tappedPoint = [recognizer locationInView:mapView];
    CLLocationCoordinate2D coord= [mapView convertPoint:tappedPoint toCoordinateFromView:mapView];
    InterestPoint *annotation = [[InterestPoint alloc] initWithCoordinate:coord];
    [mapView addAnnotation:annotation];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    [myAnnotations addObject:annotation];
    [[myAnnotations lastObject] setTitle:@"Hello"];
    NSLog(@"Last object %@", annotation);
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Place name" message:@"Enter place name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:
         ^(NSArray* placemarks, NSError* error){
             if ([placemarks count] > 0)
             {
              
             }
         }];    
}


#pragma mark - Table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myAnnotations count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[myAnnotations objectAtIndex:indexPath.row] title];
    return cell;
}



#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [(InterestPoint *)[self.myAnnotations lastObject] setTitle:[alertView textFieldAtIndex:0].text];
    [self.tableView reloadData];
}
@end
