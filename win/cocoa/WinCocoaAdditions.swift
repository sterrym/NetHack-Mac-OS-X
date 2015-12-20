//
//  WinCocoaAdditions.swift
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

import Cocoa

// 6 is above the window types used by NetHack
private var currentWid: winid = 6
private var windowDict = [winid: NhWindow]()

extension WinCocoa {
	
	@objc class func windowForWindowID(wid: winid) -> NhWindow? {
		return windowDict[wid]
	}
	
	@objc(setWindow:forID:) class func setWindow(window: NhWindow, id wid: winid) {
		windowDict[wid] = window
	}
	
	@objc class func addWindow(window: NhWindow) -> winid {
		let newID = ++currentWid
		windowDict[newID] = window
		return newID
	}
	
	@objc(removeWindowWithID:) class func removeWindow(id wid: winid) {
		windowDict.removeValueForKey(wid)
	}
}
