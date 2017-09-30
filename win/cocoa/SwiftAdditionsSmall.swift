//
//  SwiftAdditionsSmall.swift
//  NetHackCocoa
//
//  Created by C.W. Betts on 9/30/17.
//  Copyright © 2017 Dirk Zimmermann. All rights reserved.
//

import Cocoa

extension CGBitmapInfo {
	/// The native 32-bit byte order format.
	static var byteOrder32Host: CGBitmapInfo {
		#if _endian(little)
			return .byteOrder32Little
		#elseif _endian(big)
			return .byteOrder32Big
		#else
			fatalError("Unknown endianness")
		#endif
	}
}

extension NSBitmapImageRep.Format {
	/// The native 32-bit byte order format.
	static var thirtyTwoBitNativeEndian: NSBitmapImageRep.Format {
		#if _endian(little)
			return .thirtyTwoBitLittleEndian
		#elseif _endian(big)
			return .thirtyTwoBitBigEndian
		#else
			fatalError("Unknown endianness")
		#endif
	}
}
