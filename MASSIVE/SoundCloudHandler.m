////
////  SoundCloudHandler.m
////  MASSIVE
////
////  Created by Faiyam Rahman on 10/30/14.
////  Copyright (c) 2014 CornellTech. All rights reserved.
////
//
//#import "SoundCloudHandler.h"
//#import "SCUI.h"
//#import <AVFoundation/AVFoundation.h>
//#import "MASSIVE-Swift.h"
//
//@interface SoundCloudHandler ()
//
//// Soundcloud app-specific constants
//@property (nonatomic, strong) NSString *clientID;
//@property (nonatomic, strong) NSString *secret;
//@property (nonatomic, strong) NSString *redirectURI;
//
//// the guy who'll play our songs, and his companion data function
//@property (nonatomic, strong) AVPlayer *player;
//    // each element is (streamURL, trackTitle)
//@property (nonatomic, strong) NSMutableArray *tracksRelevantInfoArray;
//@property (nonatomic) NSUInteger trackIndex;
//@property (nonatomic, strong) NSArray *tracks;
//
//// the view controller that communicates song data to the view
//@property (nonatomic, strong) playerVC *ppvC;
//
//
//- (void)setTracksArray;
//
//@end
//
//@implementation SoundCloudHandler
//
//- (void) setViewController:(UIViewController *)viewController{
//    self.ppvC = (playerVC *)viewController;
//}
//
//-(id)init {
//    
//    // set soundcloud specific constants
//    NSLog(@"running init code");
//    
//    // IMAXMassive
//    self.clientID = @"7e4a3481d659fbcd9667741811dfa4ee";
//    self.secret = @"ad15980c012fd968f0e33784e25b4551";
//    self.redirectURI = @"IMAXMassive://oauth";
//    // misterMIXTER
////    self.clientID = @"2969820eb1647bc78367d836a714710a";
////    self.secret = @"fde4df706bb48a58cb3b04f7cde686f9";
////    self.redirectURI = @"mrMixter://oauth";
//
//    
//    return self;
//}
//
//
//
//- (void)setTracksArray {
//    NSLog(@"Ran setTracksArray");
//    
//    [self initializeSoundCloud];
//    
//    // Create a request handler to receive the json response
//    SCRequestResponseHandler handler;
//    
//    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
//        
//        assert(data != nil);
//        NSLog(@"We entered handler code");
//        NSError *jsonError = nil;
//        NSJSONSerialization *jsonResponse = [NSJSONSerialization
//                                             JSONObjectWithData:data
//                                             options:0
//                                             error:&jsonError];
//        
//        if (!jsonError && [jsonResponse isKindOfClass:[NSDictionary class]]) {
//            NSLog(@"succesffuly retrieved playlist");
//            
//            
//            self.tracks = [(NSDictionary *)jsonResponse objectForKey:@"tracks"];
//            
//        }
//        else {
//            NSLog(@"something didn't work");
//            NSLog(@"%@", [jsonError localizedDescription]);
//        }
//    };
//    
//    // Ping the api for the desired playlist
//    NSString *resourceURL = [NSString stringWithFormat:@"https://api.soundcloud.com/playlists/53537234.json?client_id=%@", self.clientID ];
//    NSURL *resource = [[NSURL alloc] initWithString:resourceURL];
//    NSLog(@"%@", resource);
//    NSLog(@"resource URL: %@", resourceURL);
//    [SCRequest performMethod:SCRequestMethodGET
//                  onResource:resource
//             usingParameters:nil
//                 withAccount:nil
//      sendingProgressHandler:nil
//             responseHandler:handler];
//    
//    
//}
//- (AVPlayer *)getAVPlayer {
//    
//    // extract playlist info from soundcloud
//    [self setTracksArray];
//    
//    // Collect all the tracks into one array
//    self.tracksRelevantInfoArray = [[NSMutableArray alloc] init];
//    for (NSDictionary *trackDict in self.tracks) {
//        NSString *streamUrl = [NSString stringWithFormat:@"%@?client_id=%@", [trackDict objectForKey:@"stream_url" ], self.clientID];
//        NSString *title = [NSString stringWithFormat:@"%@", [trackDict objectForKey:@"title"]];
//        NSArray *relevantInfos = @[streamUrl, title];
//        NSLog(@"%@", relevantInfos);
//        
//        [self.tracksRelevantInfoArray addObject:relevantInfos];
//        
//    }
//    
//    // get the track info
//    NSString *streamURL = self.tracksRelevantInfoArray[0];
//    NSLog(@"playing track: %@", streamURL);
//    
//    // make a request handler to read in json response
//    SCRequestResponseHandler handler;
//    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
//        
//        // set the player
//        NSError *playerError;
//        self.player = [[AVPlayer alloc] initWithURL:[[NSURL alloc] initWithString: streamURL]];
////        self.player = [[AVPlayer alloc] initWithData:data error:&playerError];
//        NSLog(@"playerError: %@", [playerError localizedDescription ]);
//    };
//    
//    // return the player
//    return self.player;
//}
//
//
//
//- (NSString *)fetchPlaylistsForLocation:(NSString *)location {
//    NSLog(@"fetched playlist");
//    
//    return @"this function got called!";
//}
//
//- (void) initializeSoundCloud {
//    NSLog(@"self.clientID: %@", self.clientID);
//    NSLog(@"self.secret: %@", self.secret);
//    [SCSoundCloud setClientID:self.clientID
//                       secret:self.secret
//                  redirectURL:[NSURL URLWithString:self.redirectURI]];
//    
//    NSLog(@"soundcloud initalized");
//}
//
//@end

