#!/bin/sh
exec /usr/bin/unvanquishedclient \
	-pakpath "/usr/share/unvanquished/pkg" \
	-libpath "/usr/@LIBDIR@/unvanquished" \
	"$@"
