//
//  SPGooglePlacesAutocompleteUtilities.h
//  SPGooglePlacesAutocomplete
//
//  Created by Stephen Poletto on 7/18/12.
//  Copyright (c) 2012 Stephen Poletto. All rights reserved.
//

#define kGoogleAPIKey @"AIzaSyC_auY4dlt8uGJ_me1d7UW4OP-oR3OHEVA"

#define kGoogleAPINSErrorCode 42

@class CLPlacemark;

typedef enum {
    SPPlaceTypeInvalid = -1,
    SPPlaceTypeGeocode = 0,
    SPPlaceTypeEstablishment
} SPGooglePlacesAutocompletePlaceType;

typedef void (^SPGooglePlacesPlacemarkResultBlock)(CLPlacemark *placemark, NSString *addressString, NSError *error);
typedef void (^SPGooglePlacesAutocompleteResultBlock)(NSArray *places, NSError *error);
typedef void (^SPGooglePlacesPlaceDetailResultBlock)(NSDictionary *placeDictionary, NSError *error);

extern SPGooglePlacesAutocompletePlaceType SPPlaceTypeFromDictionary(NSDictionary *placeDictionary);
extern NSString *SPBooleanStringForBool(BOOL boolean);
extern NSString *SPPlaceTypeStringForPlaceType(SPGooglePlacesAutocompletePlaceType type);

extern BOOL SPEnsureGoogleAPIKey();
extern void SPPresentAlertViewWithErrorAndTitle(NSError *error, NSString *title);


extern BOOL SPIsEmptyString(NSString *string);

@interface NSArray(SPFoundationAdditions)
- (id)onlyObject;
@end