//
//  SoundCloudHandler.m
//  MASSIVE
//
//  Created by Faiyam Rahman on 10/30/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

#import "SoundCloudHandler.h"
#import "SCUI.h"
#import <AVFoundation/AVFoundation.h>
#import "MASSIVE-Swift.h"

@interface SoundCloudHandler ()

// Soundcloud app-specific constants
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *redirectURI;

// the guy who'll play our songs, and his companion data function
@property (nonatomic, strong) AVPlayer *player;
// each element is (streamURL, trackTitle)
@property (nonatomic, strong) NSMutableArray *tracksRelevantInfoArray;
@property (nonatomic) NSUInteger trackIndex;

// the view controller that communicates song data to the view
@property (nonatomic, strong) playerVC *ppvC;

- (void)playTracks:(NSArray *) tracksArray;
/*
 Given a tracks array of dictionaries of that correspond to json encodings
 of track info from the soundcloud api, opens the play page and starts
 playing the playlist from track 0
 */

- (void) playTrack:(NSArray *)trackInfo;
/*
 Given an array of format (stream_url, title, etc), play the song
 and display relevant information!
 */

- (void) stop;

- (void)dummyFunction:(NSArray *)tracks;

@property (nonatomic, strong) NSArray *tracks;
@end

@implementation SoundCloudHandler

- (void) setViewController:(UIViewController *)viewController{
    self.ppvC = (playerVC *)viewController;
    
}
-(id)init {
    
    // set soundcloud specific constants
    NSLog(@"running init code");
    // IMAXMassive
        self.clientID = @"7e4a3481d659fbcd9667741811dfa4ee";
        self.secret = @"ad15980c012fd968f0e33784e25b4551";
        self.redirectURI = @"IMAXMassive://oauth";
    // misterMIXTER
//    self.clientID = @"2969820eb1647bc78367d836a714710a";
//    self.secret = @"fde4df706bb48a58cb3b04f7cde686f9";
//    self.redirectURI = @"mrMixter://oauth";
    
    
    return self;
}

- (void) pause {
    [self.player pause];
    
}
- (void) stop {
//    [self.player stop];
}

- (void) nextSong {
    if (self.trackIndex <= self.tracksRelevantInfoArray.count) {
        [self stop];
        
        self.trackIndex += 1;
        [self playTrack:self.tracksRelevantInfoArray[self.trackIndex]];
    }
    else {
        [self stop];
    }
    
}
- (void) previousSong {
    if (self.trackIndex > 0) {
        self.trackIndex -= 1;
        [self playTrack:self.tracksRelevantInfoArray[self.trackIndex]];
    }
    
}

