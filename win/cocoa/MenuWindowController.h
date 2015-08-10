//
//  MenuWindowController.h
//  NetHackCocoa
//
//  Created by Bryce on 2/16/10.
//  Copyright 2010 Bryce Cogswell. All rights reserved.
//

/*
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation, version 2
 of the License.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */


#import <Cocoa/Cocoa.h>
#import "NhMenuWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuWindowController : NSWindowController <NSWindowDelegate> {
	
	NhMenuWindow		*	menuParams;
	
	NSMutableDictionary	*	itemDict;
	
	IBOutlet NSView		*	menuView;
	IBOutlet NSButton	*	cancelButton;
	IBOutlet NSButton	*	acceptButton;

	IBOutlet NSButton	*	selectAll;
}

+ (void)menuWindowWithMenu:(NhMenuWindow *)menu;

-(IBAction)doAccept:(nullable id)sender;
-(IBAction)doCancel:(nullable id)sender;
-(IBAction)selectAll:(nullable id)sender;
-(IBAction)sortItems:(nullable id)sender;
-(IBAction)selectUnknownBUC:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
