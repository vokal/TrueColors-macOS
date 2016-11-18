//
//  AppDelegate.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUAppDelegate.h"

@import HockeySDK;
@import Sparkle;

#import <DCOAboutWindowController.h>

#import "TRUPreferencesWindowController.h"

#import "TRULocalizedString.h"

@interface TRUAppDelegate () <SUUpdaterDelegate>

@property (nonatomic, strong) DCOAboutWindowController *aboutWindowController;

@end

@implementation TRUAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *__unused)aNotification
{
    [BITHockeyManager.sharedHockeyManager configureWithIdentifier:@"e2a44471302146ef8a121891f117f358"];
    [BITHockeyManager.sharedHockeyManager startManager];
    SUUpdater.sharedUpdater.sendsSystemProfile = YES;
}

- (DCOAboutWindowController *)aboutWindowController
{
    if (!_aboutWindowController) {
        _aboutWindowController = [[DCOAboutWindowController alloc] init];
        _aboutWindowController.appWebsiteURL = [NSURL URLWithString:@"https://github.com/vokal/TrueColors-macOS"];
        _aboutWindowController.acknowledgmentsPath = [NSBundle.mainBundle pathForResource:@"Acknowledgements"
                                                                                   ofType:@"html"];
        _aboutWindowController.appVersion = [TRULocalizedString appVersionWithShortVersionString:NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"]];
        _aboutWindowController.useTextViewForAcknowledgments = YES;
    }
    return _aboutWindowController;
}

- (IBAction)about:(id)sender
{
    [self.aboutWindowController showWindow:sender];
}

- (IBAction)preferences:(id)sender
{
    [TRUPreferencesWindowController.preferencesWindowController showWindow:sender];
}

#pragma mark - SUUpdaterDelegate

- (NSArray *)feedParametersForUpdater:(SUUpdater *__unused)updater
                 sendingSystemProfile:(BOOL __unused)sendingProfile
{
    return BITSystemProfile.sharedSystemProfile.systemUsageData;
}

@end