- (void) playTrack:(NSArray *)trackInfo {
    NSString *streamURL = trackInfo[0];
    NSLog(@"playing track: %@", streamURL);
    // tell our view controller what we are playing
//    self.ppvC.songTitle.text = trackInfo[1];
    
    // make a request handler to read in json response
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        //play the audio file
        NSError *playerError;
//        self.player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
//        NSLog(@"playerError: %@", [playerError localizedDescription ]);
//        [self.player prepareToPlay];
//        [self.player play];
    };
    
    
    // get the song
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:streamURL]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler];
    
}
- (void)playTracks:(NSArray *) tracksArray {
    self.tracksRelevantInfoArray = [[NSMutableArray alloc] init];
    
    // Collect all the tracks into one array
    for (NSDictionary *trackDict in tracksArray) {
        NSString *streamUrl = [NSString stringWithFormat:@"%@?client_id=%@", [trackDict objectForKey:@"stream_url" ], self.clientID];
        NSString *title = [NSString stringWithFormat:@"%@", [trackDict objectForKey:@"title"]];
        NSArray *relevantInfos = @[streamUrl, title];
        NSLog(@"%@", relevantInfos);
        
        [self.tracksRelevantInfoArray addObject:relevantInfos];
        
    }
    
    self.trackIndex = 0;
    [self playTrack:self.tracksRelevantInfoArray[self.trackIndex]];
    
}

- (NSString *)fetchPlaylistsForLocation:(NSString *)location {
    NSLog(@"fetched playlist");
    
    return @"this function got called!";
}

- (void) getAVPlayer {
//- (void)playPlaylist:(NSInteger) whichPlaylist {
    [self initializeSoundCloud];
    
    // open up a new page
    
    
    // Create a request handler to receive the json response
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        assert(data != nil);
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        if (!jsonError && [jsonResponse isKindOfClass:[NSDictionary class]]) {
            NSLog(@"succesffuly retrieved playlist");
            
            NSArray *tracks = [(NSDictionary *)jsonResponse objectForKey:@"tracks"];
            
            self.tracks = tracks;
            NSLog(@"%@", self.tracks);
            [self dummyFunction:self.tracks];
            
        }
        else {
            NSLog(@"something didn't work");
            NSLog(@"%@", [jsonError localizedDescription]);
        }
    };
    
    // Ping the api for the desired playlist
    NSString *resourceURL = [NSString stringWithFormat:@"https://api.soundcloud.com/playlists/53537234.json?client_id=%@", self.clientID ];
//    NSString *resourceURL = @"https://api.soundcloud.com/playlists/53537234.json?client_id=7e4a3481d659fbcd9667741811dfa4ee";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler];
    
}

//- (AVPlayer *)getAVPlayer {
//    AVPlayer *avPlayer;
//    
//    [self setTracksArray];

//    while (self.tracks == nil) {
//        NSLog(@"waiting");
//    }
//    NSLog(@"lets print self.tracks in getAVPPlayer");
//    NSLog(@"%@", self.tracks);

    // Collect all the tracks into one array
//    self.tracksRelevantInfoArray = [[NSMutableArray alloc] init];
//    
//    for (NSDictionary *trackDict in self.tracks) {
//        NSString *streamUrl = [NSString stringWithFormat:@"%@?client_id=%@", [trackDict objectForKey:@"stream_url" ], self.clientID];
//        NSString *title = [NSString stringWithFormat:@"%@", [trackDict objectForKey:@"title"]];
//        NSArray *relevantInfos = @[streamUrl, title];
//        NSLog(@"%@", relevantInfos);
//    
//        [self.tracksRelevantInfoArray addObject:relevantInfos];
//    
//    }
//    
//        // get the track info
//        NSString *streamURL = self.tracksRelevantInfoArray[0];
//        NSLog(@"playing track: %@", streamURL);
    
