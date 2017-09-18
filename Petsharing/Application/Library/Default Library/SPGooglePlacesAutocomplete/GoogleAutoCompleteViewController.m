#import "GoogleAutoCompleteViewController.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"

#define SEARCH_RADIUS 6000000.0f // 6000 km

@interface GoogleAutoCompleteViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@property BOOL gettingLocation;

@end

@implementation GoogleAutoCompleteViewController

@synthesize GoogleAutoCompleteViewDelegate;


- (CLLocationManager *)locationManager{
	if(!_locationManager){
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	}
	return _locationManager;
}


- (void) startUpdatingLocation{
	self.gettingLocation = true;
	[self.locationManager startUpdatingLocation];
}

- (void) stopUpdatingLocation{
	self.gettingLocation = false;
	[self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	@synchronized(self){
		NSLog(@"didFailWithError: %@", error);
		if(!self.gettingLocation) return;
		[self stopUpdatingLocation];
		NSString *message = NSLocalizedString(@"googleautocomp.locationretrieval.failure.message", nil);
		NSString *title = NSLocalizedString(@"googleautocomp.locationretrieval.failure.title", nil);
		if(![CLLocationManager locationServicesEnabled]){
			message = NSLocalizedString(@"googleautocomp.enable.locationretrieval.message", nil);
			title = NSLocalizedString(@"googleautocomp.enable.locationretrieval.title", nil);
		}else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
			message = NSLocalizedString(@"googleautocomp.perfectday.locationpermission.message", nil);
			title = NSLocalizedString(@"googleautocomp.perfectday.locationpermission.title", nil);
		}
		UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
	}
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    
    @synchronized(self){
        if(!self.gettingLocation) return;
        [self stopUpdatingLocation];
        NSLog(@"didUpdateToLocation: %@", currentLocation);
        if (currentLocation && [self isNewLocationWithinRadius:currentLocation]) {
            [self.GoogleAutoCompleteViewDelegate GoogleAutoCompleteViewControllerDismissedWithAddress:@"My location" AndLocation:currentLocation ForTextObj:self.textObjTag];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:NSLocalizedString(@"googleautocomp.locationupdate.notification.title", nil) message:[NSString stringWithFormat:NSLocalizedString(@"googleautocomp.locationupdate.notification.message", nil)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
//            			[self.GoogleAutoCompleteViewDelegate GoogleAutoCompleteViewControllerDismissedWithAddress:self.defaultLocation[@"name"] AndLocation:[[CLLocation alloc] initWithLatitude:[self.defaultLocation[@"latitude"] doubleValue] longitude:[self.defaultLocation[@"longitude"] doubleValue]] ForTextObj:self.textObjTag];
        }
        
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	@synchronized(self){
		if(!self.gettingLocation) return;
		[self stopUpdatingLocation];
		NSLog(@"didUpdateToLocation: %@", newLocation);
		if (newLocation && [self isNewLocationWithinRadius:newLocation]) {
			[self.GoogleAutoCompleteViewDelegate GoogleAutoCompleteViewControllerDismissedWithAddress:@"My location" AndLocation:newLocation ForTextObj:self.textObjTag];
			[self dismissViewControllerAnimated:YES completion:nil];
		}else{
			UIAlertView *errorAlert = [[UIAlertView alloc]
									   initWithTitle:NSLocalizedString(@"googleautocomp.locationupdate.notification.title", nil) message:[NSString stringWithFormat:NSLocalizedString(@"googleautocomp.locationupdate.notification.message", nil)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[errorAlert show];
//			[self.GoogleAutoCompleteViewDelegate GoogleAutoCompleteViewControllerDismissedWithAddress:self.defaultLocation[@"name"] AndLocation:[[CLLocation alloc] initWithLatitude:[self.defaultLocation[@"latitude"] doubleValue] longitude:[self.defaultLocation[@"longitude"] doubleValue]] ForTextObj:self.textObjTag];
		}
		
	}
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    
    
    [commonUtils removeAllSubViews:self.resultView];
    [self.searchDisplayController.searchResultsTableView setFrame:CGRectMake(0, 0, self.resultView.frame.size.width, self.resultView.frame.size.height)];
    [self.resultView addSubview:self.searchDisplayController.searchResultsTableView];
    
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
    searchQuery.sensor = NO;
//    float latitude = [[commonUtils getUserDefault:@"currentLatitude"] floatValue];
//    float longitude = [[commonUtils getUserDefault:@"currentLongitude"] floatValue];
    
    /* Set Peter location   
        Classensgade, 2100 København Ø, Denmark
        lat : 55.697860  long: 12.585933
     */
    float latitude = 55.697860f;
    float longitude = 12.585933f;
    
    NSLog(@"latitude %f, longitude %f",latitude,longitude);
	
    searchQuery.radius = SEARCH_RADIUS;
    searchQuery.location=CLLocationCoordinate2DMake(latitude, longitude);
    searchQuery.key = kGoogleAPIKey; //kGooglePlaceAPIKey for GooglePlaceSample
//    searchQuery.types=SPPlaceTypeInvalid;
    shouldBeginEditing = YES;
    self.searchDisplayController.searchBar.placeholder = @"Search For Place";

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(appplicationIsActive:)
												 name:UIApplicationDidBecomeActiveNotification
											   object:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResultPlaces count];
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SPGooglePlacesAutocompleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:16.0];
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)dismissSearchControllerWhileStayingActive {
    // Animate out the table view.
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.searchDisplayController.searchResultsTableView.alpha = 0.0;
    [UIView commitAnimations];
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SPGooglePlacesAutocompletePlace *place = [self placeAtIndexPath:indexPath];
    [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
        if (error) {
            SPPresentAlertViewWithErrorAndTitle(error, @"Could not map selected Place");
        } else if (placemark) {
            
            [self.GoogleAutoCompleteViewDelegate
             GoogleAutoCompleteViewControllerDismissedWithAddress: addressString
             AndLocation:placemark.location ForTextObj:self.textObjTag
             ];
            [self dismissSearchControllerWhileStayingActive];
            [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];      
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];

    return;
    
//    SPGooglePlacesAutocompletePlace *place = [self placeAtIndexPath:indexPath];
//    [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
//        if (error) {
//          // SPPresentAlertViewWithErrorAndTitle(error, @"Could not map selected Place");
//            NSLog(@"Error is %@",error);
//        } else if (placemark) {
//			CLLocation *location = [placemark location];
//			if(![self isNewLocationWithinRadius:location]){
//				UIAlertView *errorAlert = [[UIAlertView alloc]
//										   initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ is too far from the cool stuff. Try choosing a location closer to the city.",addressString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//				[errorAlert show];
//			}else{
//				[self.GoogleAutoCompleteViewDelegate GoogleAutoCompleteViewControllerDismissedWithAddress:addressString AndLocation:location ForTextObj:self.textObjTag];
//				[self dismissViewControllerAnimated:YES completion:nil];
////                [self.navigationController popViewControllerAnimated:YES];
//			}
//        }
//    }];
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString {
    searchQuery.input = searchString;
    NSLog(@"searchString %@", searchString);
    if (searchQuery == nil){
        NSLog(@"search Query is nill");
    }
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        NSLog(@"found %lu places", (unsigned long)[places count]);

        if (error) {
            NSLog(@"%@",error);
//            SPPresentAlertViewWithErrorAndTitle(error, @"Could not fetch Places");
        } else {
            //[searchResultPlaces release];
            //searchResultPlaces = [places retain];
            searchResultPlaces = [places copy];
            
            
            NSLog(@"Search Result : %@", searchResultPlaces);
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSLog(@"calling handleSearchForSearchString for searchString %@", searchString);
    [self handleSearchForSearchString:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"in textDidChange %@", searchText);
    if (![searchBar isFirstResponder]) {
        // User tapped the 'clear' button.
        shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (shouldBeginEditing) {
        [commonUtils removeAllSubViews:self.resultView];
        [self.searchDisplayController.searchResultsTableView setFrame:CGRectMake(0, 0, self.resultView.frame.size.width, self.resultView.frame.size.height)];
        [self.resultView addSubview:self.searchDisplayController.searchResultsTableView];
        
        // Animate in the table view.
        NSTimeInterval animationDuration = 0.15;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        
        self.searchDisplayController.searchResultsTableView.alpha = 1.0;
        [UIView commitAnimations];
        
        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    }
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1 {
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
}

- (IBAction)getMyLocationTapped:(id)sender {
	[self startUpdatingLocation];
}

- (IBAction)cancelButtonTapped:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}


- (void)appplicationIsActive:(NSNotification *)notification {
    NSLog(@"Application Did Become Active");
	if([[self.navigationController topViewController] isKindOfClass:[self class]]){
		if(self.gettingLocation){
			[self startUpdatingLocation];
		}
	}
}

- (BOOL)isNewLocationWithinRadius :(CLLocation *)newLocation{
    float latitude = [[commonUtils getUserDefault:@"currentLatitude"] floatValue];
	float longitude = [[commonUtils getUserDefault:@"currentLongitude"] floatValue];
	CLLocation *cityCenter = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	CLLocationDistance distance = [cityCenter distanceFromLocation:newLocation];
    return distance <= SEARCH_RADIUS;
//    return YES;
}

#pragma Top Menu
- (IBAction)menuClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
