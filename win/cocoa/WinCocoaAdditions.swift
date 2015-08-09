//
//  WinCocoaAdditions.swift
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

import Cocoa

private var windowDict = [winid: NhWindow]()

extension WinCocoa {
	
	@objc class func windowForWindowID(wid: winid) -> NhWindow? {
		return windowDict[wid]
	}
	
	@objc(addWindow:withID:) class func addWindow(window: NhWindow, id wid: winid) {
		windowDict[wid] = window
	}
	
	@objc(removeWindowWithID:) class func removeWindow(id wid: winid) {
		windowDict[wid] = nil
	}
}
