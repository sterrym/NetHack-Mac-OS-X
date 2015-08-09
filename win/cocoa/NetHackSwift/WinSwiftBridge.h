//
//  WinSwiftBridge.h
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

#import <Cocoa/Cocoa.h>

@interface WinSwiftBridge : NSObject
+ (int)keyWithKeyEvent:(NSEvent *)keyEvent;

@end
