//
//  recover.h
//  NetHackCocoa
//
//  Created by C.W. Betts on 10/21/15.
//  Copyright © 2015 Dirk Zimmermann. All rights reserved.
//

#ifndef recover_h
#define recover_h

#include <stdio.h>

int restore_savefile(const char *);
void set_levelfile_name(int);
int open_levelfile(int);
int create_savefile();
void copy_bytes(int,int);


#endif /* recover_h */
