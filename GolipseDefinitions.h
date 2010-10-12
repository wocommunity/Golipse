//
//  GolipseDefinitions.h
//  Golipse
//
//  Created by David LeBer on 10-10-09.
//  Copyright 2010 Align Software Inc. All rights reserved.
//

#define kInstallLocationDefaultsKey		@"InstallLocationDefaultsKey"
#define kEclipseDownloadURLDefaultsKey	@"EclipseDownloadURLDefaultsKey"

#define kCurrentInstallLocation 		[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:kInstallLocationDefaultsKey]
#define kEclipseDownloadURL				[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:kEclipseDownloadURLDefaultsKey]

#define kDefaultEclipseDownloadURLKey	@"DefaultEclipseDownloadURL"
#define kEclipseName					@"eclipse"

