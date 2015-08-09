//
//  SwiftBridgeHeader.h
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

#ifndef SwiftBridgeHeader_h
#define SwiftBridgeHeader_h

#import <objc/objc.h>
#include "hack.h"
#include "Inventory.h"

extern struct window_procs cocoa_procs;

extern void NDECL((*decgraphics_mode_callback));

static inline BOOL Swift_Invis() {
	return ((HInvis || EInvis || \
			 pm_invisible(youmonst.data)) && !BInvis);
}

#import "NotesWindowController.h"
#import "MessageWindowController.h"
#import "NhEventQueue.h"
#import "NhEvent.h"
#import "NhCommand.h"

#import "NSString+NetHack.h"
#import "NSString+Z.h"

#import "NhWindow.h"


static inline int SwiftObjToGlyph(struct obj *object)
{
	return obj_to_glyph(object);
}

#endif /* SwiftBridgeHeader_h */
