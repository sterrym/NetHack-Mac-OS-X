//
//  TileSet.swift
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

//  This file is part of NetHackCocoa.
//
//  iNetHack is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 2 of the License only.
//
//  iNetHack is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iNetHack.  If not, see <http://www.gnu.org/licenses/>.

import Cocoa


final class TileSet: NSObject {
	@objc static var instance: TileSet?
	@objc let image: NSImage
	@objc let tileSize: NSSize
	@objc fileprivate let rows: Int
	@objc fileprivate let columns: Int

	@objc init(image img: NSImage, tileSize ts: NSSize) {
		let rect = NSRect(origin: .zero, size: img.size)
		image = NSImage(size: rect.size)
		image.lockFocus()
		img.draw(in: rect, from: rect, operation: .copy, fraction: 1.0)
		image.unlockFocus()
		
		tileSize = ts
		rows = Int(image.size.height / tileSize.height)
		columns = Int(image.size.width / tileSize.width)

		super.init()
	}
	
	@objc(sourceRectForGlyph:) func sourceRect(forGlyph glyph: Int32) -> NSRect {
		let tile = glyphToTile(glyph)
		return sourceRect(forTile: tile)
	}
	
	fileprivate func sourceRect(forTile tile: Int32) -> NSRect {
		let row = rows - 1 - Int(tile)/columns;
		let col = Int(tile) % columns;

		var r = NSRect()
		r.origin = CGPoint(x: CGFloat(col) * tileSize.width, y: CGFloat(row) * tileSize.height)
		r.size = tileSize
		return r
	}
	
	@objc var imageSize: NSSize {
		var size = tileSize
		if size.width > 32.0 || size.height > 32.0 {
			// since these images are used in menus we want to scale them down
			let m = 32 / max(size.width, size.height)
			size.width  *= m;
			size.height *= m;
		}
		
		return size
	}
	
	@objc(imageForGlyph:enabled:) func image(for glyph: Int32, enabled: Bool = true) -> NSImage {
		// get image
		let srcRect = sourceRect(forGlyph: glyph)
		let size = imageSize
		let newImage = NSImage(size: size)
		let dstRect = NSRect(origin: .zero, size: size)
		newImage.lockFocus()
		image.draw(in: dstRect, from: srcRect, operation: .copy, fraction: enabled ? 1.0 : 0.5)
		newImage.unlockFocus()
		return newImage
	}
}
