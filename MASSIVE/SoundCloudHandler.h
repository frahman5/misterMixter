//
//  SoundCloudHandler.h
//  MASSIVE
//
//  Created by Faiyam Rahman on 10/30/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface SoundCloudHandler : NSObject
- (NSString *)fetchPlaylistsForLocation:(NSString *)location;
- (void) playPlaylist:(NSString *) playlistURI;
- (void) setViewController:(UIViewController *) viewController;
- (void) nextSong;
- (void) previousSong;
- (void) pause;
// create a player object for playerVC
- (void)getAVPlayer;

// get playlists based on a given location array
- (NSArray *)getPlaylists:(NSArray *)locationArray;

// external variable telling us whether or not we have a user access token
@property (nonatomic) BOOL hasAccessToken; // YES or NO

// dictionary of location: playlistDictionary pairs
@property (nonatomic, strong) NSMutableDictionary *locationPlaylistDictionary;
@end
