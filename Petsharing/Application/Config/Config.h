//
//  Config.h
//  WebServiceSample
//
//  Created by LandtoSky on 6/14/16.
//  Copyright © 2016 LandtoSky. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define APP_NAME @"Petsharing"
#define SERVER_URL @"http://sharepet.org/petshare"
//#define SERVER_URL @"http://172.16.1.214:8080/hungriapp"


#define API_KEY @"1234"

#define API_URL (SERVER_URL @"/api")
#define API_URL_USER_SIGNUP (SERVER_URL @"/api/user_signup")
#define API_URL_USER_LOGIN (SERVER_URL @"/api/user_login")
#define API_URL_USER_RETRIEVE_PASSWORD (SERVER_URL @"/api/user_retrieve_password")
#define API_URL_USER_LOGOUT (SERVER_URL @"/api/user_logout")
#define API_URL_USER_SET_NEW_PASSWORD (SERVER_URL @"/api/user_set_new_password")
#define API_URL_USER_CHANGE_PASSWORD (SERVER_URL @"/api/user_change_password")

#define API_URL_EDIT_PROFILE (SERVER_URL @"/api/user_edit_profile")
#define API_URL_POST_JOB (SERVER_URL @"/api/post_job")
#define API_URL_UPDATE_JOB (SERVER_URL @"/api/update_job")
#define API_URL_MY_JOBS (SERVER_URL @"/api/my_jobs")
#define API_URL_FIND_JOBS (SERVER_URL @"/api/find_jobs")
#define API_URL_FIND_SITTERS (SERVER_URL @"/api/find_sitters")
#define API_URL_APPLY_JOB (SERVER_URL @"/api/apply_job")
#define API_URL_CANCEL_JOB (SERVER_URL @"/api/cancel_job")
#define API_URL_APPLY_SITTERS (SERVER_URL @"/api/apply_sitters")
#define API_URL_GET_HIREINFO (SERVER_URL @"/api/get_hireinfo")
#define API_URL_GET_OWNERINFO (SERVER_URL @"/api/get_ownerinfo")
#define API_URL_OFFER (SERVER_URL @"/api/offer")
#define API_URL_REGISTER_QB_ID (SERVER_URL @"/api/register_qb_id")
#define API_URL_ADD_PAYMENT_METHOD (SERVER_URL @"/api/add_st_payment_method")
#define API_URL_APPROVE_OFFER (SERVER_URL @"/api/approve_offer")

#define API_URL_BT_POST_NONCE (SERVER_URL @"/api/bt_post_nonce")
#define API_URL_BT_MERCHANT_REGISTER (SERVER_URL @"/api/bt_merchant_register")
#define API_URL_BT_GET_CLIENT_TOKEN (SERVER_URL @"/api/bt_get_client_token")
#define StripePublishableKey @"pk_test_3HXdDBLTCQd7UhlxRb554AIu"
//Google + API
#define kClientId @"735160124268-o4fpc0tm2qpg5693l4c99o62pdm139v4.apps.googleusercontent.com";

/***************************************************************/
// MEDIA CONFIG
#define MEDIA_USER_SELF_DOMAIN_PREFIX @"hg_media_user_"
#define MEDIA_POST_PHOTO_SELF_DOMAIN_PREFIX @"hg_media_post_photo_"

#define MEDIA_URL (SERVER_URL @"/assets/media/")
#define MEDIA_URL_USERS (SERVER_URL @"/assets/media/users/")
#define MEDIA_URL_POST_PHOTO (SERVER_URL @"/assets/media/post_photos/")

#define MEDIA_DEFAULT_USER_PHOTO_URL @"default_user"
#define MEDIA_DEFAULT_PHOTO_URL @"default_photo"

// Messages

#define MSG_SIGN_IN_FAILED @"There isn't matcted user email"
#define MSG_FILL_FORM_CORRECTLY @"Fill the form correctly."
#define MSG_CHECK_INTERNET_CONNECTION @"Connection Error!\nPlease check your internet connection status."
#define MSG_CONFIRM_SURE @"Are you sure?"

#define MSG_PENDING_EVENT_REQUIRES_PAYMENT @"You have a pending payment for an event that has ended. Please make payment first before sending your next offer."
#define MSG_EVENT_ENDED @"Event has ended successfully."
#define MSG_VERIFY_PAYMENT @"Verify your payment method first."
#define MSG_CANNOT_OFFER_ANOTHER_PENDING @"You cannot make an offer at this time,\nsince you have another\npending offer/event."
#define MSG_VERIFIED_BANK_ACCOUNT @"You have verified your bank account successfully."



/*******************   Petsharing Constants ********************************************/
#define backAlpha  0.5
#define PetDateFormatStr @"dd MMM yyyy HH:mm"





/******************* Utility Values **************************/
// Map View Default Config
#define MINIMUM_ZOOM_ARC 0.5 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.5
#define MAX_DEGREES_ARC 360


#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
#define M_PI        3.14159265358979323846264338327950288
#define EMAIL_VERIFY_CODE_MAX_LENGTH 4

#define FONT_GOTHAM_NORMAL(s) [UIFont fontWithName:@"GothamRounded-Book" size:s]
#define FONT_GOTHAM_BOLD(s) [UIFont fontWithName:@"GothamRounded-Bold" size:s]

#define FONT_HELVETICA15 [UIFont fontWithName:@"Helvetica" size:15]
#define FONT_HELVETICA10 [UIFont fontWithName:@"Helvetica" size:10]


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6_OR_ABOVE (IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#endif /* Config_h */
