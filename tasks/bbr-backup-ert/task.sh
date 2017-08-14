#!/bin/bash -eu

. "$(dirname $0)"/../../scripts/export-director-metadata

pushd ert-backup-artifact
  cat << "EOF"
 ____                    _               ____  ____  ____
|  _ \ _   _ _ __  _ __ (_)_ __   __ _  | __ )| __ )|  _ \
| |_) | | | | '_ \| '_ \| | '_ \ / _` | |  _ \|  _ \| |_) |
|  _ <| |_| | | | | | | | | | | | (_| | | |_) | |_) |  _ < _ _ _
|_| \_\\__,_|_| |_|_| |_|_|_| |_|\__, | |____/|____/|_| \_(_|_|_)
                                 |___/
EOF
  ../binary/bbr deployment --target "${BOSH_ADDRESS}" \
  --username "${BOSH_CLIENT}" \
  --deployment "${ERT_DEPLOYMENT_NAME}" \
  --ca-cert "${BOSH_CA_CERT_PATH}" \
  backup --with-manifest

  BACKUPNAME="ert-backup-$(date '+%m%d%y-%H%M%S')"
  echo Archiving $BACKUPNAME
  tar -cvf $BACKUPNAME.tar -- *
  cat << "EOF"
 _____                             _   _
| ____|_ __   ___ _ __ _   _ _ __ | |_(_)_ __   __ _
|  _| | '_ \ / __| '__| | | | '_ \| __| | '_ \ / _` |
| |___| | | | (__| |  | |_| | |_) | |_| | | | | (_| |_ _ _
|_____|_| |_|\___|_|   \__, | .__/ \__|_|_| |_|\__, (_|_|_)
                       |___/|_|                |___/
EOF
  gpg --batch --yes --quiet --cipher-algo AES256 --passphrase=$PASSPHRASE -c $BACKUPNAME.tar > /dev/null
  mv $BACKUPNAME.tar.pgp $BACKUPNAME.backup
popd
