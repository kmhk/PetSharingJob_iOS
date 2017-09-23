//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "JSQMessages.h"

/**
 *  This is for demo/testing purposes only. 
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

//static NSString * const kJSQDemoAvatarDisplayNameSquires = @"Jesse Squires";
//static NSString * const kJSQDemoAvatarDisplayNameCook = @"Tim Cook";
//static NSString * const kJSQDemoAvatarDisplayNameJobs = @"Jobs";
//static NSString * const kJSQDemoAvatarDisplayNameWoz = @"Steve Wozniak";
//
//static NSString * const kJSQDemoAvatarIdSquires = @"053496-4509-289";
//static NSString * const kJSQDemoAvatarIdCook = @"468-768355-23123";
//static NSString * const kJSQDemoAvatarIdJobs = @"707-8956784-57";
//static NSString * const kJSQDemoAvatarIdWoz = @"309-41802-93823";


#define kChatFrom				@"from"
#define kChatDate				@"date"
#define kChatType				@"type"
#define kChatContent			@"content"
#define kChatIsRead				@"isread"


typedef enum {
	ChatTypeText				= 0,
	ChatTypePhto,
	ChatTypeMedia,
	ChatTypeLocation
} ChatType;


@protocol DemoMessageViewControllerDelegate;



@interface DemoModelData : NSObject

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) NSDictionary *users;


@property (nonatomic) id<DemoMessageViewControllerDelegate> demoDelegate;

@property (nonatomic) NSString *curJobID;

@property (nonatomic) NSString *chatMineID;
@property (nonatomic) NSString *chatOponentID;

@property (nonatomic) NSString *chatMyName;
@property (nonatomic) NSString *chatOponentName;


- (void)initWith:(NSString *)jobID myID:(NSString *)myID opID:(NSString *)opID;

- (void)sendMessage:(NSDictionary *)dict;

//- (void)addPhotoMediaMessage;
//
//- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion;
//
//- (void)addVideoMediaMessage;
//
//- (void)addVideoMediaMessageWithThumbnail;
//
//- (void)addAudioMediaMessage;

@end
