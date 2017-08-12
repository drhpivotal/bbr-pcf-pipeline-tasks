#!/bin/bash -eu

. $(dirname $0)/../../scripts/om-cmd

BACKUPNAME="installation-$(date '+%m%d%y-%H%M%S').zip"
om_cmd export-installation --output-file om-installation/$BACKUPNAME
echo Encrypting $BACKUPNAME
gpg --yes --quiet --batch --passphrase=$PASSPHRASE -c om-installation/$BACKUPNAME
