#!/bin/bash

BACKUPDIR=~/backups_sahare
name=$(date '+%Y-%m-%d-%H:%M:%S')
BACKUPFILE=$BACKUPDIR"/"$name".pgdump"
APP=tranquil-caverns-87454
DATASTOREURL=https://data.heroku.com/datastores/dc742fea-b2eb-48fe-9477-189f1c28a034
mkdir -p "$BACKUPDIR"
heroku pg:backups:capture
heroku pg:backups:download -a $APP -o "$BACKUPFILE"
rc=$?;
if [[ $rc != 0 ]]; then
  echo "Failed to download the backup, please, do it manually, starting chromium..."
  chromium-browser "$DATASTOREURL"
fi
