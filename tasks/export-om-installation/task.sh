#!/bin/bash -eu

. $(dirname $0)/../../scripts/om-cmd

BACKUPNAME="installation-$(date '+%m%d%y-%H%M%S')"
om_cmd export-installation --output-file om-installation/$BACKUPNAME.zip
