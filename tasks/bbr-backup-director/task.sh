#!/bin/bash -eu

. "$(dirname $0)"/../../scripts/export-director-metadata

om_cmd curl -p /api/v0/deployed/director/credentials/bbr_ssh_credentials > bbr_keys.json
BOSH_PRIVATE_KEY=$(jq -r '.credential.value.private_key_pem' bbr_keys.json)

pushd director-backup-artifact
  ../binary/bbr director --host "${BOSH_ADDRESS}" \
  --username bbr \
  --private-key-path <(echo "${BBR_PRIVATE_KEY}") \
  backup

  BACKUPNAME="director-backup-$(date '+%m%d%y-%H%M%S')".tar
  echo Archiving $BACKUPNAME
  tar -cvf $BACKUPNAME -- *
  cat << "EOF"
 _____                             _   _
| ____|_ __   ___ _ __ _   _ _ __ | |_(_)_ __   __ _
|  _| | '_ \ / __| '__| | | | '_ \| __| | '_ \ / _` |
| |___| | | | (__| |  | |_| | |_) | |_| | | | | (_| |_ _ _
|_____|_| |_|\___|_|   \__, | .__/ \__|_|_| |_|\__, (_|_|_)
                       |___/|_|                |___/
EOF
  gpg --batch --yes --quiet --cipher-algo AES256 --passphrase=$PASSPHRASE -c $BACKUPNAME > /dev/null
  mv $BACKUPNAME.tar.gpg $BACKUPNAME.backup
popd
