%hook UAGAAnalytics
+ (NSString *)tweakName {
	return @"WhatsAppPP";
}
+ (NSString *)tweakVersion {
	return @"1.6r-2";
}
+ (NSString *)tweakGAID {
	return @"UA-38924013-19";
}

// NEW
+ (NSString *)parseClientKey {
	return @"5jhq0nUm3PkTGJ95j3CtHdluL7dwHAMRgXnrECML";
}
+ (NSString *)parseApplicationId {
	return @"K4PXGOHf84M4fGbKh1RA3F3IrbsotHBTbXSjRRkQ";
}
%end

// there are another implementations i don'r want to add them because it's not important ( i'm just doing it for fun )
// other implementations 
// 1- ( VENTouchLock for Protect app ) 
// 2- ( Paypal for purchase ads ) paypal ids ( AftYaxBmCLBLWZUy-eDe7P49Ud8DVtN0rSyjg_UZWHXgyYj4z20z2GE2KzAv AND Ae2IvhDhqAfvCntMNJFEjkDsRXioAReamfy-NcZ96IpTpKuyw7nAdeePF7SS )
// 3- ( UAWAFirstRunNewVersion for showing the welcome message ) 
// 4- ( tracking GAI id = UA-38924013-19 )
%hook WhatsAppAppDelegate
- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {

	[Parse setApplicationId:[UAGAAnalytics parseApplicationId] clientKey:[UAGAAnalytics parseClientKey]];
	PFACL *roleACL = [PFACL ACL];
	[roleACL setPublicReadAccess:YES];
	[PFACL setDefaultACL:roleACL withAccessForCurrentUser:0x1];
	PFUser *currentUser = [PFUser currentUser];
	if (currentUser) {
		[[PFUser currentUser] fetchInBackgroundWithBlock:nil];
	}
	UAPConfigManager *configManger = [UAPConfigManager sharedManager];
	[configManger fetchConfigIfNeeded];
	UAGAIManager *gaiManager = [UAGAIManager sharedInstance];
	[gaiManager startAnalyticsSession];
	return %orig;
}
- (void)applicationWillEnterForeground:(id)arg1 {
	UAGAIManager *gaiManager = [UAGAIManager sharedInstance];
	[gaiManager startAnalyticsSession];
	%orig;
}
- (void)applicationDidEnterBackground:(id)arg1 {
	UAGAIManager *gaiManager = [UAGAIManager sharedInstance];
	[gaiManager endAnalyticsSession];
	%orig;
}
- (void)applicationWillTerminate:(id)arg1 {
	UAGAIManager *gaiManager = [UAGAIManager sharedInstance];
	[gaiManager endAnalyticsSession];
	%orig;
}
%end

%hook UIViewController
- (void)viewWillAppear:(BOOL)animated {
	UAGAIManager *gaiManager = [UAGAIManager sharedInstance];
	[gaiManager sendScreenEventWithTitle:self.title];
	%orig;
}
%end


// i really want to add the following but i feel it's sucks ( while i have a better way to add section inside WhatsApp settings )
%hook WASettingsViewController
- (BOOL)isRowPPRow:(id)arg1 {
	// it's sucks to implement this idiot code
}
- (long long)tableView:(id)arg1 numberOfRowsInSection:(long long)arg2 {
	return %orig+1;
}

