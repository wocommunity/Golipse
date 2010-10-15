//
//  NSView-LayoutAdditions.m
//  Golipse
//
//  Created by David LeBer on 10-10-15.
//  Copyright 2010 Align Software Inc. All rights reserved.
//

#import "NSView-LayoutAdditions.h"


@implementation NSView (LayoutAdditions)

- (void) moveNextToView:(NSView*)theView withSpace:(CGFloat)space stretch:(BOOL)shouldStretch;
{
	NSRect myRect = self.frame;
	NSRect theirRect = theView.frame;
	CGFloat finalWidth = myRect.size.width;
	CGFloat finalX = theirRect.origin.x + theirRect.size.width + space;
	if (shouldStretch)
	{
		finalWidth = (myRect.origin.x - finalX) +  myRect.size.width; 
	}
	self.frame = NSMakeRect(theirRect.origin.x + theirRect.size.width + space, myRect.origin.y,  finalWidth, myRect.size.height);
}

@end
