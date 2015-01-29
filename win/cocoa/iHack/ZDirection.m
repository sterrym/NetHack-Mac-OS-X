//
//  ZDirection.m
//  SlashEM
//
//  Created by dirk on 1/1/10.
//  Copyright 2010 Dirk Zimmermann. All rights reserved.
//

/*
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation, version 2
 of the License.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#include <math.h>
#include <tgmath.h>

#import "ZDirection.h"

#define kCos45 (0.707106829)
#define kCos30 (0.866025404)

static const CGPoint s_directionVectors[kDirectionMax] = {
	{ 0.0, 1.0 },
	{ kCos45, kCos45 },
	{ 1.0, 0.0 },
	{ kCos45, -kCos45 },
	{ 0.0, -1.0 },
	{ -kCos45, -kCos45 },
	{ -1.0, 0.0 },
	{ -kCos45, kCos45 },
};

static CGFloat vectorLength(const CGPoint *v) {
	return sqrt(v->x*v->x + v->y*v->y);
}

static CGFloat dotProduct(const CGPoint *v1, const CGPoint *v2) {
	return v1->x*v2->x + v1->y*v2->y;
}

static void normalize(CGPoint *v) {
	CGFloat l = vectorLength(v);
	v->x /= l;
	v->y /= l;
}

@implementation ZDirection

+ (e_direction) directionFromEuclideanPointDelta:(CGPoint *)delta {
	normalize(delta);
	for (int i = 0; i < kDirectionMax; ++i) {
		CGFloat dotP = dotProduct(delta, &s_directionVectors[i]);
		if (dotP >= kCos30) {
			return i;
		}
	}
	return kDirectionMax;
}

@end
