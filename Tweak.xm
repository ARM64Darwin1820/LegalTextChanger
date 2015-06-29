#include <Foundation/Foundation.h>
#include <CoreFoundation/CoreFoundation.h>
#include <UIKit/UIKit.h>

%hook SBModelessSyncController

//set this to return true, tricking lock screen to add the legal text view, now called status text view
-(BOOL) isRestoringFromICloud {
	return 1;
}

%end

@interface SBLockScreenStatusTextViewController
-(void) updateTextView;
-(id) _restoreString;
@end

@interface _UILegibilityLabel : UIView
-(NSString *) string;
-(void) setString:(NSString *)arg1;
-(UIFont *) font;
@end

_UILegibilityLabel *l;

%hook SBLockScreenStatusTextViewController

//set our custom string here
-(id) _restoreString {
	NSString *s = (NSString *)[[[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.s1ris.ltc"] objectForKey:@"text"];
	if (s == nil || [s isEqualToString:@""]) {
		return [NSString stringWithFormat:@"Welcome, %@.", [[UIDevice currentDevice] name]];
	}
	else {
		return s;
	}
}

//things get ugly in iPad so I manually resize the status text view to fit its text
-(id) statusTextView {
	l = %orig;
	CGSize stringsize1 = [[self _restoreString] sizeWithFont:l.font];
	[l setFrame:CGRectMake(l.frame.origin.x, l.frame.origin.y, stringsize1.width, l.frame.size.height)];
	l.string = [self _restoreString];
	return l;
}

%end

%hook SBLockScreenView

//our custom Y axis, probably all kinds of crashes people could make by inputting wrong string 
-(void) _layoutStatusTextView {
	%orig;
	NSString *s = (NSString *)[[[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.s1ris.ltc"] objectForKey:@"y"];
	if (s == nil || [s isEqualToString:@""]) {
		return;
	}
	CGFloat f = [(NSNumber *)[s substringFromIndex:1] floatValue];
	if (isnan(f)) {
		return;
	}
	if ([s hasPrefix:@"+"] || [s hasPrefix:@"-"]) {
		if ([s hasPrefix:@"+"]) {
			[l setFrame:CGRectMake(l.frame.origin.x, l.frame.origin.y+f, l.frame.size.width, l.frame.size.height)];
		}
		else {
			[l setFrame:CGRectMake(l.frame.origin.x, l.frame.origin.y-f, l.frame.size.width, l.frame.size.height)];
		}
	}
	else {
		[l setFrame:CGRectMake(l.frame.origin.x, f, l.frame.size.width, l.frame.size.height)];
	}
}

%end