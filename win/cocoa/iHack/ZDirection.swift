//
//  ZDirection.swift
//  NetHackCocoa
//
//  Created by C.W. Betts on 8/9/15.
//
//

import Foundation

@objc enum EuclideanDirection : Int {
	case Up = 0
	case UpRight
	case Right
	case DownRight
	case Down
	case DownLeft
	case Left
	case UpLeft
	case Max
}

private let kCos45: CGFloat = 0.707106781186548
private let kCos30: CGFloat = 0.866025403784439

private let s_directionVectors: [CGPoint] = [
	CGPoint(x: 0, y: 1),
	CGPoint(x: kCos45, y: kCos45),
	CGPoint(x: 1, y: 0),
	CGPoint(x: kCos45, y: -kCos45),
	CGPoint(x: 0, y: -1),
	CGPoint(x: -kCos45, y: -kCos45),
	CGPoint(x: -1, y: 0),
	CGPoint(x: -kCos45, y: kCos45)
]

private func vectorLength(v: CGPoint) -> CGFloat {
	return sqrt(v.x * v.x + v.y * v.y)
}

private func dotProduct(v1: CGPoint, _ v2: CGPoint) -> CGFloat {
	return v1.x * v2.x + v1.y * v2.y
}

private func normalize(inout v: CGPoint) {
	let l = vectorLength(v)
	v.x /= l
	v.y /= l
}

func directionFromEuclideanPointDelta(var delta: CGPoint) -> EuclideanDirection {
	normalize(&delta)
	for i in 0 ..< EuclideanDirection.Max.rawValue {
		let dotP = dotProduct(delta, s_directionVectors[i])
		if dotP >= kCos30 {
			return EuclideanDirection(rawValue: i)!
		}
	}
	
	return .Max
}

final class ZDirection: NSObject {
	class func directionFromEuclideanPointDelta(delta: CGPoint) -> EuclideanDirection {
		return directionFromEuclideanPointDelta(delta)
	}
}
