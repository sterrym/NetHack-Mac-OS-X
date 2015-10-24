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

	private var errorToReport: ConversionErrors?
	@IBOutlet weak var window: NSWindow!

	override func awakeFromNib() {
		super.awakeFromNib()
		
		if let errorToReport = errorToReport {
			do {
				throw errorToReport
			} catch let error as NSError {
				let anAlert = NSAlert(error: error)
				
				anAlert.runModal()
			}
		}
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
		dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
			let status = restore_savefile(fileURL.fileSystemRepresentation)
			if status != 0 {
				
			}
		}
		
		return true
	}
}

