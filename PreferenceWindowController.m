//
//  PreferenceWindowController.m
//  Golipse
//
//  Created by David LeBer on 10-10-12.
//  Copyright 2010 Align Software Inc. All rights reserved.
//

#import "PreferenceWindowController.h"


@implementation PreferenceWindowController

@synthesize eclipseUrlLabel;
@synthesize eclipseUrl;

- (void) awakeFromNib;
{
	self.eclipseUrlLabel.stringValue = NSLocalizedString(@"Eclipse URL:", @"");
}
@end
