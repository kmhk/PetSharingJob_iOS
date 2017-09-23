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

#import "DemoModelData.h"
#import "NSUserDefaults+DemoSettings.h"
#import "DogUser.h"
#import "DogJob.h"


/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */
@interface DemoModelData()
{
	DogUser *userMe;
	DogUser *userOponent;
	DogJob *curJob;
	
	NSMutableArray *chatHistories;
}

@end



@implementation DemoModelData

- (instancetype)init
{
    self = [super init];
    if (self) {
		self.messages = [NSMutableArray new];
		chatHistories = [NSMutableArray new];
        
//        if ([NSUserDefaults emptyMessagesSetting]) {
//            self.messages = [NSMutableArray new];
//        }
//        else {
//            [self loadFakeMessages];
//        }
//        
//        
//        /**
//         *  Create avatar images once.
//         *
//         *  Be sure to create your avatars one time and reuse them for good performance.
//         *
//         *  If you are not using avatars, ignore this.
//         */
//        JSQMessagesAvatarImageFactory *avatarFactory = [[JSQMessagesAvatarImageFactory alloc] initWithDiameter:kJSQMessagesCollectionViewAvatarSizeDefault];
//        
//        JSQMessagesAvatarImage *jsqImage = [avatarFactory avatarImageWithUserInitials:@"JSQ"
//                                                                      backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
//                                                                            textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
//                                                                                 font:[UIFont systemFontOfSize:14.0f]];
//        
//        JSQMessagesAvatarImage *cookImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_cook"]];
//        
//        JSQMessagesAvatarImage *jobsImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_jobs"]];
//        
//        JSQMessagesAvatarImage *wozImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_woz"]];
//        
//        self.avatars = @{ kJSQDemoAvatarIdSquires : jsqImage,
//                          kJSQDemoAvatarIdCook : cookImage,
//                          kJSQDemoAvatarIdJobs : jobsImage,
//                          kJSQDemoAvatarIdWoz : wozImage };
//        
//        
//        self.users = @{ kJSQDemoAvatarIdJobs : kJSQDemoAvatarDisplayNameJobs,
//                        kJSQDemoAvatarIdCook : kJSQDemoAvatarDisplayNameCook,
//                        kJSQDemoAvatarIdWoz : kJSQDemoAvatarDisplayNameWoz,
//                        kJSQDemoAvatarIdSquires : kJSQDemoAvatarDisplayNameSquires };
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
//        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
//        
//        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
//        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}


- (void)initWith:(NSString *)jobID myID:(NSString *)myID opID:(NSString *)opID {
	self.curJobID = jobID;
	self.chatMineID = myID;
	self.chatOponentID = opID;
	
	[self initChat];
}


- (void)initChat {
	[DogUser fetchUser:self.chatMineID completion:^(DogUser *user) {
		userMe = user;
		
		[DogUser fetchUser:self.chatOponentID completion:^(DogUser *user) {
			userOponent = user;
			
			// init
			self.users = @{ self.chatMineID: [NSString stringWithFormat:@"%@ %@", userMe.strFirstName, userMe.strLastName],
							self.chatOponentID: [NSString stringWithFormat:@"%@ %@", userOponent.strFirstName, userOponent.strLastName] };
			
			JSQMessagesAvatarImageFactory *avatarFactory = [[JSQMessagesAvatarImageFactory alloc] initWithDiameter:kJSQMessagesCollectionViewAvatarSizeDefault];
			JSQMessagesAvatarImage *Me = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_cook"]];
			JSQMessagesAvatarImage *Op = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_jobs"]];
			
			self.avatars = @{ self.chatMineID: Me,
							  self.chatOponentID: Op };
			
			JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
			self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
			self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
			
			__weak typeof(self) weakSelf = self;
			[self addChatHistory:^(NSError *error) {
				[weakSelf watchingChatChannel];
			}];
		}];
	}];
}


- (void)sendMessage:(NSDictionary *)dict {
//	[chatHistories addObject:dict];
//	[self parseChatEntry:dict];
	NSMutableArray *array = [NSMutableArray arrayWithArray:chatHistories];
	[array addObject:dict];
	
	NSString *key, *historyKey;
	if (userMe.userRole == DogUserRoleOwner) {
		key = [NSString stringWithFormat:@"%@+%@+%@", self.curJobID, self.chatMineID, self.chatOponentID];
		historyKey = [NSString stringWithFormat:@"%@+%@", self.chatMineID, self.chatOponentID];
	} else {
		key = [NSString stringWithFormat:@"%@+%@+%@", self.curJobID, self.chatOponentID, self.chatMineID];
		historyKey = [NSString stringWithFormat:@"%@+%@", self.chatOponentID, self.chatMineID];
	}
	
	[[[FirebaseRef allChats] child:key] updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
		if (error) {
			[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
			return;
		}
		
		NSDictionary *history = @{historyKey: array};
		[[[FirebaseRef allChatHistory] child:self.curJobID] updateChildValues:history withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
			if (error) {
				[commonUtils showAlert:@"Warning!" withMessage:error.localizedDescription];
				return;
			}
		}];
	}];
}


// MARK: - private methods

- (void)addChatHistory:(CompletionCallback)completion {
	NSString *key;
	if (userMe.userRole == DogUserRoleOwner) {
		key = [NSString stringWithFormat:@"%@+%@", self.chatMineID, self.chatOponentID];
	} else {
		key = [NSString stringWithFormat:@"%@+%@", self.chatOponentID, self.chatMineID];
	}
	
	[[[[FirebaseRef allChatHistory] child:self.curJobID] child:key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSArray *array = (NSArray *)snapshot.value;
		if ([array isEqual:[NSNull null]]) {
			completion(nil);
			return;
		}
		
		for (NSInteger i = 0; i < array.count - 1; i ++) {	// don't read last message in the history, because it is existing on chat channel still.
			NSDictionary *dict = array[i];					// but need to fix this
			[self parseChatEntry:dict];
		}
		
		completion(nil);
	}];
}

- (void)watchingChatChannel {
	NSString *key;
	if (userMe.userRole == DogUserRoleOwner) {
		key = [NSString stringWithFormat:@"%@+%@+%@", self.curJobID, self.chatMineID, self.chatOponentID];
	} else {
		key = [NSString stringWithFormat:@"%@+%@+%@", self.curJobID, self.chatOponentID, self.chatMineID];
	}
	
	[[[FirebaseRef allChats] child:key] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSDictionary *dict = (NSDictionary *)snapshot.value;
		if ([dict isEqual:[NSNull null]]) {
			NSLog(@"nothing chatting history");
		} else {
			[self parseChatEntry:dict];
		}
	}];
}

