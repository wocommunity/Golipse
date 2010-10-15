//
//  NSView-LayoutAdditions.h
//  Golipse
//
//  Created by David LeBer on 10-10-15.
//  Copyright 2010 Align Software Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSView (LayoutAdditions)

- (void) moveNextToView:(NSView*)theView withSpace:(CGFloat)space stretch:(BOOL)shouldStretch;

@end
