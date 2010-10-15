//
//  PreferenceWindowController.m
//  Golipse
//
//  Created by David LeBer on 10-10-12.
//  Copyright 2010 Align Software Inc. All rights reserved.
//

#import "PreferenceWindowController.h"
#import "NSView-LayoutAdditions.h"

@implementation PreferenceWindowController

@synthesize eclipseUrlLabel;
@synthesize eclipseUrl;

- (void) awakeFromNib;
{
	self.eclipseUrlLabel.stringValue = NSLocalizedString(@"Eclipse URL", @"Eclipse archive download URL");
	self.window.title = NSLocalizedString(@"Preferences", @"Golipse Preferences Window");
	
	[self.eclipseUrlLabel sizeToFit];
	[self.eclipseUrl moveNextToView:self.eclipseUrlLabel withSpace:5.0 stretch:YES];
	
}
@end
