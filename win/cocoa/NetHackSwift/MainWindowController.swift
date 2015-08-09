//
//  MainWindowController.swift
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

import Cocoa

private var anInstance: MainWindowController!

class MainWindowController: NSWindowController, NSWindowDelegate,NSMenuDelegate,NSTableViewDataSource,NSSpeechSynthesizerDelegate {
	
	//@IBOutlet weak var mainView: MainView!
	@IBOutlet weak var messagesView: NSTableView!
	@IBOutlet weak var tileSetMenu: NSMenu!
	@IBOutlet weak var asciiModeMenuItem: NSMenuItem!
	//@IBOutlet weak var statsView: StatsView!
	//@IBOutlet weak var equipmentView: EquipmentView!
	
	//@IBOutlet weak var directionWindow: DirectionWindowController!
	//@IBOutlet weak var yesNoWindow: YesNoWindowController!
	//@IBOutlet weak var inputWindow: InputWindowController!
	//@IBOutlet weak var extCommandWindow: ExtCommandWindowController!
	//@IBOutlet weak var showPlayerSelection: PlayerSelectionWindowController!
	//@IBOutlet weak var directionWindow: DirectionWindowController!
	@IBOutlet weak var notesWindow: NotesWindowController!

	class var instance: MainWindowController {
		return anInstance
	}
	
	func prepareWindows() {
		
	}
	
	private static var onceDefaultsToken: dispatch_once_t = 0
	override class func initialize() {
		dispatch_once(&onceDefaultsToken) {
			let dict = ["TileSetName": "kins32.bmp",
				"UseAscii": false,
				"AsciiFontName": "Helvetica",
				"AsciiFontSize" : 14.0]
			
			NSUserDefaults.standardUserDefaults().registerDefaults(dict)
		}
	}
	
	/// Convert keyEquivs in menu items to use their shifted equivalent
	/// This makes them display with their more conventional character
	/// bindings and lets us work internationally.
	private func fixMenuKeyEquivalents(menu: NSMenu) {
		for item in menu.itemArray {
			if item.hasSubmenu {
				let submenu = item.submenu!
				fixMenuKeyEquivalents(submenu)
			} else {
				var mask = NSEventModifierFlags(rawValue: UInt(item.keyEquivalentModifierMask))
				if mask.contains(.ShiftKeyMask) {
					var key: String! = item.keyEquivalent
					switch key.characters.first! {
					case "1":
						key = "!"
						
					case "2":
						key = "@"
						
					case "3":
						key = "#"
						
					case "4":
						key = "$";
						
					case "5":
						key = "%";
						
					case "6":
						key = "^";
						
					case "7":
						key = "&";
						
					case "8":
						key = "*";
						
					case "9":
						key = "(";
						
					case "0":
						key = ")";
						
					case ".":
						key = ">";
						
					case ",":
						key = "<";
						
					case "/":
						key = "?";
						
					case "[":
						key = "{";
						
					case "]":
						key = "}";
						
					case ";":
						key = ":";
						
					case "'":
						key = "\"";
						
					case "-":
						key = "_";
						
					case "=":
						key = "+";
						
					default:
						key = nil
					}
					
					if let key = key {
						mask.remove(.ShiftKeyMask)
						item.keyEquivalent = key
						item.keyEquivalentModifierMask = Int(mask.rawValue)
					}
				}
			}
		}
	}

	override func awakeFromNib() {
		anInstance = self
		
		super.awakeFromNib()
		
		let menu = NSApplication.sharedApplication().mainMenu!
		fixMenuKeyEquivalents(menu)
		
		window?.acceptsMouseMovedEvents = true
	}
	
}

func keyFromDirection(d: EuclideanDirection) -> Int32 {
	let keys: [Int32] = [107, 117, 108, 110, 106, 98, 104, 121, 033]// = ["kulnjbhy\033"]
	//ret
	
	return keys[d.rawValue]
}

func directionFromKey(k: Int8) -> EuclideanDirection {
	switch k {
	case 107:
		return .Up
		
	case 117:
		return .UpRight
		
	case 108:
		return .Right
		
	case 110:
		return .DownRight
		
	case 106:
		return .Down
		
	case 98:
		return .DownLeft
		
	case 104:
		return .Left
		
	case 121:
		return .UpLeft
		
	default:
		return .Max
	}
}