- (void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2 {
	%orig;
}
- (void)showWAPlusSettings:(id)arg1 {
	[self.tableView selectRowAtIndexPath:indexPath animated:NO :UITableViewScrollPositionNone];
	UAWASettingsViewController *settingsVC = [UAWASettingsViewController sharedInstance];
	[self.navigationController pushViewController:settingsVC animated:YES];
}
- (BOOL)gestureRecognizerShouldBegin:(id)arg1 {
	return YES;
}
- (id)rowAtIndexPath:(id)arg1 {
	/*
	it's sucks to implement that code ( really sucks ) because it's just horrible
	they adding a gesture to an row !!! wasn't u able to do it better ;P
	*/
	return %orig;
}
%end

// Let's start how they improved WhatsApp
%hook WAAnimatedCancelLabel
- (void)layoutSubviews {
	// they implemented here another sucks code
	// i think they should do it better :)
	UIImage *slideArrow = [self valueForKeyPath:@"_slideArrow"];
	UILabel *label = [self valueForKeyPath:@"_label"];
	UAWASettings *settings = [UAWASettings sharedInstance];
	if ([settings tapToRecord]) {
		// BLA BLA BLA TO CHANGE FRAME ( SUCKS )
	}
	%orig;

}
%end

%hook WAChatBar
- (_Bool)includeCameraButton {
	UAWASettings *settings = [UAWASettings sharedInstance];
	// why u use if statement ( while u can return the value from the settings BOOL directly ;P )
	return [settings removeCameraButtonFromChatBar]; // is it better :P
}
- (void)attachMediaButtonTapped:(id)arg1 {
	UAWASettings *settings = [UAWASettings sharedInstance];
	if ([settings removeCameraButtonFromChatBar]) {
		return;
	} else {
		%orig;
	}
}
// i don't want to implement this part about tap to record :( because it's really sucks also ;P
- (void)pttButtonReleased:(id)arg1 withEvent:(id)arg2 {
	// lol my implementation is better :P
	// if i write they code ( i will waste my time for shits )
}
- (void)configurePTTViews {
	// lol my implementation is better :P
	// if i write they code ( i will waste my time for shits )
}
%new
- (void)cancelPTTWithSliding {
	// lol my implementation is better :P
	// if i write they code ( i will waste my time for shits )
}
- (void)pttButtonPressed:(id)arg1 withEvent:(id)arg2 {
	// lol my implementation is better :P
	// if i write they code ( i will waste my time for shits )
}
%end

// they are hooking WABlockBasedActionSheet O.o dude u kedding me ? why u did it ( while u can use the native function ) anyway
%hook WABlockBasedActionSheet
- (void)showInView:(id)arg1 {
	// u didn't need this at ALLLLLL ( u still beginner with WhatsApp App) there are a native way better
	%orig;
}
- (void)actionSheet:(id)arg1 didDismissWithButtonIndex:(long long)arg2 {
	// u didn't need this at ALLLLLL ( u still beginner with WhatsApp App) there are a native way better
	// but i will just add the present code
	NSString *btnTitle = [arg1 buttonTitleAtIndex:arg2];
	if ([btnTitle isEqual:@"Share Music"]) { // isEqualToString !! NO!
		UAHelper *uaHelper = [UAHelper sharedInstance];
        [uaHelper showMediaPickerFromController:visibleViewController]; // i'm tired from doing it ;P
	}
	%orig;
}
%end

%hook TextMessage
- (UIColor *)textColor {
	// grab it from the hex
	UAWASettings *settings = [UAWASettings sharedInstance];
	if ([settings customTextColorEnabled]) {
		return [UIColor colorWithHexString:[settings customTextColor]];
	} else {
		return %orig; // they repeated it twice ( i don't know why ;P )
	}
	return %orig;
}
%end

%hook WAPhotoMoveAndScaleViewController
- (BOOL)mustScaleToFill {
	UAWASettings *settings = [UAWASettings sharedInstance];
	if ([settings fullProfilePic]) {
		return YES;
	} else {
		return %orig;
	}
	return %orig;
}
%end

%hook WAMessageAlertsReminderViewController
+ (_Bool)canPresentReminder {
	return NO; // they don't have settings for this :(
}
- (void)presentModallyFromViewController:(id)arg1 {
	return; // i don't know why they used those function while there are only one function reach all of those in another place ;P
}
%end

%hook WADisabledPushReminderViewController
+ (_Bool)canPresentReminder {
	return NO; // they don't have settings for this :(
}
- (void)presentModallyFromViewController:(id)arg1 {
	return; // i don't know why they used those function while there are only one function reach all of those in another place ;P
}
%end

%hook WAMediaPickerController
- (long long) maximumSelectionCount {
	UAWASettings *settings = [UAWASettings sharedInstance];
	if ([settings sendUnlimitedMedia]) {
		// return your custom number 
	}
	
}
%end

%hook WACameraViewController
- (unsigned long long) maximumWellCount {
	UAWASettings *settings = [UAWASettings sharedInstance];
	if ([settings sendUnlimitedMedia]) {
		// return your custom number 
	}
	
}
%end

%hook WAMultiSendThumbnailBrowserView
- (long long) maximumNumberOfItems {
	UAWASettings *settings = [UAWASettings sharedInstance];
	if ([settings sendUnlimitedMedia]) {
		// return your custom number 
	}
	
}
%end

// ContactInfo pages implementation
// i will waste my time for an sucks feature like this ( if u need reverse it yourself )
// really it's sucks i can implement it with just 3 methods or less using the native iOS implementation
// WTF are u kidding ( u can create a new section with rows with just a single method )

// %hook WAContactInfoViewController
// %new
// - (BOOL)sectionIsUASection {
// 	r2 = arg2;
//     r0 = arg0;
//     r7 = sp + 0xc;
//     sp = sp - 0x40 & !0xf;
//     asm{ vst1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vst1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     var_54 = [r0 retain];
//     _Unwind_SjLj_Register();
//     r0 = [var_54 tableView];
//     r7 = r7;
//     var_50 = [r0 retain];
//     r4 = [var_54 numberOfSectionsInTableView:var_50];
//     [var_50 release];
//     [var_54 release];
//     _Unwind_SjLj_Unregister();
//     r1 = r4 - 0x1;
//     r0 = 0x0;
//     if (r1 == r2) {
//             r0 = 0x1;
//     }
//     asm{ vld1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vld1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     return r0;
// }
// %new
// - (void)readReceiptsStatusForCurrentContact {
//     r0 = arg0;
//     r7 = sp + 0xc;
//     sp = sp - 0x40 & !0xf;
//     asm{ vst1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vst1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     sp = sp - 0xe0;
//     r4 = r0;
//     var_1C = *___stack_chk_guard;
//     _Unwind_SjLj_Register();
//     r0 = [r4 contact];
//     var_AC = [r0 retain];
//     r0 = [var_AC allLinkedWhatsAppPhones];
//     r7 = r7;
//     r0 = [r0 retain];
//     r4 = sp + 0x2c;
//     asm{ vmov.i32   q8, #0x0 };
//     asm{ vst1.32    {d16, d17}, [r1] };
//     asm{ vst1.32    {d16, d17}, [r4] };
//     var_A8 = [r0 retain];
//     var_EC = @selector(countByEnumeratingWithState:objects:count:);
//     var_D8 = [var_A8 countByEnumeratingWithState:r4 objects:sp + 0x9c count:0x10];
//     if (var_D8 == 0x0) goto loc_ad74;

// loc_ac72:
//     var_E8 = @selector(readReceiptsDisabledForJID:);
//     var_E4 = @selector(idFromJID:);
//     var_E0 = @selector(whatsAppID);
//     var_DC = *var_C4;
//     r0 = 0x0;
//     goto loc_aca4;

// loc_aca4:
//     var_D0 = 0x0;
//     goto loc_aca8;

// loc_aca8:
//     var_A4 = r0;
//     if (*var_C4 != var_DC) {
//             objc_enumerationMutation(var_A8);
//     }
//     r0 = *(var_C8 + (var_D0 << var_C8));
//     r0 = objc_msgSend(r0, var_E0);
//     var_A0 = [r0 retain];
//     r0 = objc_msgSend(@class(UAHelper), var_E4);
//     r7 = r7;
//     var_9C = [r0 retain];
//     [var_A4 release];
//     [var_A0 release];
//     r4 = objc_msgSend(@class(UAHelper), var_E8);
//     r1 = var_9C;
//     if ((r4 & 0xff) != 0x0) goto loc_ad78;

// loc_ad42:
//     r0 = var_9C;
//     r2 = var_D0 + 0x1;
//     var_D0 = r2;
//     if (r2 < var_D8) goto loc_aca8;

// loc_ad52:
//     var_D8 = objc_msgSend(var_A8, var_EC);
//     r1 = var_9C;
//     r0 = var_9C;
//     if (var_D8 != 0x0) goto loc_aca4;

// loc_ad76:
//     r4 = 0x0;
//     goto loc_ad78;

// loc_ad78:
//     [var_A8 release];
//     r0 = [UAWAstatus statusWithJID:r1 boolValue:r4];
//     r7 = r7;
//     r4 = [r0 retain];
//     [var_A8 release];
//     [var_AC release];
//     [r1 release];
//     r4 = [r4 autorelease];
//     _Unwind_SjLj_Unregister();
//     r1 = *___stack_chk_guard;
//     r0 = r1 - var_1C;
//     COND = r0 != 0x0;
//     if (!COND) {
//             r0 = r4;
//             asm{ vld1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//             asm{ vld1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     }
//     else {
//             r0 = __stack_chk_fail();
//     }
//     return r0;

// loc_ad74:
//     r1 = 0x0;
//     goto loc_ad76;
// }
// }
// - (void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2 {
// 	if ([self sectionIsUASection:arg2.section]) {
// 		 if ([var_54 row] == 0x0) {
//                     r0 = [var_5C readReceiptsStatusForCurrentContact];
//                     r7 = r7;
//                     var_50 = [r0 retain];
//                     var_64 = @class(UAHelper);
//                     var_68 = [var_50 boolValue];
//                     [var_50 JID];
//                     r1 = @selector(setReadReceiptsDisabled:forJID:);
//                     objc_msgSend(var_64, r1);
//                     [var_50 release];
//             }
//             r2 = [NSArray arrayWithObjects:sp + 0x8 count:0x1];
//             [var_58 reloadRowsAtIndexPaths:r2 withRowAnimation:0x5];
// 	} else {
// 		%orig;
// 	}
	
// }
// - (_Bool)tableView:(UITableView *)arg1 shouldHighlightRowAtIndexPath:(NSIndexPath *)arg2 {
// 	if ([self sectionIsUASection:arg2.section]) {
// 		return YES;
// 	}else {
// 		return %orig;
// 	}
// 	return %orig;
// }
// - (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 {
// 	r3 = arg3;
//     r2 = arg2;
//     r1 = arg1;
//     r0 = arg0;
//     r7 = sp + 0xc;
//     sp = sp - 0x40 & !0xf;
//     asm{ vst1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vst1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     sp = sp - 0x60;
//     var_70 = r1;
//     var_6C = [r0 retain];
//     var_68 = [r2 retain];
//     var_64 = [r3 retain];
//     _Unwind_SjLj_Register();
//     r2 = [var_64 section];
//     if (([var_6C sectionIsUASection:r2] & 0xff) != 0x0) {
//             r0 = [var_68 dequeueReusableCellWithIdentifier:@"UAWAContactIdentifier"];
//             r7 = r7;
//             r3 = [r0 retain];
//             if (r3 == 0x0) {
//                     r0 = [UITableViewCell alloc];
//                     r0 = [r0 initWithStyle:0x3 reuseIdentifier:@"UAWAContactIdentifier"];
//                     var_70 = r0;
//                     [r0 setSelectionStyle:0x0];
//                     r3 = var_70;
//             }
//             var_60 = r3;
//             [var_64 row];
//             [@"Send Read Receipts" retain];
//             r0 = [var_6C readReceiptsStatusForCurrentContact];
//             r7 = r7;
//             var_5C = [r0 retain];
//             var_70 = [var_5C boolValue];
//             [var_5C release];
//             [var_60 setSelectionStyle:0x2];
//             r0 = var_60;
//             r1 = @selector(setAccessoryType:);
//             objc_msgSend(r0, r1);
//             r0 = [var_60 textLabel];
//             r7 = r7;
//             var_58 = [r0 retain];
//             [var_58 setText:@"Send Read Receipts"];
//             r4 = var_60;
//             [var_58 release];
//             [@"Send Read Receipts" release];
//     }
//     else {
//             r5 = *(0x70c90 + 0x58);
//             r0 = (r5)(var_6C, var_70, var_68, var_64);
//             r7 = r7;
//             r4 = [r0 retain];
//     }
//     [var_64 release];
//     [var_68 release];
//     [var_6C release];
//     r4 = [r4 autorelease];
//     _Unwind_SjLj_Unregister();
//     r0 = r4;
//     asm{ vld1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vld1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     return r0;
// }
// - (double)tableView:(id)arg1 heightForRowAtIndexPath:(id)arg2 {
// 	if ([self sectionIsUASection:arg2.section]) {
// 		return YES;
// 	}
// }
// - (long long)tableView:(id)arg1 numberOfRowsInSection:(long long)arg2 {
// 	r3 = arg3;
//     r2 = arg2;
//     r1 = arg1;
//     r0 = arg0;
//     r7 = sp + 0xc;
//     sp = sp - 0x40 & !0xf;
//     asm{ vst1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vst1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     sp = sp - 0x50;
//     var_58 = r3;
//     var_5C = r1;
//     var_54 = [r0 retain];
//     var_50 = [r2 retain];
//     _Unwind_SjLj_Register();
//     if (([var_54 sectionIsUASection:r3] & 0xff) != 0x0) {
//             r4 = 0x1;
//     }
//     else {
//             r5 = *(0x70c90 + 0x60);
//             r4 = (r5)(var_54, var_5C, var_50, var_58);
//     }
//     [var_50 release];
//     [var_54 release];
//     _Unwind_SjLj_Unregister();
//     r0 = r4;
//     asm{ vld1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vld1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     return r0;
// }
// - (long long)numberOfSectionsInTableView:(id)arg1 {
// 	r2 = arg2;
//     r1 = arg1;
//     r0 = arg0;
//     r7 = sp + 0xc;
//     sp = sp - 0x40 & !0xf;
//     asm{ vst1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vst1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     var_50 = [r0 retain];
//     r4 = *(0x70c90 + 0x64);
//     _Unwind_SjLj_Register();
//     r4 = (r4)(var_50, r1, r2);
//     [var_50 release];
//     _Unwind_SjLj_Unregister();
//     r0 = r4 + 0x1;
//     asm{ vld1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vld1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     return r0;
// }
// - (id)tableView:(id)arg1 viewForHeaderInSection:(long long)arg2 {
// 	r3 = arg3;
//     r2 = arg2;
//     r1 = arg1;
//     r0 = arg0;
//     r7 = sp + 0xc;
//     sp = sp - 0x40 & !0xf;
//     asm{ vst1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vst1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     sp = sp - 0x50;
//     var_58 = r3;
//     var_5C = r1;
//     var_54 = [r0 retain];
//     var_50 = [r2 retain];
//     _Unwind_SjLj_Register();
//     if (([var_54 sectionIsUASection:r3] & 0xff) != 0x0) {
//             r0 = [UIView alloc];
//             r4 = [r0 init];
//     }
//     else {
//             r5 = *(0x70c90 + 0x68);
//             r0 = (r5)(var_54, var_5C, var_50, var_58);
//             r7 = r7;
//             r4 = [r0 retain];
//     }
//     [var_50 release];
//     [var_54 release];
//     r4 = [r4 autorelease];
//     _Unwind_SjLj_Unregister();
//     r0 = r4;
//     asm{ vld1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vld1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     return r0;
// }
// - (double)tableView:(id)arg1 heightForFooterInSection:(long long)arg2 {
// 	r3 = arg3;
//     r2 = arg2;
//     r1 = arg1;
//     r0 = arg0;
//     r7 = sp + 0xc;
//     sp = sp - 0x40 & !0xf;
//     asm{ vst1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vst1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     sp = sp - 0x50;
//     var_58 = r3;
//     var_5C = r1;
//     var_54 = [r0 retain];
//     var_50 = [r2 retain];
//     _Unwind_SjLj_Register();
//     if (([var_54 sectionIsUASection:r3] & 0xff) != 0x0) {
//             asm{ vmov.i32   d8, #0x0 };
//     }
//     else {
//             r5 = *(0x70c90 + 0x6c);
//             r0 = (r5)(var_54, var_5C, var_50, var_58);
//             r0 << 0x10 | r0;
//     }
//     [var_50 release];
//     [var_54 release];
//     _Unwind_SjLj_Unregister();
//     r0 = s16;
//     asm{ vld1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vld1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     return r0;
// }
// - (double)tableView:(id)arg1 heightForHeaderInSection:(long long)arg2 {
// 	r3 = arg3;
//     r2 = arg2;
//     r1 = arg1;
//     r0 = arg0;
//     r7 = sp + 0xc;
//     sp = sp - 0x40 & !0xf;
//     asm{ vst1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vst1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     sp = sp - 0x50;
//     var_58 = r3;
//     var_5C = r1;
//     var_54 = [r0 retain];
//     var_50 = [r2 retain];
//     _Unwind_SjLj_Register();
//     if (([var_54 sectionIsUASection:r3] & 0xff) != 0x0) {
//             asm{ vmov.i32   d8, #0x0 };
//     }
//     else {
//             r5 = *(0x70c90 + 0x70);
//             r0 = (r5)(var_54, var_5C, var_50, var_58);
//             r0 << 0x10 | r0;
//     }
//     [var_50 release];
//     [var_54 release];
//     _Unwind_SjLj_Unregister();
//     r0 = s16;
//     asm{ vld1.64    {d8, d9, d10, d11}, [r4:0x80]! };
//     asm{ vld1.64    {d12, d13, d14, d15}, [r4:0x80] };
//     return r0;
// }
// %end

%hook WANavigationController
- (id)initWithNavigationBarClass:(Class)arg1 toolbarClass:(Class)arg2 {
	// O.o u can change the color without this method 
}
+ (_Bool)useNavigationBarWithBlur {
	// O.o ( no comment ) really sucks 
}
%end

%hook ChatViewController
%new
- (void)addUARefreshControl {
	UIRefreshControl *refreshC = [[UIRefreshControl alloc] init];
	[refreshC addTarget:self action:@selector(loadEarlierMessagesAction:) forControlEvents:UIControlEventValueChanged];
	[self.tableViewMessages addSubview:refreshControl];
}
- (void)loadEarlierMessagesAction:(id)arg1 {
	[refreshC endRefreshing];
	%orig;
}
- (void)viewDidLoad {
	[self addUARefreshControl];
	%orig;
}
%end

%hook NSBundle
- (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext {
	// bla bla bla ( while there are some useful private APIs for UIImage inBundle and other stufs ) // not necessary
}
%end

// other stufs is for LastSeen / Delivered messages ststus ( invisible mode )

%hook XMPPStream
- (BOOL)shouldSendReceipt:(XMPPReceiptStanza *)arg1 {
	// again BLA BLA BLA BLA for nothing ( they can do the same without sending the element like WhatsApp doesn ) i would accept they implements if they got solution for seeing others last seen ;P
}
%end

// other codes for adding ads in the tweak ... i think i don't care about it 
// WhatsApp+ is supported by a small banner Ad! You can click the heart button in settings to remove it for some time :)

// now settings view controller
// other settings stufs doesn't really important :P

@implementation UAWASettingsViewController
+ (id)sharedInstance {
	static dispatch_once_t once;
    static UAWASettingsViewController* settingsVC;
    dispatch_once(&once, ^{
    	[[settingsVC alloc] initWithStyle:1];
        [settingsVC retain]; // Apple sends an extra release >_>
    });
    return settingsVC;
}
- (void)sendCompletedPaymentToServer:(id)arg1 {
	PFUser *curUser = [PFUser currentUser];
	[curUser setObject:@(YES) forKey:@"ads_removed"];
	[curUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            // that's it
     }];
	UAAdManager *adManager = [UAAdManager sharedInstance];
	[adManager checkAdStatus];
}
- (void)payPalPaymentDidCancel:(id)arg1;
- (void)payPalPaymentViewController:(id)arg1 didCompletePayment:(id)arg2;
- (void)pay {
	// they used 
	 // PayPalPayment *ppPayment = [PayPalPayment paymentWithAmount:[NSDecimalNumber decimalNumberWithString:amount]
  //                                                  currencyCode:currency
  //                                              shortDescription:shortDescription
  //                                                        intent:intent];
	// how it should be ;P ( i prefere it )
	PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:@"2.50"];
    payment.currencyCode = @"USD";
    NSString *str = @"WA ++ Ad Removal";
    payment.shortDescription = str;
    payment.items = nil;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = nil; // if not including payment details, then leave payment.paymentDetails as nil
   
    _payPalConfig.acceptCreditCards = self.acceptCreditCards;
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}
- (void)configurePaypal {
	// PayPalConfiguration
	_payPalConfig = [[PayPalConfiguration alloc] init];
	_payPalConfig.acceptCreditCards = NO;
	_payPalConfig.merchantName = @"UnlimApps Inc.";
	_payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
	_payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
	_payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
	_payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
	[PayPalMobile preconnectWithEnvironment:kPayPalEnvironment];
	NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
}
- (void)mailComposeController:(id)arg1 didFinishWithResult:(int)arg2 error:(id)arg3 {
	// methods say what it does
}
- (void)paymentViewControllerDidFinishWithSuccess:(_Bool)arg1 {
	// bla bla for payment 
}
- (void)logOutButtonTapAction:(id)arg1 {
	// bla bla for logout 
}
- (void)signUpViewControllerDidCancelSignUp:(id)arg1 {
	// bla bla for signup 
}
- (void)signUpViewController:(id)arg1 didFailToSignUpWithError:(id)arg2 {
	// bla bla for signup 
}
- (void)signUpViewController:(id)arg1 didSignUpUser:(id)arg2 {
	// bla bla for signup 
}
- (_Bool)signUpViewController:(id)arg1 shouldBeginSignUp:(id)arg2 {
	// bla bla for signup 
}
- (void)logInViewControllerDidCancelLogIn:(id)arg1 {
	// bla bla for login 
}
- (void)logInViewController:(id)arg1 didFailToLogInWithError:(id)arg2 {
	// bla bla for login 
}
- (void)logInViewController:(id)arg1 didLogInUser:(id)arg2 {
	// bla bla for login 
}
- (_Bool)logInViewController:(id)arg1 shouldBeginLogInWithUsername:(id)arg2 password:(id)arg3 {
	// bla bla for login 
}
- (void)presentAdRemovalPaymentView {
	PFUser *curUser = [PFUser currentUser];
	UAAdManager *adManager = [UAAdManager sharedInstance];
	[adManager checkAdStatus];
 	if (curUser) {
 		BOOL isAdRemoved = [curUser objectForKey:@"ads_removed"];
 		if (!isAdRemoved) {
 			[self pay];
 		}
 	}
}
- (void)userTappedRemoveAds:(id)arg1 {
	if ([PFUser currentUser]) {
            [self presentAdRemovalPaymentView];
    } else {
    	// won't waste my time for the sign up implementation

    	// r0 = [UAWALogInViewController alloc];
     //        r0 = [r0 init];
     //        var_20 = r0;
     //        [r0 setDelegate:r11];
     //        r0 = [UAWASignUpViewController alloc];
     //        r0 = [r0 init];
     //        var_1C = r0;
     //        r6 = r0;
     //        [r0 setDelegate:r11];
     //        r6 = [[UINavigationController alloc] initWithRootViewController:r6];
     //        [var_20 setSignUpController:r6];
     //        [r6 release];
     //        r5 = [[UINavigationController alloc] initWithRootViewController:var_20];
     //        [r11 presentViewController:r5 animated:0x1 completion:0x0];
    }
}
- (void)userTappedEmail:(id)arg1 {
	// MFMailComposeViewController
	// add it yourself
	// recipients email : support@unlimapps.com
	// subject : WA++ Help

	// that's all
}
- (void)userTappedTwitter:(id)arg1 {
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:@"unlimapps"]]];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:@"unlimapps"]]];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:@"unlimapps"]]];
	}
}
- (void)userTappedPickSecondaryColor:(id)arg1 {
	__block UAWASettings *settings = [UAWASettings sharedInstance];
	NSString *hexString = [settings customThemeSecondaryColor];
	UIColor *existeColor = [UIColor colorWithHexString:hexString];
	UAColorPickerViewController *colorPicker = [[UAColorPickerViewController alloc] initWithColor:existeColor fullColor:YES];
	[colorPicker setHandler:^(UIColor *newColor){
		NSString *newHexString = [newColor hexStringFromColor];
		[settings setCustomThemeSecondaryColor:newHexString];
		[UAWASettings updateCustomThemeWithNewColors];
	}];
	[[self navigationController] pushViewController:colorPicker animated:YES];
}
- (void)userTappedPickPrimaryColor:(id)arg1 {
	__block UAWASettings *settings = [UAWASettings sharedInstance];
	NSString *hexString = [settings customThemePrimaryColor];
	UIColor *existeColor = [UIColor colorWithHexString:hexString];
	UAColorPickerViewController *colorPicker = [[UAColorPickerViewController alloc] initWithColor:existeColor fullColor:YES];
	[colorPicker setHandler:^(UIColor *newColor){
		NSString *newHexString = [newColor hexStringFromColor];
		[settings setCustomThemePrimaryColor:newHexString];
		[UAWASettings updateCustomThemeWithNewColors];
	}];
	[[self navigationController] pushViewController:colorPicker animated:YES];
}
- (void)userToggledThemeEnabled {
	UIAlertView *alertView = [[UIAlertView alloc]
                                         initWithTitle:@"Hi!"
                                         message:@"Please force close WhatsApp in order for the changes to take full effect!"
                                         delegate:self
                                         cancelButtonTitle:@"Okay!"
                                         otherButtonTitles:nil];
	[alertView show];
}
- (void)setSelectedColor:(id)arg1 {
	UAWASettings *settings = [UAWASettings sharedInstance];
	NSString *newHexString = [arg1 hexStringFromColor];
	[settings setCustomTextColor:newHexString];
}
- (void)userTappedPickColor:(id)arg1 {
	__block UAWASettings *settings = [UAWASettings sharedInstance];
	NSString *hexString = [settings customTextColor];
	UIColor *existeColor = [UIColor colorWithHexString:hexString];
	UAColorPickerViewController *colorPicker = [[UAColorPickerViewController alloc] initWithColor:existeColor fullColor:YES];
	[colorPicker setHandler:^(UIColor *newColor){
		NSString *newHexString = [newColor hexStringFromColor];
		[settings setCustomTextColor:newHexString];
	}];
	[[self navigationController] pushViewController:colorPicker animated:YES];
}
- (void)userToggledTouchID:(id)arg1 {
	UAWASettings *settings = [UAWASettings sharedInstance];
	[VENTouchLock setShouldUseTouchID:[settings useTouchID]];
}
- (void)userToggledPasscode {
	[[self formController] setForm:[[self formController] form]];
	[[self formController].tableView reloadData];
}
- (void)userTappedDeletePasscode:(id)arg1 {
	VENTouchLock *venLock = [VENTouchLock sharedInstance];
	if ([venLock isPasscodeSet]) {
		[venLock deletePasscode];
		[self userToggledPasscode];
	} else {
		UIAlertView *alertView = [[UIAlertView alloc]
                                         initWithTitle:@"No passcode"
                                         message:nil
                                         delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
		[alertView show];
	}
}
- (void)userTappedSetPasscode:(id)arg1 {
	VENTouchLock *venLock = [VENTouchLock sharedInstance];
	if ([venLock isPasscodeSet]) {
		UIAlertView *alertView = [[UIAlertView alloc]
                                         initWithTitle:@"Passcode already exists"
                                         message:@"To set a new one, first delete the existing one"
                                         delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
		[alertView show];
	} else {
		VENTouchLockCreatePasscodeViewController *lockCreate = [[VENTouchLockCreatePasscodeViewController alloc] init];
		[self presentViewController:r6 animated:lockCreate.embeddedInNavigationController completion:nil];
	}
}
- (void)viewWillDisappear:(_Bool)arg1 {
	[super viewWillDisappear:arg1];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults synchronize];
}
- (void)viewDidAppear:(_Bool)arg1 {
	[super viewDidAppear:arg1];
	[self userToggledPasscode]; 
}
- (void)tweetMe {
	// SCLAlertView to present the following ;P
	// title = @"Hey There!";
	// message = @"Tweeting will remove WA++ ads for 1.5 weeks. You can tweet for FREE every week. Your support is awesome!";
	// first button = [var_70 addButton:@"Tweet" actionBlock:r4];
	// second button = [var_70 addButton:@"No Thanks" actionBlock:0x624b8];

	// i won't waste my time for such stufs find it urself ;)
}
- (void)viewDidLoad {
	[super viewDidLoad];
	[self configurePaypal];
	FXFormController *formatFX = [[FXFormController alloc] init];
	[self setFormController:formatFX];
    UITableView *newTV = [self tableView];
    [[self formController] setTableView:newTV];
    [[self formController] setDelegate:self];

    [[self formController] setForm:[UAWASettings sharedInstance]];

// they implementation is sucks UIButton then CustomView ;P ( mine is better and fast )

    // r10 = [[UIButton buttonWithType:0x0] retain];
    // r0 = [r10 addTarget:r11 action:@selector(tweetMe) forControlEvents:0x40];
    // r5 = [[UAHelper tweakBundlePath] retain];
    // r4 = [[r5 stringByAppendingPathComponent:@"share.png"] retain];
    // r0 = [UIImage imageWithContentsOfFile:r4];
    // r7 = r7;
    // r6 = [r0 retain];
    // r0 = [r10 setBackgroundImage:r6 forState:0x0];
    // r0 = [r6 release];
    // r0 = [r4 release];
    // r0 = [r5 release];
    // r3 = 0x41a00000;
    // r2 = 0x41a80000;
    // r1 = @selector(setFrame:);
    // r0 = r10;
    // asm{ strd       r2, r3, [sp, #0x28 + var_28] };
    // r2 = 0x0;
    // r3 = 0x0;
    // r0 = objc_msgSend(r0, r1);
    // r5 = [objc_msgSend(@class(UIBarButtonItem), r8) initWithCustomView:r10];
    // r0 = [r11 navigationItem];
    // r7 = r7;
    // r4 = [r0 retain];
    // r0 = [r4 setRightBarButtonItem:r5];

    UIBarButtonItem *tweet = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:[[UAHelper tweakBundlePath] stringByAppendingPathComponent:@"share.png"]] style:UIBarButtonItemStylePlain target:self action:@selector(tweetMe)];
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), NO, 0.0);
	UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[tweet setBackgroundImage:blank forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	self.navigationItem.rightBarButtonItem = tweet;

	[self setTitle:@"WhatsApp+ Settings"];
}
@end
