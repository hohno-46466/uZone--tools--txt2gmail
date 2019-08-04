#! /bin/sh

# Last update: Mon Aug  5 08:02:25 JST 2019

USER_FROM=hohno.46466@gmail.com

USER_TO=hohno_46466@yahoo.co.jp
SUBJECT="test mail"

(cat << "-EOF-"
To: $USER_TO
From: $USER_FROM
Subject: $SUBJECT

-EOF-
cat "$@" ) \
| msmtp -d -t
