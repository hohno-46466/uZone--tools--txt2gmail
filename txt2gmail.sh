untab #! /bin/sh

# txt2gmail.sh

# Last update: Mon Aug  5 08:02:25 JST 2019

USER_FROM=example.99999@gmail.com

USER_TO=example_99999@yahoo.co.jp
SUBJECT="test mail"

msmtp=/usr/local/bin/msmtp

while [ "x$1" != "x" ]; do
    # XXX20190806 # このあたりはまだいい加減
    # echo "[ $1 ]"
    if [ "x$1" = "x-s" -a "x$2" != "x" ]; then
        SUBJECT="$2"
        shift
        shift
        break;
    else
        break;
    fi
    shift
done

if [ "x$1" != "x" ]; then
    USER_TO="$(echo $@ | sed 's/ /,/g')"
fi

echo ""
echo "(From: $USER_FROM)"
echo "(To: $USER_TO)"
echo "(Subject: $SUBJECT)"
echo ""

[ -x $msmtp ] || exit 1

(cat << -EOF-
To: $USER_TO
From: $USER_FROM
Subject: $SUBJECT

-EOF-
 cat ) \
    | $msmtp -d -t

echo ""
echo "(From: $USER_FROM)"
echo "(To: $USER_TO)"
echo "(Subject: $SUBJECT)"
echo ""
