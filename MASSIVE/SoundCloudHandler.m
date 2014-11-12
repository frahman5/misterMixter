//
//  SoundCloudHandler.m
//  MASSIVE
//
//  Created by Faiyam Rahman on 10/30/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

#import "SoundCloudHandler.h"                   // public properties/functions
#import "SCUI.h"                                // soundcloud api
#import <AVFoundation/AVFoundation.h>           // playing audio files
#import "MASSIVE-Swift.h"                       // bridge to swift functions

@interface SoundCloudHandler ()

// dictionary of location: playlistDictionary pairs
@property (nonatomic, strong) NSMutableDictionary *locationPlaylistDictionary;

// Soundcloud app-specific constants
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *redirectURI;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *masterUsername;
@property (nonatomic, strong) NSString *masterPassword;

// the guy who'll play our songs, and his companion data function
@property (nonatomic, strong) AVAudioPlayer *player;
// each element is (streamURL, trackTitle)
@property (nonatomic, strong) NSMutableArray *tracksRelevantInfoArray;
@property (nonatomic) NSUInteger trackIndex;


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

// The guy who authenticates us to soundcloud
- (void)authenticateMasterAccount;

@property (nonatomic, strong) NSArray *tracks;

@end

@implementation SoundCloudHandler

-(id)init {
    
    // set soundcloud specific constants
    // IMAXMassive account
        self.clientID = @"7e4a3481d659fbcd9667741811dfa4ee";
        self.secret = @"ad15980c012fd968f0e33784e25b4551";
        self.redirectURI = @"IMAXMassive://oauth";
    // misterMIXTER account
//    self.clientID = @"2969820eb1647bc78367d836a714710a";
//    self.secret = @"fde4df706bb48a58cb3b04f7cde686f9";
//    self.redirectURI = @"mrMixter://oauth";
    
    // master soundcloud account
    self.masterUsername = @"yannis.tsampalis@live.com";
    self.masterPassword = @"xesee3w";
    
    // authenticate us baby
    [self authenticateMasterAccount];
    
    // set up the dictionary where we hold playlists
    self.locationPlaylistDictionary = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void) pause {
    [self.player pause];
    
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
        self.player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
        NSLog(@"playerError: %@", [playerError localizedDescription ]);
        [self.player prepareToPlay];
        [self.player play];
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
//        NSLog(@"%@", relevantInfos);
        
        [self.tracksRelevantInfoArray addObject:relevantInfos];
        
    }
    
    self.trackIndex = 0;
    [self playTrack:self.tracksRelevantInfoArray[self.trackIndex]];
    
}

- (NSString *)fetchPlaylistsForLocation:(NSString *)location {
    NSLog(@"fetched playlist");
    
    return @"this function got called!";
}

//- (void) getAVPlayer {
- (void)playPlaylist:(NSString *) playlistURI {
    /*
       Given the universal resource identifier for a soundcloud playlist, 
       fetches the corresponding tracks and calls "playTracks" to play them
     */
    
    // Edit the URI to ask for a JSON Response, and tell the API who we are
    playlistURI = [playlistURI stringByAppendingFormat: @".json?client_id=%@", self.clientID];

    // Create a request handler to receive the json response
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // can't be having empty data yo
        assert(data != nil);
        
        // Convert the response data into a JSON readable object
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        // If all went well, extract the tracks and play them
        if (!jsonError && [jsonResponse isKindOfClass:[NSDictionary class]]) {
            
            NSLog(@"succesffuly retrieved playlist");
            
            // extract tracks
            NSArray *tracks = [(NSDictionary *)jsonResponse objectForKey:@"tracks"];
            self.tracks = tracks;
            
            // play tracks
            [self playTracks:self.tracks];
            
        }
        
        // otherwise cry
        else {
            NSLog(@"something didn't work");
            NSLog(@"%@", [jsonError localizedDescription]);
        }
    };
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:playlistURI]
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


- (void) initializeSoundCloud {
    NSLog(@"self.clientID: %@", self.clientID);
    NSLog(@"self.secret: %@", self.secret);
    [SCSoundCloud setClientID:self.clientID
                       secret:self.secret
                  redirectURL:[NSURL URLWithString:self.redirectURI]];
    
    NSLog(@"soundcloud initalized");
}

