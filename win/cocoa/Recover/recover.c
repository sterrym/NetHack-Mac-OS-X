//
//  recover.c
//  NetHackCocoa
//
//  Created by C.W. Betts on 10/21/15.
//  Copyright © 2015 Dirk Zimmermann. All rights reserved.
//

#include "recover.h"

/*
 *  Utility for reconstructing NetHack save file from a set of individual
 *  level files.  Requires that the `checkpoint' option be enabled at the
 *  time NetHack creates those level files.
 */
#include "config.h"
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>


static void FDECL(set_levelfile_name, (int));
static int FDECL(open_levelfile, (int));
static int NDECL(create_savefile);
static bool FDECL(copy_bytes, (int,int));

#ifndef WIN_CE
#define Fprintf	(void)fprintf
#else
#define Fprintf	(void)nhce_message
static void nhce_message(FILE*, const char*, ...);
#endif

#define Close	(void)close

#ifdef UNIX
#define SAVESIZE	(PL_NSIZ + 13)	/* save/99999player.e */
#else
# ifdef VMS
#define SAVESIZE	(PL_NSIZ + 22)	/* [.save]<uid>player.e;1 */
# else
#  ifdef WIN32
#define SAVESIZE	(PL_NSIZ + 40)  /* username-player.NetHack-saved-game */
#  else
#define SAVESIZE	FILENAME	/* from macconf.h or pcconf.h */
#  endif
# endif
#endif

#if defined(EXEPATH)
char *FDECL(exepath, (char *));
#endif

#if defined(__BORLANDC__) && !defined(_WIN32)
extern unsigned _stklen = STKSIZ;
#endif
char savename[SAVESIZE]; /* holds relative path of save file from playground */


#if 0
int
main(argc, argv)
int argc;
char *argv[];
{
	int argno;
	const char *dir = (char *)0;
#ifdef AMIGA
	char *startdir = (char *)0;
#endif
	
	
	if (!dir) dir = getenv("NETHACKDIR");
		if (!dir) dir = getenv("HACKDIR");
#if defined(EXEPATH)
			if (!dir) dir = exepath(argv[0]);
#endif
				if (argc == 1 || (argc == 2 && !strcmp(argv[1], "-"))) {
	    Fprintf(stderr,
				"Usage: %s [ -d directory ] base1 [ base2 ... ]\n", argv[0]);
#if defined(WIN32) || defined(MSDOS)
	    if (dir) {
			Fprintf(stderr, "\t(Unless you override it with -d, recover will look \n");
			Fprintf(stderr, "\t in the %s directory on your system)\n", dir);
		}
#endif
	    exit(EXIT_FAILURE);
				}
	
	argno = 1;
	if (!strncmp(argv[argno], "-d", 2)) {
		dir = argv[argno]+2;
		if (*dir == '=' || *dir == ':') dir++;
		if (!*dir && argc > argno) {
			argno++;
			dir = argv[argno];
		}
		if (!*dir) {
			Fprintf(stderr,
					"%s: flag -d must be followed by a directory name.\n",
					argv[0]);
			exit(EXIT_FAILURE);
		}
		argno++;
	}
#if defined(SECURE) && !defined(VMS)
	if (dir
# ifdef HACKDIR
		&& strcmp(dir, HACKDIR)
# endif
		) {
		(void) setgid(getgid());
		(void) setuid(getuid());
	}
#endif	/* SECURE && !VMS */
	
#ifdef HACKDIR
	if (!dir) dir = HACKDIR;
#endif
		
#ifdef AMIGA
		startdir = getcwd(0,255);
#endif
		if (dir && chdir((char *) dir) < 0) {
			Fprintf(stderr, "%s: cannot chdir to %s.\n", argv[0], dir);
			exit(EXIT_FAILURE);
		}
	
	while (argc > argno) {
		if (restore_savefile(argv[argno]) == 0)
			Fprintf(stderr, "recovered \"%s\" to %s\n",
					argv[argno], savename);
		argno++;
	}
#ifdef AMIGA
	if (startdir) (void)chdir(startdir);
#endif
		exit(EXIT_SUCCESS);
	/*NOTREACHED*/
		return 0;
}
#endif

static char lock[PATH_MAX];

void
set_levelfile_name(lev)
int lev;
{
	char *tf;
	
	tf = rindex(lock, '.');
	if (!tf) tf = lock + strlen(lock);
	(void) sprintf(tf, ".%d", lev);
}

int
open_levelfile(lev)
int lev;
{
	int fd;
	
	set_levelfile_name(lev);
#if defined(MICRO) || defined(WIN32) || defined(MSDOS)
	fd = open(lock, O_RDONLY | O_BINARY);
#else
	fd = open(lock, O_RDONLY, 0);
#endif
	return fd;
}

