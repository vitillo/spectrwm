.include <bsd.xconf.mk>

PREFIX?=/usr/local

BINDIR=${PREFIX}/bin
SUBDIR= lib

PROG=spectrwm
#MAN=spectrwm_pt.1 spectrwm_ru.1 spectrwm_es.1 spectrwm_it.1
MAN=spectrwm.1

CFLAGS+=-std=c99 -Wmissing-prototypes -Wall -Wextra -Wshadow -Wno-uninitialized -g
# Uncomment define below to disallow user settable clock format string
#CFLAGS+=-DSWM_DENY_CLOCK_FORMAT
CPPFLAGS+= -I${X11BASE}/include -I${X11BASE}/include/freetype2
LDADD+=-lutil -L${X11BASE}/lib -lX11 -lX11-xcb -lxcb-aux -lxcb-icccm -lxcb-keysyms -lxcb-randr -lxcb-xtest -lXft -lXcursor
BUILDVERSION != sh "${.CURDIR}/buildver.sh"
.if !${BUILDVERSION} == ""
CPPFLAGS+= -DSPECTRWM_BUILDSTR=\"$(BUILDVERSION)\"
.endif

MANDIR= ${PREFIX}/man/man

#spectrwm_ru.cat1: spectrwm_ru.1
#	 nroff -mandoc ${.CURDIR}/spectrwm_ru.1 > ${.TARGET}

obj: _xenocara_obj

beforeinstall:
	ln -sf ${BINDIR}/${PROG} ${BINDIR}/scrotwm

# clang targets
.if ${.TARGETS:M*analyze*}
CC=clang
CXX=clang++
CPP=clang -E
CFLAGS+=--analyze
.endif

analyze: all
clang: all
.include <bsd.prog.mk>
.include <bsd.xorg.mk>