- (void)parseChatEntry:(NSDictionary *)dict {
	[chatHistories addObject:dict];
	
	if ([dict[kChatType] integerValue] == ChatTypeText) {
		[self addTextMessage:dict];
	}
	
	[self.demoDelegate reloadChatView];
}

- (void)addTextMessage:(NSDictionary *)dict {
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[kChatDate] doubleValue]];
	
	JSQMessage *message = [[JSQMessage alloc] initWithSenderId:dict[kChatFrom]
											 senderDisplayName:self.users[dict[kChatFrom]]
														  date:date
														  text:dict[kChatContent]];
	[self.messages addObject:message];
}

//- (void)loadFakeMessages
//{
//    /**
//     *  Load some fake messages for demo.
//     *
//     *  You should have a mutable array or orderedSet, or something.
//     */
//    self.messages = [[NSMutableArray alloc] initWithObjects:
//                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
//                                        senderDisplayName:kJSQDemoAvatarDisplayNameSquires
//                                                     date:[NSDate distantPast]
//                                                     text:NSLocalizedString(@"Welcome to JSQMessages: A messaging UI framework for iOS.", nil)],
//                     
//                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdWoz
//                                        senderDisplayName:kJSQDemoAvatarDisplayNameWoz
//                                                     date:[NSDate distantPast]
//                                                     text:NSLocalizedString(@"It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy.", nil)],
//                     
//                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
//                                        senderDisplayName:kJSQDemoAvatarDisplayNameSquires
//                                                     date:[NSDate distantPast]
//                                                     text:NSLocalizedString(@"It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com.", nil)],
//                     
//                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdJobs
//                                        senderDisplayName:kJSQDemoAvatarDisplayNameJobs
//                                                     date:[NSDate date]
//                                                     text:NSLocalizedString(@"JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better.", nil)],
//                     
//                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdCook
//                                        senderDisplayName:kJSQDemoAvatarDisplayNameCook
//                                                     date:[NSDate date]
//                                                     text:NSLocalizedString(@"It is unit-tested, free, open-source, and documented.", nil)],
//                     
//                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
//                                        senderDisplayName:kJSQDemoAvatarDisplayNameSquires
//                                                     date:[NSDate date]
//                                                     text:NSLocalizedString(@"Now with media messages!", nil)],
//                     nil];
//    
//    [self addPhotoMediaMessage];
//    [self addAudioMediaMessage];
//    
//    /**
//     *  Setting to load extra messages for testing/demo
//     */
//    if ([NSUserDefaults extraMessagesSetting]) {
//        NSArray *copyOfMessages = [self.messages copy];
//        for (NSUInteger i = 0; i < 4; i++) {
//            [self.messages addObjectsFromArray:copyOfMessages];
//        }
//    }
//    
//    
//    /**
//     *  Setting to load REALLY long message for testing/demo
//     *  You should see "END" twice
//     */
//    if ([NSUserDefaults longMessageSetting]) {
//        JSQMessage *reallyLongMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                            displayName:kJSQDemoAvatarDisplayNameSquires
//                                                                   text:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END"];
//        
//        [self.messages addObject:reallyLongMessage];
//    }
//}


