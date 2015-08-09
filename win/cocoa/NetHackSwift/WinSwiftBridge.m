//
//  WinSwiftBridge.m
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

#import "WinSwiftBridge.h"
#include <Carbon/Carbon.h>

@implementation WinSwiftBridge

+ (int)keyWithKeyEvent:(NSEvent *)keyEvent
{
	if ( [keyEvent type] != NSKeyDown )
		return 0;
	
	int key = 0;
	switch ( [keyEvent keyCode] ) {
			// arrows
		case kVK_LeftArrow:				key = 'h';				break;
		case kVK_RightArrow:			key	= 'l';				break;
		case kVK_DownArrow:				key = 'j';				break;
		case kVK_UpArrow:				key = 'k';				break;
			// keypad
		case kVK_ANSI_Keypad1:			key = 'b';				break;
		case kVK_ANSI_Keypad2:			key = 'j';				break;
		case kVK_ANSI_Keypad3:			key = 'n';				break;
		case kVK_ANSI_Keypad4:			key = 'h';				break;
		case kVK_ANSI_Keypad5:			key = '.';				break;
		case kVK_ANSI_Keypad6:			key = 'l';				break;
		case kVK_ANSI_Keypad7:			key = 'y';				break;
		case kVK_ANSI_Keypad8:			key = 'k';				break;
		case kVK_ANSI_Keypad9:			key = 'u';				break;
			// escape
		case kVK_Escape:				key = '\033';			break;
	}
	if ( key ) {
		NSUInteger modifier = [keyEvent modifierFlags];
		if ( modifier & NSShiftKeyMask ) {
			key = toupper(key);
		}
	} else {
		// "real" keys
		NSString * chars = [keyEvent charactersIgnoringModifiers];
		NSUInteger modifier = [keyEvent modifierFlags];
		key = [chars characterAtIndex:0];
		
		switch (key) {
			case NSUpArrowFunctionKey:
			case NSDownArrowFunctionKey:
			case NSLeftArrowFunctionKey:
			case NSRightArrowFunctionKey:
				break;
			default:
				break;
		}
		
		
		if ( modifier & NSCommandKeyMask ) {
			// map Cmd-x to Ctrl-x to match Qt port
			if ( strchr( "ad", key ) != NULL ) {
				modifier &= ~NSCommandKeyMask;
				modifier |= NSControlKeyMask;
			}
		}
		
		if ( modifier & NSShiftKeyMask  ) {
			// system already upcases for us
		}
		if ( modifier & NSControlKeyMask ) {
			// convert to control key
			key = toupper(key) - 'A' + 1;
		}
		if ( modifier & NSAlternateKeyMask ) {
			// convert to meta key
			key = 0x80 | key;
		}
	}
	return key;
}

@end
