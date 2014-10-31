//
//  SoundCloudHandler.m
//  MASSIVE
//
//  Created by Faiyam Rahman on 10/30/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

#import "SoundCloudHandler.h"
#import "SCUI.h"

@interface SoundCloudHandler ()

// Soundcloud app-specific constants
@property (nonatomic, strong) NSString *clientID;

- (void)playTracks:(NSArray *) tracksArray;
/* NSArrayOfNSDictionarys -> Nil
 
 Given a tracks array of dictionaries of that correspond to json encodings
 of track info from the soundcloud api, opens the play page and starts 
 playing the playlist from track 0
 
 */
    
@end

@implementation SoundCloudHandler

-(id)init {
    NSLog(@"running init code");
    self.clientID = @"7e4a3481d659fbcd9667741811dfa4ee";
    
    return self;
}

- (void)playTracks:(NSArray *) tracksArray {
    
    for (NSDictionary *trackDict in tracksArray) {
        NSString *trackURL = [NSString stringWithFormat:@"%@?client_id=%@", [trackDict objectForKey:@"stream_url" ], self.clientID];
        NSLog(@"%@", trackURL);
    }
    
    NSLog(@"");
    NSLog(@"%@", [tracksArray[0] objectForKey:@"stream_url" ]);
    
    
    
}

- (NSString *)fetchPlaylistsForLocation:(NSString *)location {
    NSLog(@"fetched playlist");
    
    return @"this function got called!";
}

- (void)playPlaylist:(NSInteger) whichPlaylist {
    [self initializeSoundCloud];

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
            
//            for (NSString *aKey in [(NSDictionary *)jsonResponse allKeys]) {
//                NSLog(aKey);
//            }
            
            NSArray *tracks = [(NSDictionary *)jsonResponse objectForKey:@"tracks"];
            [self playTracks:tracks];
            
//            NSLog(@"%@", tracks);
//            NSLog(@"%u", tracks.count);
//            NSLog(@"%@", [tracks[0] class]);
            
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
    [SCSoundCloud setClientID:@"7e4a3481d659fbcd9667741811dfa4ee"
                       secret:@"ad15980c012fd968f0e33784e25b4551"
                  redirectURL:[NSURL URLWithString:@"IMAXMassive://oauth"]];
    
    NSLog(@"soundcloud initalized");
}

@end
