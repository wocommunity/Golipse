//
//  PreferenceWindowController.h
//  Golipse
//
//  Created by David LeBer on 10-10-12.
//  Copyright 2010 Align Software Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferenceWindowController : NSWindowController {

	NSTextField *eclipseUrlLabel;
	NSTextField *eclipseUrl;
	NSButton *resetButton;
	
}

@property (nonatomic, retain) IBOutlet NSTextField *eclipseUrlLabel;
@property (nonatomic, retain) IBOutlet NSTextField *eclipseUrl;
@property (nonatomic, retain) IBOutlet NSButton *resetButton;

- (IBAction) resetURL:(id)sender;

@end
