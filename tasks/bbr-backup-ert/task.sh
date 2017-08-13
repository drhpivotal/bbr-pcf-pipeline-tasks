#!/bin/bash -eu

. "$(dirname $0)"/../../scripts/export-director-metadata

pushd ert-backup-artifact
  ../binary/bbr deployment --target "${BOSH_ADDRESS}" \
  --username "${BOSH_CLIENT}" \
  --deployment "${ERT_DEPLOYMENT_NAME}" \
  --ca-cert "${BOSH_CA_CERT_PATH}" \
  backup --with-manifest

  BACKUPNAME="ert-backup-$(date '+%m%d%y-%H%M%S').tar"
  echo Archiving $BACKUPNAME
  tar -cvf $BACKUPNAME -- *
  echo " _____                             _   _"
  echo "| ____|_ __   ___ _ __ _   _ _ __ | |_(_)_ __   __ _"
  echo "|  _| | '_ \ / __| '__| | | | '_ \| __| | '_ \ / _` |"
  echo "| |___| | | | (__| |  | |_| | |_) | |_| | | | | (_| |_ _ _"
  echo "|_____|_| |_|\___|_|   \__, | .__/ \__|_|_| |_|\__, (_|_|_)"
  echo "                       |___/|_|                |___/"
  gpg --batch --yes --quiet --passphrase=$PASSPHRASE -c $BACKUPNAME
popd
