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

@end

@implementation SoundCloudHandler

- (NSString *)fetchPlaylistsForLocation:(NSString *)location {
    NSLog(@"fetched playlist");
    
    return @"this function got called!";
}

- (void) initializeSoundCloud {
    [SCSoundCloud setClientID:@"7e4a3481d659fbcd9667741811dfa4ee"
                       secret:@"ad15980c012fd968f0e33784e25b4551"
                  redirectURL:[NSURL URLWithString:@"IMAXMassive://oauth"]];
    
    NSLog(@"soundcloud initalized");
}

@end
