//
//  NhMapWindow.m
//  SlashEM
//
//  Created by dirk on 12/31/09.
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

#import "NhMapWindow.h"

#include "hack.h"

static const int aNoGlyph = kNoGlyph;

@implementation NhMapWindow {
	int *bgGlyphs;

}

- (instancetype) initWithType:(int)t {
	if (self = [super initWithType:t]) {
		NSLog(@"map window %p", self);
		size_t numBytes = COLNO * ROWNO * sizeof(int);
		glyphs = malloc(numBytes);
		memset_pattern4(glyphs, &aNoGlyph, numBytes);
		bgGlyphs = malloc(numBytes);
		memset_pattern4(bgGlyphs, &aNoGlyph, numBytes);
	}
	return self;
}

- (void) printGlyph:(int)glyph atX:(xchar)x y:(xchar)y backgroundGlyph:(int)bgGlyph {
	glyphs[y * COLNO + x] = glyph;
	bgGlyphs[y * COLNO + x] = bgGlyph;
}

- (void) printGlyph:(int)glyph atX:(xchar)x y:(xchar)y {
	[self printGlyph:glyph atX:x y:y backgroundGlyph:NO_GLYPH];
}

- (void)setCursX:(xchar)x y:(xchar)y {
	cursorX = x;
	cursorY = y;
}

- (void)getCursX:(xchar *)px y:(xchar *)py {
	*px = cursorX;
	*py = cursorY;
}

- (int) glyphAtX:(xchar)x y:(xchar)y {
	return glyphs[y * COLNO + x];
}

- (int) backgroundGlyphAtX:(xchar)x y:(xchar)y {
	return bgGlyphs[y * COLNO + x];
}

- (void) clear {
	[super clear];
	size_t numBytes = COLNO * ROWNO * sizeof(int);
	memset_pattern4(glyphs, &aNoGlyph, numBytes);
	memset_pattern4(bgGlyphs, &aNoGlyph, numBytes);
}

- (void) dealloc {
	free(glyphs);
	free(bgGlyphs);
}

@end
