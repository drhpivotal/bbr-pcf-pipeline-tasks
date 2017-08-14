#!/bin/bash -eu

. $(dirname $0)/../../scripts/om-cmd

BACKUPNAME="installation-$(date '+%m%d%y-%H%M%S')"
om_cmd export-installation --output-file om-installation/$BACKUPNAME.zip
cat << "EOF"
 _____                             _   _
| ____|_ __   ___ _ __ _   _ _ __ | |_(_)_ __   __ _
|  _| | '_ \ / __| '__| | | | '_ \| __| | '_ \ / _` |
| |___| | | | (__| |  | |_| | |_) | |_| | | | | (_| |_ _ _
|_____|_| |_|\___|_|   \__, | .__/ \__|_|_| |_|\__, (_|_|_)
                       |___/|_|                |___/
EOF
gpg --batch --yes --quiet --cipher-algo AES256 --passphrase=$PASSPHRASE -c $BACKUPNAME.zip > /dev/null
mv $BACKUPNAME.zip $BACKUPNAME.backup
