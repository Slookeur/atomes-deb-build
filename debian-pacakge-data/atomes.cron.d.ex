#
# Regular cron jobs for the atomes package
#
0 4	* * *	root	[ -x /usr/bin/atomes_maintenance ] && /usr/bin/atomes_maintenance
