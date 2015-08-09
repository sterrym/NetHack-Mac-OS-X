//
//  compat.c
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

#import <Cocoa/Cocoa.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "hack.h"

struct window_procs cocoa_procs = {0};

void more() {
	//do nothing
}

// These must be defined but are not used (they handle keyboard interrupts).
void intron() {}
void introff() {}

void error(const char *s, ...)
{
	//NSLog(@"error: %s");
	char message[512];
	va_list ap;
	va_start(ap, s);
	vsprintf(message, s, ap);
	va_end(ap);
	//cocoa_raw_print(message);
	// todo (button to wait for user?)
	exit(0);
}

int dosuspend()
{
	NSLog(@"dosuspend");
	return 0;
}

void nethack_exit(int status)
{
	
}

FILE *cocoa_dlb_fopen(const char *filename, const char *mode)
{
	@autoreleasepool {
		NSString *rdir = [[NSBundle mainBundle] resourcePath];
		NSString *aFile = @(filename);
		NSString *toRet = [rdir stringByAppendingPathComponent:aFile];
		FILE *file = fopen([toRet fileSystemRepresentation], mode);
		return file;
	}
}

void cocoa_prepare_for_exit()
{
	//NetHackCocoaAppDelegate * delegate = [[NSApplication sharedApplication] delegate];
	//[delegate unlockNethackCore];
	
	// give UI thread a chance to settle down before we tear down data structures (e.g. inventory)
	for ( int i = 0; i < 100; ++i ) {
		usleep(20);
		dispatch_sync( dispatch_get_main_queue(), ^{});
	}
}

