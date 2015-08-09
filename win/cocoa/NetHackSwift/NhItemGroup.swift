//
//  NhItem.swift
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

import Foundation

class NhItemGroup {
	var title: String
	private(set) var items = [NhItem]()
	var dummy: Bool
	
	init(title: String, dummy: Bool = false) {
		self.title = title
		self.dummy = dummy
	}
	
	func addItem(i: NhItem) {
		items.append(i)
	}
	
	func removeItemAtIndex(row: Int) {
		items.removeAtIndex(row)
	}
}