int
create_savefile()
{
	int fd;
	
#if defined(MICRO) || defined(WIN32) || defined(MSDOS)
	fd = open(savename, O_WRONLY | O_BINARY | O_CREAT | O_TRUNC, FCMASK);
#else
	fd = creat(savename, FCMASK);
#endif
	return fd;
}

bool
copy_bytes(ifd, ofd)
int ifd, ofd;
{
	char buf[BUFSIZ];
	ssize_t nfrom, nto;
	
	do {
		nfrom = read(ifd, buf, BUFSIZ);
		nto = write(ofd, buf, nfrom);
		if (nto != nfrom) {
			Fprintf(stderr, "file copy failed!\n");
			return false;
		}
	} while (nfrom == BUFSIZ);
	return true;
}

int
restore_savefile(basename)
const char *basename;
{
	int gfd, lfd, sfd;
	int lev, savelev, hpid;
	xchar levc;
	struct version_info version_data;
	
	/* level 0 file contains:
	 *	pid of creating process (ignored here)
	 *	level number for current level of save file
	 *	name of save file nethack would have created
	 *	and game state
	 */
	(void) strcpy(lock, basename);
	gfd = open_levelfile(0);
	if (gfd < 0) {
#if defined(WIN32) && !defined(WIN_CE)
		if(errno == EACCES) {
			Fprintf(stderr,
					"\nThere are files from a game in progress under your name.");
			Fprintf(stderr,"\nThe files are locked or inaccessible.");
			Fprintf(stderr,"\nPerhaps the other game is still running?\n");
		} else
			Fprintf(stderr,
					"\nTrouble accessing level 0 (errno = %d).\n", errno);
#endif
		Fprintf(stderr, "Cannot open level 0 for %s.\n", basename);
		return(-1);
	}
	if (read(gfd, (genericptr_t) &hpid, sizeof hpid) != sizeof hpid) {
		Fprintf(stderr, "%s\n%s%s%s\n",
				"Checkpoint data incompletely written or subsequently clobbered;",
				"recovery for \"", basename, "\" impossible.");
		Close(gfd);
		return(-1);
	}
	if (read(gfd, (genericptr_t) &savelev, sizeof(savelev))
		!= sizeof(savelev)) {
		Fprintf(stderr,
				"Checkpointing was not in effect for %s -- recovery impossible.\n",
				basename);
		Close(gfd);
		return(-1);
	}
	if ((read(gfd, (genericptr_t) savename, sizeof savename)
		 != sizeof savename) ||
		(read(gfd, (genericptr_t) &version_data, sizeof version_data)
		 != sizeof version_data)) {
			Fprintf(stderr, "Error reading %s -- can't recover.\n", lock);
			Close(gfd);
			return(-1);
		}
	
	/* save file should contain:
	 *	version info
	 *	current level (including pets)
	 *	(non-level-based) game state
	 *	other levels
	 */
	sfd = create_savefile();
	if (sfd < 0) {
		Fprintf(stderr, "Cannot create savefile %s.\n", savename);
		Close(gfd);
		return(-1);
	}
	
	lfd = open_levelfile(savelev);
	if (lfd < 0) {
		Fprintf(stderr, "Cannot open level of save for %s.\n", basename);
		Close(gfd);
		Close(sfd);
		return(-1);
	}
	
	if (write(sfd, (genericptr_t) &version_data, sizeof version_data)
		!= sizeof version_data) {
		Fprintf(stderr, "Error writing %s; recovery failed.\n", savename);
		Close(gfd);
		Close(sfd);
		return(-1);
	}
	
	if (!copy_bytes(lfd, sfd)) {
		Close(gfd);
		Close(sfd);
		Close(lfd);
		(void) unlink(lock);
		return -1;
	}
	Close(lfd);
	(void) unlink(lock);
	
	if (!copy_bytes(gfd, sfd)) {
		Close(gfd);
		Close(sfd);
		(void) unlink(lock);
		return -1;
	}
	Close(gfd);
	set_levelfile_name(0);
	(void) unlink(lock);
	
	for (lev = 1; lev < 256; lev++) {
		/* level numbers are kept in xchars in save.c, so the
		 * maximum level number (for the endlevel) must be < 256
		 */
		if (lev != savelev) {
			lfd = open_levelfile(lev);
			if (lfd >= 0) {
				/* any or all of these may not exist */
				levc = (xchar) lev;
				write(sfd, (genericptr_t) &levc, sizeof(levc));
				if (!copy_bytes(lfd, sfd)) {
					Close(lfd);
					(void) unlink(lock);
					return -1;
				}
				Close(lfd);
				(void) unlink(lock);
			}
		}
	}
	
	Close(sfd);
	
	return(0);
}

/*recover.c*/