//        // make a request handler to read in json response
//        SCRequestResponseHandler handler;
//        handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
//    
//            // set the player
//            NSError *playerError;
//            avPlayer = [[AVPlayer alloc] initWithURL:[[NSURL alloc] initWithString: streamURL]];
//    //        self.player = [[AVPlayer alloc] initWithData:data error:&playerError];
//            NSLog(@"playerError: %@", [playerError localizedDescription ]);
//        };
    
        // return the player
//        return self.player;
    
//    return avPlayer;
//}

- (void)dummyFunction:(NSArray *)tracks {
    
    NSLog(@"printing self.tracks in dummy function");
    NSLog(@"%@", self.tracks);
    
    // Collect  all the tracks into one array
    self.tracksRelevantInfoArray = [[NSMutableArray alloc] init];
    for (NSDictionary *trackDict in self.tracks) {
        NSString *streamUrl = [NSString stringWithFormat:@"%@?client_id=%@", [trackDict objectForKey:@"stream_url" ], self.clientID];
        NSString *title = [NSString stringWithFormat:@"%@", [trackDict objectForKey:@"title"]];
        NSArray *relevantInfos = @[streamUrl, title];
        NSLog(@"%@", relevantInfos);
    
        [self.tracksRelevantInfoArray addObject:relevantInfos];
            
    }
    
    // get the track info
    NSArray *streamInfo = self.tracksRelevantInfoArray[0];
    NSString *streamURL = streamInfo[0];
    NSLog(@"playing track: %@", streamURL);

    // make a request handler to read in json response
    SCRequestResponseHandler handler2;
    handler2 = ^(NSURLResponse *response, NSData *data, NSError *error) {

        // set the player
        NSError *playerError;
        NSMutableArray *playerItems = [[NSMutableArray alloc] init];
        for (NSArray *info in self.tracksRelevantInfoArray) {
            NSString *streamUrl = info[0];
            AVPlayerItem *nextItem = [AVPlayerItem playerItemWithURL:[[NSURL alloc]initWithString: streamUrl]];
//            nextItem.canStepForward = tråue;
//            nextItem.canStepBackward = true;
            [playerItems addObject:nextItem];
        }
//        AVPlayerItem *firstItem = [AVPlayerItem playerItemWithURL: [[NSURL alloc] initWithString: streamURL]];
        NSLog(@"%@", playerItems);
        AVQueuePlayer *queuePlayer = [[AVQueuePlayer alloc] initWithItems:playerItems];
//        self.player = [[AVPlayer alloc] initWithURL:[[NSURL alloc] initWithString: streamURL]];
        self.player = queuePlayer;
        NSLog(@"playerError: %@", [playerError localizedDescription ]);
        self.ppvC.player = self.player;
        NSLog(@"%@", self.player);

        [self.ppvC.player play];
    };
    
    // get the song
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:streamURL]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler2];
    
    
    ;
}
- (void) initializeSoundCloud {
    NSLog(@"self.clientID: %@", self.clientID);
    NSLog(@"self.secret: %@", self.secret);
    [SCSoundCloud setClientID:self.clientID
                       secret:self.secret
                  redirectURL:[NSURL URLWithString:self.redirectURI]];
    
    NSLog(@"soundcloud initalized");
}

// Probably correct authentication url
// the curl call to get access tokens
// curl -X POST "https://api.soundcloud.com/oauth2/token" -F "username=frahman305@gmail.com" -F "grant_type=password" -F "client_id=7e4a3481d659fbcd9667741811dfa4ee" -F "client_secret=ad15980c012fd968f0e33784e25b4551" -F "password=mixter25"
// token should last for 6 hours (21599 seconds).
// if you use this call, then the token doesn't expire
// curl -X POST"https://api.soundcloud.com/oauth2/token" -F "username=frahman305@gmail.com" -F "grant_type=password" -F "client_id=7e4a3481d659fbcd9667741811dfa4ee" -F "client_secret=ad15980c012fd968f0e33784e25b4551" -F "password=mixter25" -F "scope=non-expiring"
@end

