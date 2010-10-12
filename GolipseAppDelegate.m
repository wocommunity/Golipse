//
//  GolipseAppDelegate.m
//  Golipse
//
//  Created by David LeBer on 10-10-09.
//  Copyright 2010 Align Software Inc. All rights reserved.
//

#import "GolipseAppDelegate.h"
#import "PreferenceWindowController.h"

@implementation GolipseAppDelegate

@synthesize window;
@synthesize installLocationPicker;
@synthesize installLocationLabel;
@synthesize installNowButton;
@synthesize logScrollView;
@synthesize logTextView;
@synthesize installTask;
@synthesize logPipe;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self.window makeKeyAndOrderFront:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(installTaskDidFinish:) 
												 name:NSTaskDidTerminateNotification 
											   object:self.installTask];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (void) awakeFromNib;
{
	NSLog(@"Awake");
	[self setupInstallLocationWithPath:kCurrentInstallLocation];
	[self.installLocationLabel setStringValue:NSLocalizedString(@"Install Location", @"")];
	[self.installNowButton setTitle:NSLocalizedString(@"Go!", @"")];
	[self.logTextView setEditable:NO];
	[self.logTextView setFont:[NSFont fontWithName:@"courier" size:0.0]];
	
	userDidCancel = NO;
}

#pragma mark -
#pragma mark Install

- (IBAction) installWOLipsAction:(id)sender;
{
	if ([self.installNowButton.title isEqualToString:NSLocalizedString(@"Cancel",@"")]) {
		NSLog(@"cancel!");
		userDidCancel = YES;
		[self.installTask terminate];
		return;
	} else
	userDidCancel = NO;
	[self.installNowButton setTitle:NSLocalizedString(@"Cancel",@"")];
	
	NSString *launchPath = [[NSBundle mainBundle] pathForResource:@"go_wolips" ofType:@"sh"];
	NSString *installLocation = [kCurrentInstallLocation stringByAppendingPathComponent:kEclipseName];
	NSString *eclipseURL = kEclipseDownloadURL;
	NSLog(@"Launch Path: %@, %@, %@", launchPath, installLocation, eclipseURL);
	self.installTask = [[NSTask alloc] init];
	self.logPipe = [[NSPipe alloc] init];
	NSFileHandle *handle = nil;
	
	
	
	[self.installTask setLaunchPath:launchPath];
	[self.installTask setArguments:[NSArray arrayWithObjects:installLocation, eclipseURL, nil]];
	[self.installTask setStandardOutput:self.logPipe];
	[self.installTask setStandardError:self.logPipe];
	handle = [self.logPipe fileHandleForReading];
	
	[self.installTask launch];
	
	[self performSelectorInBackground:@selector(copyLogData:) withObject:handle];
}

- (void) installTaskDidFinish:(NSNotification *)note;
{
	NSLog(@"Did finish: %@", note.userInfo);
	[self.installNowButton setTitle:NSLocalizedString(@"Go!", @"")];
	[self.installNowButton setEnabled:YES];
	self.installTask = nil;
	if (userDidCancel) 
	{
		NSString *logSnippet = NSLocalizedString(@"Install canceled by user.", @"");
		[self appendStringToLog:logSnippet];
		userDidCancel = NO;
	}
}

- (void)copyLogData:(NSFileHandle*)handle {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    NSData *data;
	
    while([data=[handle availableData] length]) { // until EOF (check reference)
        NSString *logSnippet=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
		[self performSelectorOnMainThread:@selector(appendStringToLog:) withObject:logSnippet waitUntilDone:YES];
        [logSnippet release];
    }
	
    [pool release];
}

- (void) appendStringToLog:(NSString *)logSnippet;
{
	NSRange theEnd=NSMakeRange([[self.logTextView string] length],0);
	
	[self.logTextView replaceCharactersInRange:theEnd withString:logSnippet]; // append new string to the end
	theEnd.location+=[logSnippet length]; // the end has moved
	[self.logTextView scrollRangeToVisible:theEnd];
}

#pragma mark -
#pragma mark Preference Window

- (IBAction) showPreferenceWindow:(id)sender;
{
	PreferenceWindowController *prefsController = [[PreferenceWindowController alloc] initWithWindowNibName:@"PreferenceWindow"];
	[prefsController showWindow:[prefsController window]];
}

#pragma mark -
#pragma mark Install Location

- (IBAction)chooseInstallLocation:(id)sender;
{
	NSOpenPanel* panel = [NSOpenPanel openPanel];
	[panel setCanChooseFiles:NO];
	[panel setCanChooseDirectories:YES];
	[panel setAllowsMultipleSelection:NO];
	if ([panel respondsToSelector:@selector(setCanCreateDirectories:)])
	{
		[panel setCanCreateDirectories:YES];
	}
	[panel setPrompt:NSLocalizedString(@"Choose", @"")];
	
	[panel beginSheetForDirectory:kCurrentInstallLocation 
							 file:nil 
							types:nil 
				   modalForWindow:[self window] 
					modalDelegate:self
				   didEndSelector:@selector(chooseInstallLocationDidEnd:returnCode:contextInfo:) 
					  contextInfo:nil];
}

- (void)chooseInstallLocationDidEnd: (NSOpenPanel *)panel returnCode: (int)returnCode contextInfo: (void *)contextInfo;
{
	if (returnCode == NSFileHandlingPanelOKButton) 
    {
		NSString* newInstallLocation = [[panel filenames] objectAtIndex:0];
		[[NSUserDefaults standardUserDefaults] setValue:newInstallLocation forKey:kInstallLocationDefaultsKey];
		[self setupInstallLocationWithPath:newInstallLocation];
	}  else {
		[self.installLocationPicker selectItemAtIndex:0]; // Cancel pressed; reselect first item in menu, i.e., the directory
    }
}

- (IBAction)chooseDefaultInstallLocation:(id)sender;
{
	[[NSUserDefaults standardUserDefaults] setValue:kCurrentInstallLocation forKey:kInstallLocationDefaultsKey];
    [self setupInstallLocationWithPath:kCurrentInstallLocation];
}

- (void)setupInstallLocationWithPath:(NSString*)inDLPath;
{
	NSMenuItem* placeholder = [self.installLocationPicker itemAtIndex:0];
	if (!placeholder)
		return;
	NSImage* icon = [[NSWorkspace sharedWorkspace] iconForFile:inDLPath];
	[icon setScalesWhenResized:YES];
	[icon setSize:NSMakeSize(16.0, 16.0)];	
	[placeholder setTitle:[[NSFileManager defaultManager] displayNameAtPath:inDLPath]];
	[placeholder setImage:icon];
	[self.installLocationPicker selectItemAtIndex:0];
}

#pragma mark -

+ (void)initialize;
{
	NSLog(@"Initializing");
	NSString *defaultEclipseURL = [[[NSBundle mainBundle] infoDictionary] objectForKey:kDefaultEclipseDownloadURLKey];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
	NSString *desktopPath = [paths objectAtIndex:0];
	[dictionary setObject:desktopPath forKey:kInstallLocationDefaultsKey];
	[dictionary setObject:defaultEclipseURL forKey:kEclipseDownloadURLDefaultsKey];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:dictionary];
	[[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}


- (void) dealloc;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[logPipe release], logPipe = nil;
	[installLocationPicker release], installLocationPicker = nil;
	[installLocationLabel release], installLocationLabel = nil;
    [installNowButton release], installNowButton = nil;
    [logScrollView release], logScrollView = nil;
	[logTextView release], logTextView = nil;
	[installTask release], installTask = nil;
	[super dealloc];
}

@end
