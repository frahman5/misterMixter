//
//  SoundCloudHandler.m
//  MASSIVE
//
//  Created by Faiyam Rahman on 10/30/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

#import "SoundCloudHandler.h"                   // public properties/functions
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

// the guy who'll play our songs, and his companion data functions
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
 Given an array of format (stream_url, title, artist), play the song
 and tell the view controller to display relevant information!
 */

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
    self.masterPassword = @"xesemesa";
    
    // authenticate us baby
    [self authenticateMasterAccount];
//    self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
//    if (self.accessToken == nil) {
//        NSLog(@"Got the access token by calling the api");
//        [self authenticateMasterAccount];
//    } else {
//        NSLog(@"Got the access token from NSUserDefaults: %@", self.accessToken);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"accessToken"
//                                                            object:self
//                                                          userInfo:nil];
//    }
    
    // set up the dictionary where we hold playlists
    self.locationPlaylistDictionary = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void) pause {
    [self.player pause];
    
}

- (void) play {
    [self.player play];
    
}

- (void) playTrack:(NSArray *)trackInfo {
    
    // Extract the streaming URL
    NSString *streamURL = trackInfo[0];
    NSLog(@"playing track: %@", streamURL);
    
    // make a request handler to read in json response
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSLog(@"we made the call to play the track");
        
        //play the audio file
        NSError *playerError;
        self.player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
        NSLog(@"playerError: %@", [playerError localizedDescription ]);
        [self.player prepareToPlay];
        [self.player play];
        
        // tell the PlayPageViewController what to display
        NSString *title = trackInfo[1];
        NSDictionary *trackInfo = @{@"title": title};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTrackInfo"
                                                            object:nil
                                                          userInfo:trackInfo];
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
        NSLog(@"%@", trackDict);
        NSString *streamUrl = [NSString stringWithFormat:@"%@?client_id=%@", [trackDict objectForKey:@"stream_url" ], self.clientID];
        NSString *title = [NSString stringWithFormat:@"%@", [trackDict objectForKey:@"title"]];
        NSArray *relevantInfos = @[streamUrl, title];
//        NSLog(@"%@", relevantInfos);
        
        [self.tracksRelevantInfoArray addObject:relevantInfos];
        
    }
    
    self.trackIndex = 0;
    [self playTrack:self.tracksRelevantInfoArray[self.trackIndex]];
    
}

- (void)playPlaylist:(NSString *) playlistURI {
    /*
       Given the universal resource identifier for a soundcloud playlist, 
       fetches the corresponding tracks and calls "playTracks" to play them
     */

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
    
    // Edit the URI to ask for a JSON Response, and tell the API who we are
    playlistURI = [playlistURI stringByAppendingFormat: @".json?client_id=%@", self.clientID];
    
    // make the actual API call
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:playlistURI]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler];
    
}



- (void) initializeSoundCloud {
    /*
     Simply tells the relevant soundcloud objects who we are
     */
    [SCSoundCloud setClientID:self.clientID
                       secret:self.secret
                  redirectURL:[NSURL URLWithString:self.redirectURI]];
}

- (void)getPlaylists:(NSArray *)locationArray {
    
    // make sure we have authenticated by checking for an access token
    NSAssert(self.accessToken, @"can't get playlists without an access token buddy!");
    
    // create a handler to respond to the request
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // create a JSON reading object to convert the data to something readable
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        // all went well, lets get some playlists!
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            NSLog(@"sucessfully retrieved playlists for our account");
            
            // cast the response as an array
            NSArray *arrayResponse = (NSArray *)jsonResponse;
            
            // initalize dictionary with locationKey: mutableArray pairs
            for (NSString *locationString in locationArray) {
                [self.locationPlaylistDictionary setObject:[[NSMutableArray alloc] init]
                                                    forKey:locationString];
            }
            
            // lowercase and remove spaces in the locationArray to make comparisons easier
            // e.g Cornell Tech -> cornelltech
            NSArray *lowercaseArray = [locationArray valueForKey:@"lowercaseString"];
            NSMutableArray *lowercaseAndSpacelessLocationArray = [[NSMutableArray alloc] init];
            for (NSString *lowercaseLocation in lowercaseArray) {
                [lowercaseAndSpacelessLocationArray addObject:[lowercaseLocation stringByReplacingOccurrencesOfString:@" " withString:@""]];
            }
            
            
            // scan through playlists to find the ones tagged with our locations
            for (NSDictionary *playlistDict in arrayResponse) {
                
                // get the tags for that playlist
                NSString *tags = [playlistDict objectForKey:@"tag_list"];
                
                // iterate through the locations and see if any tags match
                NSInteger index = 0;                    // 0-> location0, 1-> location1, etc
                for (NSString *location in lowercaseAndSpacelessLocationArray) {
                    
                    // do we have a match?
                    NSRange substringRange = [tags rangeOfString:location options:NSCaseInsensitiveSearch];
                    
                    // match found
                    if (substringRange.length > 0) {
                        // add the playlist to our dictionary
                        [[self.locationPlaylistDictionary objectForKey:locationArray[index]] addObject:playlistDict];
                    }
                    
                    // make sure we're moving through playlists
                    index += 1;
                }
            }
            
            // tell the firstViewController that we got our playlists so it can populate the tableView
            [[NSNotificationCenter defaultCenter] postNotificationName:@"foundPlaylists"
                                                                object:self
                                                              userInfo:self.locationPlaylistDictionary];
            
        }
        
        // something went wrong. Cry.
        else {
            NSLog(@"Playlist retrieval failed");
            NSLog(@"%@", [jsonError localizedDescription]);
        }
    };
    
    // this api call string retrieves all playlists on the master account
    NSString *apiCallString = [NSString stringWithFormat:@"https://api.soundcloud.com/me/playlists.json?oauth_token=%@", self.accessToken];
    
    // make the actual api call
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:apiCallString]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler];
}

- (void)authenticateMasterAccount {
    /*
     Asks for an access token for the master account, so we can "sign in" to it
     and keep asking the api questions about its contents, without having to
     have the user need to do anything on his side.
     */
    
    // Create a request handler to handle the API's response
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // Create a JSON reading object to interpret the response
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        // All went well. Let's rock and roll!
        if (!jsonError && [jsonResponse isKindOfClass:[NSDictionary class]]) {
            NSLog(@"sucessfully authenticated");
            
            // Set our access token baby
            self.accessToken = [(NSDictionary *)jsonResponse objectForKey:@"access_token"];
            NSLog(@"%@", (NSDictionary *)jsonResponse);
            NSAssert(self.accessToken, @"self.accessToken is nil!");
            
            // store the accessToken in NSUserDefaults
            [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // tell the firstViewController that we have the access token
            NSLog(@"got access token");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"accessToken"
                                                                object:self
                                                              userInfo:nil];

        }
        
        // Something went wrong. Cry
        else {
            NSLog(@"Authentication failed");
            NSLog(@"%@", [jsonError localizedDescription]);
        }
    };
    
    // Set the URL and parameters that allow us to authenticate
    NSURL *authenticationEndpointURL = [NSURL URLWithString:@"https://api.soundcloud.com/oauth2/token"];
    NSDictionary *parameters = @{
                                 @"username": self.masterUsername,
                                 @"grant_type": @"password",
                                 @"client_id": self.clientID,
                                 @"client_secret": self.secret,
                                 @"password": self.masterPassword,
                                 @"scope": @"non-expiring"
                                 };
    
    // Make the actual API Call to authenticate us!
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

