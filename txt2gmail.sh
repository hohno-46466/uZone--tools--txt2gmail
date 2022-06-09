#!/bin/sh -eu

# txt2gmail.sh

# First version: Mon Aug  5 08:02:25 JST 2019
# Prev update: Tue Oct 29 14:36:34 JST 2019
# Last update: Fri Jun 10 05:33:06 JST 2022

# ----------------------------------------------------------

PNAME=$(basename $0)

# ----------------------------------------------------------

USER_FROM=example.99999@gmail.com
USER_TO=example_99999@yahoo.co.jp
SUBJECT="test mail"

# ----------------------------------------------------------

help () {
    echo ""
    echo "usage: $PNAME ([-d [-d [-d ...]]] | [-x]) [-s \"subjext\"] [mail_addr]"
    echo "usage: command | $PNAME ([-d [-d [-d ...]]] | [-x]) [-s \"subjext\"] [mail_addr]"
    echo ""
    echo "example: date | $PNAME -x -s \"test mail\" user_1234@example.com"
    echo ""
}

help_exit () {
    help
    exit $1
}

message_exit () {
    echo "$2"
    exit $1
}

# ----------------------------------------------------------
# ----------------------------------------------------------

DEBUGLEVEL=0

while [ $# -ge 1 ] && [ "x$1" != "x" ]; do
    [ $# -ge 1 -a "x$1" = "x-d" ] && DEBUGLEVEL=$(($DEBUGLEVEL + 1))
    [ $# -ge 1 -a "x$1" = "x-x" ] && DEBUGLEVEL=-1
    [ $# -ge 1 -a "x$1" = "x-h" ] && help_exit 9
    [ $# -ge 1 -a "x$1" = "x--help" ] && help_exit 9
    [ $# -ge 1 -a x$( echo "x$1" | grep "x-" ) = "x"  ] && break
    shift
done

[ "x$DEBUGLEVEL" = "x" ] && DEBUGLEVEL=2

echo "DEBUGLEVEL = $DEBUGLEVEL"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Full path name for msmtp command
if [ $DEBUGLEVEL -gt 2 ]; then
    msmtp=/bin/cat
    msmtpOpt="-n"
else
    # msmtp=/usr/local/bin/msmtp
    # msmtp=/usr/bin/msmtp
    msmtp=$(which msmtp)
    msmtpOpt="-d -t"
fi

[ "x$msmtp" = "x" ] && message_exit 1 "Can't find msmtp"
[ -x $msmtp ] || message_exit 2 "Can't find msmtp"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "Debug: ArgN = $#"
echo "Debug: Argv = $1"

while [ $# -ge 1 ] && [ "x$1" != "x" ]; do
    # XXX20190806 # このあたりはまだいい加減
    echo "[ Arg1(0) =  $1 ]"
    if [ $# -ge 2 -a "x$1" = "x-s" -a "x$2" != "x" ]; then
	echo "[ Arg1(1) =  $1 ]"
        SUBJECT="$2"
	echo "[ Arg1(2) =  $1 ]"
        shift
	echo "[ Arg1(3) =  $1 ]"
        shift
	echo "[ Arg1(4) =  $1 ]"
        break;
    else
        break;
    fi
    shift
done

shift

if [ $# -ge 1 ] && [ "x$1" != "x" ]; then
    echo "[ Arg1(5) =  $1 ]"
    USER_TO="$(echo $@ | sed 's/ /,/g')"
fi

if [ $DEBUGLEVEL -ge 2 ]; then
    echo "Debug Info:"
    echo "(From: $USER_FROM)"
    echo "(To: $USER_TO)"
    echo "(Subject: $SUBJECT)"
    echo ""
fi

(cat << -EOF-;
To: $USER_TO
From: $USER_FROM
Subject: $SUBJECT

-EOF-
 cat ) | $msmtp $msmtpOpt

exit 0

# echo ""
# echo "(From: $USER_FROM)"
# echo "(To: $USER_TO)"
# echo "(Subject: $SUBJECT)"
# echo ""
