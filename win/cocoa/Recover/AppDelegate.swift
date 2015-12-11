//
//  AppDelegate.swift
//  Recover
//
//  Created by C.W. Betts on 10/21/15.
//  Copyright © 2015 Dirk Zimmermann. All rights reserved.
//

import Cocoa

enum ConversionErrors: ErrorType {
	case HostBundleNotFound
	case RecoveryFailed
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet weak var window: NSWindow!
	@IBOutlet weak var progress: NSProgressIndicator!
	
	private var errorToReport: ConversionErrors?
	private let opQueue: NSOperationQueue = {
		let aQueue = NSOperationQueue()
		
		aQueue.name = "NetHack Recovery"
		
		if #available(OSX 10.10, *) {
		    aQueue.qualityOfService = .UserInitiated
		} else {
		    // Fallback on earlier versions
		}
		
		return aQueue
	}()

	override func awakeFromNib() {
		super.awakeFromNib()
		
		if let errorToReport = errorToReport {
			do {
				throw errorToReport
			} catch let error as NSError {
				let anAlert = NSAlert(error: error)
				
				anAlert.runModal()
				//NSApp.terminate(nil)
			}
		}
	}
	
	func addURL(url: NSURL) {
		let saveRecover = SaveRecoveryOperation(saveFileURL: url)
		
		opQueue.addOperation(saveRecover)
	}

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
		let selfBundleURL = NSBundle.mainBundle().bundleURL
		guard let parentBundleURL = selfBundleURL.URLByDeletingLastPathComponent?.URLByDeletingLastPathComponent,
			parentBundle = NSBundle(URL: parentBundleURL), parentBundleResources = parentBundle.resourcePath else {
			errorToReport = .HostBundleNotFound
			return
		}
		
		//Change to the NetHack resource directory.
		NSFileManager.defaultManager().changeCurrentDirectoryPath(parentBundleResources)
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}

	func application(sender: NSApplication, openFile filename: String) -> Bool {
		let fileURL = NSURL(fileURLWithPath: filename)
		addURL(fileURL)
		return true
	}
}

