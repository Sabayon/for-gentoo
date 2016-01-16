# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

# Build type
BUILD="autotools"

inherit autotools eutils flag-o-matic toolchain-funcs mysql-v2

SRC_URI="mirror://sabayon/dev-db/${P}.tar.gz"

# only to make repoman happy. it is really set in the eclass
IUSE="$IUSE"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~amd64 ~x86"

# When MY_EXTRAS is bumped, the index should be revised to exclude these.
# This is often broken still
EPATCH_EXCLUDE=''

# Most of these are in the eclass
COMMON_DEPEND="
	static? ( dev-libs/lzo[static-libs] )
	dev-libs/lzo
	dev-util/google-perftools"
DEPEND="${COMMON_DEPEND}
	|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
	>=sys-devel/libtool-2.2.10"
RDEPEND="${COMMON_DEPEND} ${RDEPEND}"

# Please do not add a naive src_unpack to this ebuild
# If you want to add a single patch, copy the ebuild to an overlay
# and create your own mysql-extras tarball, looking at 000_index.txt
src_prepare() {
	sed -i \
		-e '/^noinst_PROGRAMS/s/basic-t//g' \
		"${S}"/unittest/mytap/t/Makefile.am

	# googlestats plugin has problems with -D_FORTIFY_SOURCE=2
	# and also tests are failing. Upstream has been notified.
	append-cppflags "-U_FORTIFY_SOURCE"

	# mysql_fx.eclass expects to find a mysql-extras
	# directory. Google MySQL does not have any extras
	# at this time.
	mkdir -p "${WORKDIR}/mysql-extras" || die

	# Fix compilation without USE=static, upstreamed
	epatch "${FILESDIR}/google-mysql-dynlink-fixes.patch"
	# Fix system google-perftools header detection
	# our google-perftools are installed in /usr/include/gperftools
	epatch "${FILESDIR}/google-mysql-fix-gperftools-includedir.patch"
	rm "${S}"/google-perftools || die
	rm -r "${S}"/google-perftools-1.8.3 || die
	# Unbundle lzo
	rm "${S}"/lzo || die
	rm -r "${S}"/lzo-2.03 || die
	# Unbundle ncurses, broken autoconf as well
	rm "${S}"/ncurses || die
	rm -r "${S}"/ncurses-5.7 || die

	eautoreconf
}

