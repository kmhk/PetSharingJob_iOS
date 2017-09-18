//
//  GoogleAutoCompleteViewController.h
//  HelloWorld2
//
//  Created by Kadam Jeet Jain on 28/03/14.
//  Copyright (c) 2014 Kadam Jeet Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
static NSString *url;
@class SPGooglePlacesAutocompleteQuery;

@protocol GoogleAutoCompleteViewDelegate<NSObject>
-(void) GoogleAutoCompleteViewControllerDismissedWithAddress:(NSString *)address AndPlacemark:(CLPlacemark *)placeMark ForTextObj:(NSInteger *)textObjTag;
-(void) GoogleAutoCompleteViewControllerDismissedWithAddress:(NSString *)address AndLocation:(CLLocation *)location ForTextObj:(NSInteger *)textObjTag;

@end

@interface GoogleAutoCompleteViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate>{
    
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    BOOL shouldBeginEditing;
}
@property (nonatomic, assign) id<GoogleAutoCompleteViewDelegate>GoogleAutoCompleteViewDelegate;
@property (nonatomic, assign) NSInteger *textObjTag;
@property (nonatomic, assign) NSString *latitude;
@property (nonatomic, assign) NSString *longitude;
@property (nonatomic, assign) NSString *radius;
@property (nonatomic, strong) IBOutlet UIView *resultView;

@end