- (NSArray *)getPlaylists:(NSArray *)locationArray {
    NSArray *playlistArray;
    
    // make sure we have authenticated by checking for an access token
    NSAssert(self.accessToken, @"can't get playlists without an access token buddy!");
    
    NSString *apiCallString = [NSString stringWithFormat:@"https://api.soundcloud.com/me/playlists.json?oauth_token=%@", self.accessToken];
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            NSLog(@"sucessfully retrieved playlists for our account");
            NSArray *arrayResponse = (NSArray *)jsonResponse;
            
            // initalize dictionary with locationKey: mutableArray pairs
            for (NSString *locationString in locationArray) {
                [self.locationPlaylistDictionary setObject:[[NSMutableArray alloc] init] forKey:locationString];
            }
//            NSLog(@"inital location playlist dictionary: %@", self.locationPlaylistDictionary);
            
            // lowercase and remove spaces in the locationArray to make comparisons easier
//            NSLog(@"location array before lowercasing: %@", locationArray);
            NSArray *lowercaseArray = [locationArray valueForKey:@"lowercaseString"];
//            NSLog(@"location array after lowercasing: %@", lowercaseArray);
            NSMutableArray *lowercaseAndSpacelessLocationArray = [[NSMutableArray alloc] init];
            for (NSString *lowercaseLocation in lowercaseArray) {
                [lowercaseAndSpacelessLocationArray addObject:[lowercaseLocation stringByReplacingOccurrencesOfString:@" " withString:@""]];
            }
//            NSLog(@"location array after lowercasing and removing whitespaces: %@", lowercaseAndSpacelessLocationArray);
            // scan through playlists to find the relevant ones
            for (NSDictionary *playlistDict in arrayResponse) {
                
                // get the tags
                NSString *tags = [playlistDict objectForKey:@"tag_list"];
                NSLog(@"tags: %@", tags);
                
                NSInteger index = 0;
                for (NSString *location in lowercaseAndSpacelessLocationArray) {
                    NSRange substringRange = [tags rangeOfString:location options:NSCaseInsensitiveSearch];
                    if (substringRange.length > 0) {
                        // we have a match
                        [[self.locationPlaylistDictionary objectForKey:locationArray[index]] addObject:playlistDict];
                    }
                    index += 1;
                }
            }
            // celebrate
//            NSLog(@"printing dictionary of playlists");
//            NSLog(@"%@", self.locationPlaylistDictionary);
            
            // tell the app that we got the playlists
            [[NSNotificationCenter defaultCenter] postNotificationName:@"foundPlaylists"
                                                                object:self
                                                              userInfo:self.locationPlaylistDictionary];
            

            
        }
        else {
            NSLog(@"Playlist retrieval failed");
            NSLog(@"%@", [jsonError localizedDescription]);
        }
    };

    // get the playlists
    NSLog(@"access token: %@", self.accessToken);
    NSLog(@"api call: %@", apiCallString);
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:apiCallString]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler];
    
    return playlistArray;
}

- (void)authenticateMasterAccount {
    // setup
    NSURL *authenticationEndpointURL = [NSURL URLWithString:@"https://api.soundcloud.com/oauth2/token"];
    NSDictionary *parameters = @{
                                 @"username": self.masterUsername,
                                 @"grant_type": @"password",
                                 @"client_id": self.clientID,
                                 @"client_secret": self.secret,
                                 @"password": self.masterPassword,
                                 @"scope": @"non-expiring"
                                 };
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        if (!jsonError && [jsonResponse isKindOfClass:[NSDictionary class]]) {
            NSLog(@"sucessfully authenticated");
            
            self.accessToken = [(NSDictionary *)jsonResponse objectForKey:@"access_token"];
            NSLog(@"acceess token: %@", self.accessToken);
            
            NSAssert(self.accessToken, @"self.accessToken is nil!");
            self.hasAccessToken = YES;
            
            // tell the master app that we have the access token
            [[NSNotificationCenter defaultCenter] postNotificationName:@"accessToken"
                                                                object:self
                                                              userInfo:nil];
            
            
        }
        else {
            NSLog(@"Authentication failed");
            NSLog(@"%@", [jsonError localizedDescription]);
        }
    };
    
    // api call
    
    
    [SCRequest performMethod:SCRequestMethodPOST
                  onResource:authenticationEndpointURL
             usingParameters:parameters
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler ];
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
@end