# Official test instructions:
# USE='berkdb -cluster -embedded extraengine perl ssl community' \
# FEATURES='test userpriv -usersandbox' \
# ebuild google-mysql-X.X.XX.ebuild \
# digest clean package
src_test() {
	# Bug #213475 - MySQL _will_ object strenously if your machine is named
	# localhost. Also causes weird failures.
	[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

	emake check || die "make check failed"
	if ! use "minimal" ; then
		if [[ $UID -eq 0 ]]; then
			die "Testing with FEATURES=-userpriv is no longer supported by upstream. Tests MUST be run as non-root."
		fi
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"
		cd "${S}"
		einfo ">>> Test phase [test]: ${CATEGORY}/${PF}"
		local retstatus_unit
		local retstatus_ns
		local retstatus_ps
		local t
		addpredict /this-dir-does-not-exist/t9.MYI

		# Ensure that parallel runs don't die
		export MTR_BUILD_THREAD="$((${RANDOM} % 100))"

		# archive_gis really sucks a lot, but it's only relevant for the
		# USE=extraengines case
		case ${PV} in
			5.0.42)
			mysql-v2_disable_test "archive_gis" "Totally broken in 5.0.42"
			;;

			5.0.4[3-9]|5.0.[56]*|5.0.70|5.0.87)
			[ "$(tc-endian)" == "big" ] && \
			mysql-v2_disable_test \
				"archive_gis" \
				"Broken in 5.0.43-70 and 5.0.87 on big-endian boxes only"
			;;
		esac

		# This was a slight testcase breakage when the read_only security issue
		# was fixed.
		case ${PV} in
			5.0.54|5.0.51*)
			mysql-v2_disable_test \
				"read_only" \
				"Broken in 5.0.51-54, output in wrong order"
			;;
		esac

		# Ditto to read_only
		[ "${PV}" == "5.0.51a" ] && \
			mysql-v2_disable_test \
				"view" \
				"Broken in 5.0.51, output in wrong order"

		# x86-specific, OOM issue with some subselects on low memory servers
		[ "${PV}" == "5.0.54" ] && \
			[ "${ARCH/x86}" != "${ARCH}" ] && \
			mysql-v2_disable_test \
				"subselect" \
				"Testcase needs tuning on x86 for oom condition"

		# Broke with the YaSSL security issue that didn't affect Gentoo.
		[ "${PV}" == "5.0.56" ] && \
			for t in openssl_1 rpl_openssl rpl_ssl ssl \
				ssl_8k_key ssl_compress ssl_connect ; do \
				mysql-v2_disable_test \
					"$t" \
					"OpenSSL tests broken on 5.0.56"
			done

		# New test was broken in first time
		# Upstream bug 41066
		# http://bugs.mysql.com/bug.php?id=41066
		[ "${PV}" == "5.0.72" ] && \
			mysql-v2_disable_test \
				"status2" \
				"Broken in 5.0.72, new test is broken, upstream bug #41066"

		# The entire 5.0 series has pre-generated SSL certificates, they have
		# mostly expired now. ${S}/mysql-tests/std-data/*.pem
		# The certs really SHOULD be generated for the tests, so that they are
		# not expiring like this. We cannot do so ourselves as the tests look
		# closely as the cert path data, and we do not have the CA key to regen
		# ourselves. Alternatively, upstream should generate them with at least
		# 50-year validity.
		#
		# Known expiry points:
		# 4.1.*, 5.0.0-5.0.22, 5.1.7: Expires 2013/09/09
		# 5.0.23-5.0.77, 5.1.7-5.1.22?: Expires 2009/01/27
		# 5.0.78-5.0.90, 5.1.??-5.1.42: Expires 2010/01/28
		#
		# mysql-test/std_data/untrusted-cacert.pem is MEANT to be
		# expired/invalid.
		case ${PV} in
			5.0.*|5.1.*|5.4.*|5.5.*)
				for t in openssl_1 rpl_openssl rpl.rpl_ssl rpl.rpl_ssl1 ssl ssl_8k_key \
					ssl_compress ssl_connect rpl.rpl_heartbeat_ssl ; do \
					mysql-v2_disable_test \
						"$t" \
						"These OpenSSL tests break due to expired certificates"
				done
			;;
		esac

		# These are also failing in MySQL 5.1 for now, and are believed to be
		# false positives:
		#
		# main.mysql_comment, main.mysql_upgrade, main.information_schema,
		# funcs_1.is_columns_mysql funcs_1.is_tables_mysql funcs_1.is_triggers:
		# fails due to USE=-latin1 / utf8 default
		#
		# main.mysql_client_test:
		# segfaults at random under Portage only, suspect resource limits.
		#
		# main.not_partition:
		# Failure reason unknown at this time, must resolve before package.mask
		# removal FIXME
		case ${PV} in
			5.1.*|5.4.*|5.5.*)
			for t in main.mysql_client_test main.mysql_comments \
				main.mysql_upgrade  \
				main.information_schema \
				main.not_partition funcs_1.is_columns_mysql \
				funcs_1.is_tables_mysql funcs_1.is_triggers; do
				mysql-v2_disable_test  "$t" "False positives in Gentoo"
			done
			;;
		esac

		# New failures in 5.1.50/5.1.51, reported by jmbsvicetto.
		# These tests are picking up a 'connect-timeout' config from somewhere,
		# which is not valid, and since it does not have 'loose-' in front of
		# it, it's causing a failure
		case ${PV} in
			5.1.5*|5.4.*|5.5.*|6*)
			for t in rpl.rpl_mysql_upgrade main.log_tables_upgrade ; do
				mysql-v2_disable_test  "$t" \
					"False positives in Gentoo: connect-timeout"
			done
			;;
		esac

		use profiling && use community \
		|| mysql-v2_disable_test main.profiling \
			"Profiling test needs profiling support"

		if [ "${PN}" == "mariadb" ]; then
			for t in \
				parts.part_supported_sql_func_ndb \
				parts.partition_auto_increment_ndb ; do
					mysql-v2_disable_test $t "ndb not supported in mariadb"
			done
		elif [ "${PN}" == "google-mysql" ]; then
			case ${PV} in
				5.1.63.*)
				# Upstream broken tests
				for t in mapped_users.mapped_users main.partition_not_blackhole ; do
					mysql-v2_disable_test "$t" "$t is broken upstream"
				done
				# *** buffer overflow detected *** mysqld terminated
				# -D_FORTIFY_SOURCE=2 causes this.
				#for t in rpl.rpl_googlestats_dml main.show_stats_server_status ; do
				#	mysql-v2_disable_test "$t" "Buffer overflow bug"
				#done
				# Internal check failed, broken upstream
				mysql-v2_disable_test "main.partition_innodb_plugin" "Broken upstream"
				;;
			esac
		fi

		# This fail with XtraDB in place of normal InnoDB
		# TODO: test if they are broken with the rest of the Percona patches
		if xtradb_patch_available && use xtradb ; then
			for t in main.innodb innodb.innodb_bug51378 \
				main.information_schema_db main.mysqlshow \
				main.innodb-autoinc main.innodb_bug21704 \
				main.innodb_bug44369 main.innodb_bug46000 \
				main.index_merge_innodb \
				innodb.innodb innodb.innodb_misc1 innodb.innodb_bug52663 \
				innodb.innodb-autoinc innodb.innodb-autoinc-44030 \
				innodb.innodb_bug21704 innodb.innodb_bug44369 \
				innodb.innodb_bug46000 innodb.innodb_bug48024 \
				innodb.innodb_bug49164 innodb.innodb_bug51920 \
				innodb.innodb_bug54044 \
				; do
					mysql-v2_disable_test $t "tests broken in xtradb"
			done
		fi

		if ! use extraengine ; then
			# bug 332565
			for t in main.range ; do
				mysql-v2_disable_test $t "Test $t requires USE=extraengine"
			done
			# bug 401673
			for t in federated.federated_plugin ; do
				mysql-v2_disable_test $t "Test $t requires USE=extraengine (Need federated engine)"
			done
		fi

		# create directories because mysqladmin might make out of order
		mkdir -p "${S}"/mysql-test/var-{ps,ns}{,/log}

		# We run the test protocols seperately
		emake test-unit
		retstatus_unit=$?
		[[ $retstatus_unit -eq 0 ]] || eerror "test-unit failed"

		emake test-ns force="--force --vardir=${S}/mysql-test/var-ns"
		retstatus_ns=$?
		[[ $retstatus_ns -eq 0 ]] || eerror "test-ns failed"
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

		emake test-ps force="--force --vardir=${S}/mysql-test/var-ps"
		retstatus_ps=$?
		[[ $retstatus_ps -eq 0 ]] || eerror "test-ps failed"
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

		# TODO:
		# When upstream enables the pr and nr testsuites, we need those as well.

		# Cleanup is important for these testcases.
		pkill -9 -f "${S}/ndb" 2>/dev/null
		pkill -9 -f "${S}/sql" 2>/dev/null
		failures=""
		[[ $retstatus_unit -eq 0 ]] || failures="${failures} test-unit"
		[[ $retstatus_ns -eq 0 ]] || failures="${failures} test-ns"
		[[ $retstatus_ps -eq 0 ]] || failures="${failures} test-ps"
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"
		[[ -z "$failures" ]] || die "Test failures: $failures"
		einfo "Tests successfully completed"
	else
		einfo "Skipping server tests due to minimal build."
	fi
}

pkg_config() {
	# Sabayon bug #3647, Gentoo bug #463680
	local run_mysqld="${EROOT}/var/run/mysqld"
	if [ ! -d "${run_mysqld}" ]; then
		mkdir "${run_mysqld}" || die
	fi
	chown -R mysql:mysql "${run_mysqld}" || die
	mysql-v2_pkg_config
}
