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

@interface SoundCloudHandler ()

// Soundcloud app-specific constants
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *secret;

// the guy who'll play our songs!
@property (nonatomic, strong) AVAudioPlayer *player;


- (void)playTracks:(NSArray *) tracksArray;
/* NSArrayOfNSDictionarys -> Nil
 
 Given a tracks array of dictionaries of that correspond to json encodings
 of track info from the soundcloud api, opens the play page and starts 
 playing the playlist from track 0
 
 */

- (void) playTrack:(NSString *)streamURL;

@end

@implementation SoundCloudHandler

-(id)init {
    NSLog(@"running init code");
    self.clientID = @"7e4a3481d659fbcd9667741811dfa4ee";
    self.secret = @"ad15980c012fd968f0e33784e25b4551";
    
    return self;
}

- (void) playTrack:(NSString *)streamURL {
    NSLog(@"playing track: %@", streamURL);
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
    
    NSString *trackURL = [NSString stringWithFormat:@"%@?client_id=%@", [tracksArray[0] objectForKey:@"stream_url" ], self.clientID];
    [self playTrack:trackURL];
//    for (NSDictionary *trackDict in tracksArray) {
//        NSString *trackURL = [NSString stringWithFormat:@"%@.json?client_id=%@", [trackDict objectForKey:@"stream_url" ], self.clientID];
//        
//        [self playTrack:trackURL];
    
//    }
}

- (NSString *)fetchPlaylistsForLocation:(NSString *)location {
    NSLog(@"fetched playlist");
    
    return @"this function got called!";
}

- (void)playPlaylist:(NSInteger) whichPlaylist {
    [self initializeSoundCloud];

    // open up a new page
    
    
    // Create a request handler to receive the json response
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        if (!jsonError && [jsonResponse isKindOfClass:[NSDictionary class]]) {
            NSLog(@"succesffuly retrieved playlist");
            
            NSArray *tracks = [(NSDictionary *)jsonResponse objectForKey:@"tracks"];
            [self playTracks:tracks];
            
        }
        else {
            NSLog(@"something didn't work");
            NSLog(@"%@", [jsonError localizedDescription]);
        }
    };
    
    // Ping the api for the desired playlist
    NSString *resourceURL = @"https://api.soundcloud.com/playlists/53537234.json?client_id=7e4a3481d659fbcd9667741811dfa4ee";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler];
    
    
}
- (void) initializeSoundCloud {
    [SCSoundCloud setClientID:self.clientID
                       secret:self.secret
                  redirectURL:[NSURL URLWithString:@"IMAXMassive://oauth"]];
    
    NSLog(@"soundcloud initalized");
}

@end
