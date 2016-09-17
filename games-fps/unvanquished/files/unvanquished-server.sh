#!/bin/sh
cd /var/lib/unvanquished-server

[ -f /var/lib/unvanquished-server/.Unvanquished/main/server.cfg ] \
	|| ln -sf /etc/unvanquished/server.cfg \
	/var/lib/unvanquished-server/.Unvanquished/main/server.cfg
[ -f /var/lib/unvanquished-server/.Unvanquished/main/maprotation.cfg ] \
	|| ln -sf /etc/unvanquished/maprotation.cfg \
	/var/lib/unvanquished-server/.Unvanquished/main/maprotation.cfg

exec /usr/bin/unvanquishedded \
	+exec server.cfg \
	+set fs_basepath "/usr/share/unvanquished" \
	"$@"

