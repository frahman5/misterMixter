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
@property (nonatomic, strong) NSArray *tracks;

// the view controller that communicates song data to the view
@property (nonatomic, strong) playerVC *ppvC;


- (void)setTracksArray;

@end

@implementation SoundCloudHandler

- (void) setViewController:(UIViewController *)viewController{
    self.ppvC = (playerVC *)viewController;
}

-(id)init {
    
    // set soundcloud specific constants
    NSLog(@"running init code");
    
    // IMAXMassive
//    self.clientID = @"7e4a3481d659fbcd9667741811dfa4ee";
//    self.secret = @"ad15980c012fd968f0e33784e25b4551";
//    self.redirectURI = @"IMAXMassive://oauth";
    // misterMIXTER
    self.clientID = @"2969820eb1647bc78367d836a714710a";
    self.secret = @"fde4df706bb48a58cb3b04f7cde686f9";
    self.redirectURI = @"mrMixter://oauth";

    
    return self;
}



- (void)setTracksArray {
    NSLog(@"Ran setTracksArray");
    
    [self initializeSoundCloud];
    
    // Create a request handler to receive the json response
    SCRequestResponseHandler handler;
    
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
    
    // Ping the api for the desired playlist
    NSString *resourceURL = [NSString stringWithFormat:@"https://api.soundcloud.com/playlists/53537234.json?client_id=%@", self.clientID ];
    NSURL *resource = [[NSURL alloc] initWithString:resourceURL];
    NSLog(@"%@", resource);
    NSLog(@"resource URL: %@", resourceURL);
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:resource
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler];
    
    
}
- (AVPlayer *)getAVPlayer {
    
    // extract playlist info from soundcloud
    [self setTracksArray];
    
    // Collect all the tracks into one array
    self.tracksRelevantInfoArray = [[NSMutableArray alloc] init];
    for (NSDictionary *trackDict in self.tracks) {
        NSString *streamUrl = [NSString stringWithFormat:@"%@?client_id=%@", [trackDict objectForKey:@"stream_url" ], self.clientID];
        NSString *title = [NSString stringWithFormat:@"%@", [trackDict objectForKey:@"title"]];
        NSArray *relevantInfos = @[streamUrl, title];
        NSLog(@"%@", relevantInfos);
        
        [self.tracksRelevantInfoArray addObject:relevantInfos];
        
    }
    
    // get the track info
    NSString *streamURL = self.tracksRelevantInfoArray[0];
    NSLog(@"playing track: %@", streamURL);
    
    // make a request handler to read in json response
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // set the player
        NSError *playerError;
        self.player = [[AVPlayer alloc] initWithURL:[[NSURL alloc] initWithString: streamURL]];
//        self.player = [[AVPlayer alloc] initWithData:data error:&playerError];
        NSLog(@"playerError: %@", [playerError localizedDescription ]);
    };
    
    // return the player
    return self.player;
}



- (NSString *)fetchPlaylistsForLocation:(NSString *)location {
    NSLog(@"fetched playlist");
    
    return @"this function got called!";
}

- (void) initializeSoundCloud {
    NSLog(@"self.clientID: %@", self.clientID);
    NSLog(@"self.secret: %@", self.secret);
    [SCSoundCloud setClientID:self.clientID
                       secret:self.secret
                  redirectURL:[NSURL URLWithString:self.redirectURI]];
    
    NSLog(@"soundcloud initalized");
}

@end
