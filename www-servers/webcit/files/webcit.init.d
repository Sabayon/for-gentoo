#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

CITSERVER=${SVCNAME#*.}
if [ -n "${CITSERVER}" ] && [ ${SVCNAME} != "webcit" ]; then
        WCPID="/var/run/webcit.${CITSERVER}.pid"
else    
        WCPID="/var/run/webcit.pid"
fi

depend() {
	need net
}

start() {
	ebegin "Starting ${SVCNAME}"
        start-stop-daemon --start --background \
		--exec /usr/sbin/webcit --make-pidfile \
		--pidfile "${WCPID}"  -- $WEBCIT_OPTS
	eend $? "Failed to start WebCit"
}

stop() {
	ebegin "Stopping ${SVCNAME}"
	start-stop-daemon --stop \
		--exec /usr/sbin/webcit --pidfile "${WCPID}"
	eend $? "Failed to stop ${SVCNAME}"
}

restart() {
	ebegin "Restarting ${SVCNAME}"
	svc_stop && sleep 3 && svc_start
	eend $? "Failed to restart WebCit"
}

