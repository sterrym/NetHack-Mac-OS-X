//
//  WinCocoaAdditions.swift
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

import Cocoa
import AVFoundation

// 6 is above the window types used by NetHack
private var currentWid: winid = 6
private var windowDict = [winid: NhWindow]()
private var audioDict = [String: AVAudioPlayer]()

extension WinCocoa {
	
	@objc class func windowForWindowID(_ wid: winid) -> NhWindow? {
		return windowDict[wid]
	}
	
	@objc(setWindow:forID:) class func setWindow(_ window: NhWindow, id wid: winid) {
		windowDict[wid] = window
	}
	
	@objc class func addWindow(_ window: NhWindow) -> winid {
		currentWid += 1
		let newID = currentWid
		windowDict[newID] = window
		return newID
	}
	
	@objc(removeWindowWithID:) class func removeWindow(id wid: winid) {
		windowDict.removeValue(forKey: wid)
	}
	
	@objc(playSoundAtURL:volume:) class func playSound(URL: Foundation.URL, volume: Float) -> Bool {
		//guard !SOUND_MUTE else {
		//	return false
		//}
		
		func playAud(_ playSound: AVAudioPlayer) {
			if playSound.isPlaying {
				return
			}
			playSound.volume = volume * 0.01
			playSound.play()
		}
		
		if let playSound1 = audioDict[URL.path] {
			playAud(playSound1)
			return true
		}
		guard (URL as NSURL).checkResourceIsReachableAndReturnError(nil) else {
			return false
		}
		
		guard let playSound = try? AVAudioPlayer(contentsOf: URL) else {
			return false
		}
		audioDict[URL.path] = playSound
		playAud(playSound)
		return true
	}
}
