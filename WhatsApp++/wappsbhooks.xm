%hook SBBulletinBannerController
%new
- (BOOL)disableDeliveryReceiptsUAWA {
	NSString *justKey = @"UADisableDeliveryReceipts";
	ALApplicationList *applicationList = [[objc_getClass("ALApplicationList") sharedApplicationList] retain];
	NSString *appSandBoxPath = [applicationList valueForKey:@"sandboxPath" forDisplayIdentifier:@"net.whatsapp.WhatsApp"];
	NSString *appPrefsPath = [appSandBoxPath stringByAppendingString:@"/Library/Preferences/net.whatsapp.WhatsApp.plist"];
	NSDictionary *appPrefs = [[NSDictionary dictionaryWithContentsOfFile:appPrefsPath] retain];
	if ([appPrefs objectForKey:justKey]) {
		return [[appPrefs objectForKey:justKey] boolValue];
	}
	return NO
}

%new
- (void)handleBulletin:(BBBulletin *)bulletin {

	SBIconModel *iconModel = (SBIconModel *)[[objc_getClass("SBIconViewMap") homescreenMap] iconModel];
	SBIcon *icon = nil;
	if ([iconModel respondsToSelector:@selector(applicationIconForDisplayIdentifier:)]) {
		icon = (SBIcon *)[iconModel applicationIconForDisplayIdentifier:@"net.whatsapp.WhatsApp"];
	} else if ([iconModel respondsToSelector:@selector(applicationIconForBundleIdentifier:)]) {
		icon = (SBIcon *)[iconModel applicationIconForBundleIdentifier:@"net.whatsapp.WhatsApp"];
	}
	[icon setBadge:0];
}

-(void)observer:(BBObserver *)obs addBulletin:(BBBulletin *)bulletin forFeed:(unsigned long long)feed {
	if ([[bulletin title] isEqualToString:@"WhatsApp"]) {
		if ([self disableDeliveryReceiptsUAWA] == YES) {
			[self handleBulletin:bulletin];
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}

- (void)observer:(id)arg1 modifyBulletin:(id)arg2 {
	if ([[bulletin title] isEqualToString:@"WhatsApp"]) {
		if ([self disableDeliveryReceiptsUAWA] == YES) {
			[self handleBulletin:bulletin];
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}

%end