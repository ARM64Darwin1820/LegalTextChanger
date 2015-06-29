#import <Preferences/Preferences.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#include <spawn.h>
#include <signal.h>

#define TAGB 2

@interface LegalTextChangerSettingsListController : PSListController <UIAlertViewDelegate> {
	NSBundle *bundle;
}
@end

@implementation LegalTextChangerSettingsListController

-(id) specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"LegalTextChangerSettings" target:self];
	}
	return _specifiers;
}

-(void) loadView {
	[super loadView];
	//((UIViewController *) self).navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(confirmRespring)];
	bundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/LegalTextChangerSettings.bundle"];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == TAGB && buttonIndex == 1) {
		[self respring];
	}
}

-(void) confirmRespring {
	UIAlertView *avb = [[UIAlertView alloc] initWithTitle:@"Respring" message:[bundle localizedStringForKey:@"RESPRING" value:nil table:nil] delegate:self cancelButtonTitle:[bundle localizedStringForKey:@"NO" value:nil table:nil] otherButtonTitles:[bundle localizedStringForKey:@"YES" value:nil table:nil], nil];
	avb.tag = TAGB;
	[avb show];
}

-(void) respring {
	pid_t pid;
	int status;
	const char *argv[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
}

@end
