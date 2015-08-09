//
//  NhObject.swift
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

import Foundation

class NhObject {
	private(set) var object: UnsafeMutablePointer<obj> = nil
	var title: String
	private(set) var detail: String?
	var inventoryLetter: Int8 = 0x20
	let group_ch: Int8
	private(set) var glyph: Int32 = 0
	
	init(title: String, inventoryLetter invLet: Int8, group_accel: Int8) {
		self.title = title
		inventoryLetter = invLet
		group_ch = group_accel
	}
	
	convenience init(object: UnsafeMutablePointer<obj>) {
		let tmp = String(CString: UnsafePointer<CChar>(doname(object)), encoding: NSASCIIStringEncoding)!
		let lines = (tmp as NSString).splitNetHackDetails()
		self.init(title: lines[0], inventoryLetter: object.memory.invlet, group_accel: 0)
		self.object = object
		if lines.count == 2 {
			detail = lines[1]
		}
		glyph = SwiftObjToGlyph(object)
	}
}

class NhItem: NhObject {
	let identifier: any
	var amount: Int32 = -1
	private(set) var maxAmount: Int32 = 0
	let selected: Bool
	
	init(title t: String, identifier ident: anything, accelerator ch: Int8, group_accel: Int8, glyph g: Int32, selected s: Bool) {
		let lines = (t as NSString).splitNetHackDetails()
		identifier = ident
		selected = s

		super.init(title: lines[0], inventoryLetter: ch, group_accel: group_accel)
		if lines.count == 2 {
			detail = lines[1]
		} else {
			title = t
		}
		
		glyph = g
		amount = -1
		maxAmount = (title as NSString).parseNetHackAmount()
	}
}

