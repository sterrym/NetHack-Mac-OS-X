//
//  NhItem.swift
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

import Foundation

class NhItem: NhObject {
	let identifier: any
	var amount: Int32 = 0
	let maxAmount: Int32
	var selected: Bool = false
	
	init(title t: String, identifier ident: anything, accelerator ch: Int8, group_accel: Int8, glyph g: Int32, selected s: Bool) {
		let lines = (t as NSString).splitNetHackDetails()
		
		super.init(title: lines[0], inventoryLetter: ch, group_accel: group_accel)
		if lines.count == 2 {
			detail = lines[1]
		} else {
			title = t
		}
		
		identifier = ident
		glyph = g
		selected = s
		amount = -1
		maxAmount = (title as NSString).parseNetHackAmount()
	}
}
