//
//  GolipseAppDelegate.h
//  Golipse
//
//  Created by David LeBer on 10-10-09.
//  Copyright 2010 Align Software Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GolipseAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSPopUpButton *installLocationPicker;
	NSMenuItem *installLocationOtherItem;
	NSTextField *installLocationLabel;
	NSButton *installNowButton;
	NSScrollView *logScrollView;
	NSTextView *logTextView;
	NSTask *installTask;
	NSPipe *logPipe;
	
	BOOL userDidCancel;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSPopUpButton *installLocationPicker;
@property (nonatomic, retain) IBOutlet NSMenuItem *installLocationOtherItem;
@property (nonatomic, retain) IBOutlet NSTextField *installLocationLabel;
@property (nonatomic, retain) IBOutlet NSButton *installNowButton;
@property (nonatomic, retain) IBOutlet NSScrollView *logScrollView;
@property (nonatomic, retain) IBOutlet NSTextView *logTextView;
@property (nonatomic, retain) NSTask *installTask;
@property (nonatomic, retain) NSPipe *logPipe;

#pragma mark -
#pragma mark Install

- (IBAction) installWOLipsAction:(id)sender;
- (void) installTaskDidFinish:(NSNotification *)note;

- (void) appendStringToLog:(NSString *)logSnippet;

#pragma mark -
#pragma mark Preference Window

- (IBAction) showPreferenceWindow:(id)sender;

#pragma mark -
#pragma mark Install Location

- (IBAction)chooseInstallLocation:(id)sender;
- (void)chooseInstallLocationDidEnd: (NSOpenPanel *)panel returnCode: (int)returnCode contextInfo: (void *)contextInfo;
- (IBAction)chooseDefaultInstallLocation:(id)sender;
- (void)setupInstallLocationWithPath:(NSString*)inDLPath;

@end
