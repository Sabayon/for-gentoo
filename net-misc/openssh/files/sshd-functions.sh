#!/bin/bash
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SSHD_CONFDIR=${SSHD_CONFDIR:-/etc/ssh}
SSHD_CONFIG=${SSHD_CONFIG:-${SSHD_CONFDIR}/sshd_config}
SSHD_PIDFILE=${SSHD_PIDFILE:-/var/run/${SVCNAME}.pid}
SSHD_BINARY=${SSHD_BINARY:-/usr/sbin/sshd}

if ! type -p eerror; then
	# assuming that we're running outside runscript
	eval 'eerror() { echo "${1}" >&2; }'
	eval 'ebegin() { echo "${1}"; }'
	eval 'eend() { if [ "${1}" = "0" ]; then echo "OK"; else echo "ERROR" >&2; fi; }'
fi

checkconfig() {
	if [ ! -d /var/empty ] ; then
		mkdir -p /var/empty || return 1
	fi

	if [ ! -e "${SSHD_CONFDIR}"/sshd_config ] ; then
		eerror "You need an ${SSHD_CONFDIR}/sshd_config file to run sshd"
		eerror "There is a sample file in /usr/share/doc/openssh"
		return 1
	fi

	gen_keys || return 1

	[ "${SSHD_PIDFILE}" != "/var/run/sshd.pid" ] \
		&& SSHD_OPTS="${SSHD_OPTS} -o PidFile=${SSHD_PIDFILE}"
	[ "${SSHD_CONFDIR}" != "/etc/ssh" ] \
		&& SSHD_OPTS="${SSHD_OPTS} -f ${SSHD_CONFDIR}/sshd_config"

	"${SSHD_BINARY}" -t ${SSHD_OPTS} || return 1
}

gen_key() {
	keytype=$1
	[ $# -eq 1 ] && ks="${keytype}_"
	key="${SSHD_CONFDIR}/ssh_host_${ks}key"
	if [ ! -e "${key}" ] ; then
		ebegin "Generating ${keytype} host key"
		ssh-keygen -t ${keytype} -f "${key}" -N ''
		eend $? || return $?
	fi
}

gen_keys() {
	if egrep -q '^[[:space:]]*Protocol[[:space:]]+.*1' "${SSHD_CONFDIR}"/sshd_config ; then
		gen_key rsa1 "" || return 1
	fi
	gen_key dsa && gen_key rsa && gen_key ecdsa
	return $?
}

