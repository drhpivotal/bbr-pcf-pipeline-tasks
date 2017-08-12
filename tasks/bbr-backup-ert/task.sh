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
  echo Encrypting $BACKUPNAME
  gpg --yes --quiet --batch --passphrase=$PASSPHRASE -c $BACKUPNAME
popd