// MARK: - public methods

//- (void)addAudioMediaMessage
//{
//    NSString * sample = [[NSBundle mainBundle] pathForResource:@"jsq_messages_sample" ofType:@"m4a"];
//    NSData * audioData = [NSData dataWithContentsOfFile:sample];
//    JSQAudioMediaItem *audioItem = [[JSQAudioMediaItem alloc] initWithData:audioData];
//    JSQMessage *audioMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                   displayName:kJSQDemoAvatarDisplayNameSquires
//                                                         media:audioItem];
//    [self.messages addObject:audioMessage];
//}
//
//- (void)addPhotoMediaMessage
//{
//    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"goldengate"]];
//    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                   displayName:kJSQDemoAvatarDisplayNameSquires
//                                                         media:photoItem];
//    [self.messages addObject:photoMessage];
//}
//
//- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
//{
//    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
//    
//    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
//    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
//    
//    JSQMessage *locationMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                      displayName:kJSQDemoAvatarDisplayNameSquires
//                                                            media:locationItem];
//    [self.messages addObject:locationMessage];
//}
//
//- (void)addVideoMediaMessage
//{
//    // don't have a real video, just pretending
//    NSURL *videoURL = [NSURL URLWithString:@"file://"];
//    
//    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
//    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                   displayName:kJSQDemoAvatarDisplayNameSquires
//                                                         media:videoItem];
//    [self.messages addObject:videoMessage];
//}
//
//- (void)addVideoMediaMessageWithThumbnail
//{
//    // don't have a real video, just pretending
//    NSURL *videoURL = [NSURL URLWithString:@"file://"];
//    
//    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES thumbnailImage:[UIImage imageNamed:@"goldengate"]];
//    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                   displayName:kJSQDemoAvatarDisplayNameSquires
//                                                         media:videoItem];
//    [self.messages addObject:videoMessage];
//}

@end
